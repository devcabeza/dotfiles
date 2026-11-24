#!/usr/bin/env node

// Abre lazydocker en la raíz del proyecto activo (para detectar compose.yaml / docker-compose.yml).
//
// Para probar qué carpeta elige sin abrir lazydocker:
//   HERDR_LAZYDOCKER_DRYRUN=1 node ~/.config/herdr/scripts/lazydocker.mjs

import { spawnSync } from 'node:child_process';
import { resolveTargetDir } from './project-root.mjs';

const cwd = resolveTargetDir();

if (process.env.HERDR_LAZYDOCKER_DRYRUN) {
  console.log(cwd);
} else {
  const result = spawnSync('lazydocker', [], { cwd, stdio: 'inherit' });
  if (result.error) console.error(result.error.message);
  process.exitCode = result.status ?? 1;
}
