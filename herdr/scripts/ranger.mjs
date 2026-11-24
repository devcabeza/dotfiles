#!/usr/bin/env node

// Abre ranger (administrador de archivos en terminal) en la raíz del proyecto activo.
//
// Para probar qué carpeta elige sin abrir ranger:
//   HERDR_RANGER_DRYRUN=1 node ~/.config/herdr/scripts/ranger.mjs

import { spawnSync } from 'node:child_process';
import { resolveTargetDir } from './project-root.mjs';

const cwd = resolveTargetDir();

if (process.env.HERDR_RANGER_DRYRUN) {
  console.log(cwd);
} else {
  const result = spawnSync('ranger', [cwd], { cwd, stdio: 'inherit' });
  if (result.error) console.error(result.error.message);
  process.exitCode = result.status ?? 1;
}
