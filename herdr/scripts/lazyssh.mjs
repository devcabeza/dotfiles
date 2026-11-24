#!/usr/bin/env node

// Abre lazyssh (selector TUI de servidores SSH configurados en ~/.ssh/config).
//
// Para probar sin abrir lazyssh:
//   HERDR_LAZYSSH_DRYRUN=1 node ~/.config/herdr/scripts/lazyssh.mjs

import { spawnSync } from 'node:child_process';
import { resolveTargetDir } from './project-root.mjs';

const cwd = resolveTargetDir();

if (process.env.HERDR_LAZYSSH_DRYRUN) {
  console.log(cwd);
} else {
  const result = spawnSync('lazyssh', [], { cwd, stdio: 'inherit' });
  if (result.error) console.error(result.error.message);
  process.exitCode = result.status ?? 1;
}
