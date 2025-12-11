#!/usr/bin/env node
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const [, , rawProfile] = process.argv;

if (!rawProfile) {
  console.error('Uso: node scripts/swap-env.mjs <perfil>');
  process.exit(1);
}

const profile = rawProfile.toLowerCase();
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, '..');
const profilePath = path.join(repoRoot, `.env.${profile}`);
const envPath = path.join(repoRoot, '.env');
const examplePath = path.join(repoRoot, '.env.example');

if (!fs.existsSync(profilePath)) {
  console.error(`No se encontró el archivo ${path.basename(profilePath)}.`);
  process.exit(1);
}

if (!fs.existsSync(envPath)) {
  if (!fs.existsSync(examplePath)) {
    console.error('No existe .env ni .env.example para inicializar el entorno.');
    process.exit(1);
  }

  fs.copyFileSync(examplePath, envPath);
  console.log('Se creó .env a partir de .env.example para preservar el resto de variables.');
}

const profileOverrides = parseEnv(fs.readFileSync(profilePath, 'utf8'));
const baseEnvContent = fs.readFileSync(envPath, 'utf8');
const merged = applyOverrides(baseEnvContent, profileOverrides);

fs.writeFileSync(envPath, merged);

const appliedKeys = Object.keys(profileOverrides);
const summary = appliedKeys.length ? appliedKeys.join(', ') : 'sin claves nuevas';
console.log(`Perfil "${profile}" aplicado en .env (${summary}).`);

function parseEnv(content) {
  return content
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line && !line.startsWith('#'))
    .reduce((acc, line) => {
      const eqIndex = line.indexOf('=');
      if (eqIndex === -1) {
        return acc;
      }

      const key = line.slice(0, eqIndex).trim();
      const value = line.slice(eqIndex + 1).trim();

      if (key) {
        acc[key] = value;
      }

      return acc;
    }, {});
}

function applyOverrides(baseContent, overrides) {
  const newline = baseContent.includes('\r\n') ? '\r\n' : '\n';
  const lines = baseContent.split(/\r?\n/);

  for (const [key, value] of Object.entries(overrides)) {
    const pattern = new RegExp(`^${escapeRegExp(key)}\s*=`, 'i');
    let replaced = false;

    for (let i = 0; i < lines.length; i += 1) {
      if (pattern.test(lines[i])) {
        lines[i] = `${key}=${value}`;
        replaced = true;
        break;
      }
    }

    if (!replaced) {
      if (lines.length && lines[lines.length - 1].trim() !== '') {
        lines.push('');
      }
      lines.push(`${key}=${value}`);
    }
  }

  return lines.join(newline);
}

function escapeRegExp(value) {
  return value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
