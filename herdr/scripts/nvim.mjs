#!/usr/bin/env node

// Abre Neovim en la raíz del proyecto donde se está trabajando.
//
// Para probar qué carpeta elige sin abrir nvim:
//   HERDR_NVIM_DRYRUN=1 node ~/.config/herdr/scripts/nvim.mjs

import { spawnSync } from 'node:child_process';
import { resolveTargetDir } from './project-root.mjs';

const cwd = resolveTargetDir();

if (process.env.HERDR_NVIM_DRYRUN) {
  console.log(cwd);
} else {
  // Sin argumentos: "nvim ." abriría el explorador en vez de la pantalla de inicio.
  const result = spawnSync('nvim', [], { cwd, stdio: 'inherit' });
  if (result.error) console.error(result.error.message);
  process.exitCode = result.status ?? 1;
}
