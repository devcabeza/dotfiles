#!/usr/bin/env node

// Resuelve la raíz del proyecto activo en Herdr.
// Prioridad:
// 1. Archivo editado recientemente por el agente activo (Claude o Antigravity/AGY).
// 2. Directorio en primer plano del pane (foreground_cwd reportado por herdr).
// 3. Directorio de trabajo del pane (cwd de herdr o HERDR_ACTIVE_PANE_CWD).
// 4. Directorio del proceso actual (process.cwd).
//
// Para cualquier ruta, busca hacia arriba la presencia de un repositorio Git (.git).

import { execFileSync } from 'node:child_process';
import { closeSync, existsSync, openSync, readdirSync, readSync, statSync } from 'node:fs';
import { homedir, tmpdir } from 'node:os';
import { delimiter, dirname, isAbsolute, join, relative } from 'node:path';

// Asegurar PATH completo en Linux (Nix, mise, cargo, local/bin)
if (process.platform !== 'win32') {
  const extra = ['.local/bin', '.local/share/mise/shims', '.cargo/bin', '.nix-profile/bin'].map((d) => join(homedir(), d));
  process.env.PATH = [...extra, process.env.PATH].join(delimiter);
}

const HERDR = process.env.HERDR_BIN_PATH || 'herdr';
const CLAUDE_DIR = process.env.CLAUDE_CONFIG_DIR || join(homedir(), '.claude');
const AGY_DIR = process.env.ANTIGRAVITY_CLI_CONFIG_DIR || join(homedir(), '.gemini', 'antigravity-cli');

const EDIT_TOOLS = new Set(['Write', 'Edit', 'NotebookEdit', 'write_file', 'edit_file']);
const MAX_TAIL = 64 * 1024 * 1024;
const IGNORED = [tmpdir(), CLAUDE_DIR, join(homedir(), '.gemini')];

function isInside(parent, path) {
  const rel = relative(parent, path);
  return rel !== '' && !rel.startsWith('..') && !isAbsolute(rel);
}

export function findProjectRoot(targetPath) {
  if (!targetPath) return null;
  let dir;
  try {
    const stat = statSync(targetPath);
    dir = stat.isDirectory() ? targetPath : dirname(targetPath);
  } catch {
    dir = dirname(targetPath);
  }
  const startDir = dir;
  while (true) {
    if (existsSync(join(dir, '.git'))) return dir;
    const parent = dirname(dir);
    if (parent === dir) break;
    dir = parent;
  }
  return startDir;
}

export function getPaneInfo(paneId) {
  if (!paneId) return null;
  try {
    const out = execFileSync(HERDR, ['pane', 'get', paneId], {
      encoding: 'utf8',
      windowsHide: true,
      stdio: ['ignore', 'pipe', 'ignore'],
    });
    return JSON.parse(out)?.result?.pane ?? null;
  } catch {
    return null;
  }
}

function readTail(file) {
  try {
    const { size } = statSync(file);
    const length = Math.min(size, MAX_TAIL);
    const buffer = Buffer.alloc(length);
    const fd = openSync(file, 'r');
    readSync(fd, buffer, 0, length, size - length);
    closeSync(fd);
    return buffer.toString('utf8');
  } catch {
    return '';
  }
}

function claudeLastEditedPath(sessionId) {
  const projects = join(CLAUDE_DIR, 'projects');
  if (!existsSync(projects)) return null;

  let transcript = null;
  for (const project of readdirSync(projects)) {
    const file = join(projects, project, `${sessionId}.jsonl`);
    if (existsSync(file)) {
      transcript = file;
      break;
    }
  }
  if (!transcript) return null;

  const lines = readTail(transcript).split('\n');
  for (let i = lines.length - 1; i >= 0; i--) {
    const line = lines[i];
    if (!line.includes('_path"')) continue;
    let entry;
    try {
      entry = JSON.parse(line);
    } catch {
      continue;
    }
    const blocks = entry.message?.content;
    if (!Array.isArray(blocks)) continue;
    for (const block of blocks.toReversed()) {
      if (block.type !== 'tool_use' || !EDIT_TOOLS.has(block.name)) continue;
      const path = block.input?.file_path || block.input?.notebook_path;
      if (!path || IGNORED.some((dir) => isInside(dir, path))) continue;
      if (existsSync(dirname(path))) return path;
    }
  }
  return null;
}

function agyLastEditedPath(sessionId) {
  const transcript = join(AGY_DIR, 'brain', sessionId, '.system_generated', 'logs', 'transcript.jsonl');
  if (!existsSync(transcript)) return null;

  const lines = readTail(transcript).split('\n');
  for (let i = lines.length - 1; i >= 0; i--) {
    const line = lines[i];
    if (!line.includes('write_file') && !line.includes('edit_file')) continue;
    let entry;
    try {
      entry = JSON.parse(line);
    } catch {
      continue;
    }
    if (Array.isArray(entry.tool_calls)) {
      for (const tc of entry.tool_calls) {
        if (EDIT_TOOLS.has(tc.name)) {
          const path = tc.args?.Path || tc.args?.path;
          if (!path || IGNORED.some((dir) => isInside(dir, path))) continue;
          if (existsSync(dirname(path))) return path;
        }
      }
    }
  }
  return null;
}

export function resolveTargetDir() {
  const activePaneId = process.env.HERDR_ACTIVE_PANE_ID;
  const pane = activePaneId ? getPaneInfo(activePaneId) : null;

  // 1. Si el pane tiene un agente con sesión, verificar último archivo editado
  if (pane?.agent_session?.kind === 'id') {
    const { agent, value: sessionId } = pane.agent_session;
    let editedPath = null;
    if (agent === 'claude') {
      editedPath = claudeLastEditedPath(sessionId);
    } else if (agent === 'agy') {
      editedPath = agyLastEditedPath(sessionId);
    }
    if (editedPath) {
      return findProjectRoot(editedPath);
    }
  }

  // 2. Usar foreground_cwd del pane (directorio real del proceso en ejecución según el kernel/OS)
  if (pane?.foreground_cwd && existsSync(pane.foreground_cwd)) {
    return findProjectRoot(pane.foreground_cwd);
  }

  // 3. Usar cwd del pane registrado en herdr
  if (pane?.cwd && existsSync(pane.cwd)) {
    return findProjectRoot(pane.cwd);
  }

  // 4. Variable de entorno HERDR_ACTIVE_PANE_CWD inyectada por herdr
  if (process.env.HERDR_ACTIVE_PANE_CWD && existsSync(process.env.HERDR_ACTIVE_PANE_CWD)) {
    return findProjectRoot(process.env.HERDR_ACTIVE_PANE_CWD);
  }

  // 5. Fallback a process.cwd()
  return findProjectRoot(process.cwd()) || process.cwd();
}

if (import.meta.url === `file://${process.argv[1]}`) {
  console.log(resolveTargetDir());
}
