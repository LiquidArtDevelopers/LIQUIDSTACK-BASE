# Changelog

Todos los cambios relevantes de LiquidStack BASE se documentan en este
fichero. BASE tiene un ciclo SemVer independiente de CORE.

## [Unreleased]

## [1.0.1] - 2026-09-10

### Fixed

- Los gates largos de release y `create-project` ya no quedan interrumpidos
  por el timeout de 300 segundos del proceso padre de Composer cuando GitHub
  necesita descargar el repositorio VCS con la caché fría.

## [1.0.0] - 2026-09-10

### Added

- Contrato reproducible para crear proyectos con `composer create-project`.
- Lockfiles de Composer y npm versionados como parte del starter.
- Plantilla `.npmrc.example` sin credenciales para la dependencia privada de
  GSAP.
- Pruebas estructurales y E2E del paquete distribuido.
- Modos E2E posteriores a la etiqueta contra GitHub VCS y Packagist.
- Documentación explícita de ownership, bootstrap manual y actualización.
- Gate `composer release` específico de BASE con validación integral y push
  atómico de `main` + etiqueta, sin mutaciones de DB o bootstrap. Composer y
  npm se validan en un archive temporal del commit para no tocar el `.env` ni
  los outputs del checkout.

### Changed

- Toolchain frontend actualizado dentro del contrato Node 20.19+ y lock npm
  saneado. La auditoría inicial detectaba ocho avisos (siete altos y uno
  crítico) en dependencias de desarrollo antiguas; el lock de esta release
  queda sin advisories conocidos.
- `public/.vite/manifest.json` deja de versionarse y de viajar en el starter;
  cada proyecto lo genera junto con sus bundles mediante `npm run build`.
- CORE queda bloqueado reproduciblemente en `v1.29.0`; `.env`, `.npmrc` y
  `auth.json` quedan fuera de cualquier distribución.

BASE se etiqueta para iniciar proyectos nuevos; un proyecto ya creado no
depende después de BASE ni recibe sus versiones. Las actualizaciones comunes
de esos proyectos llegan mediante `liquidstack/core` y su sincronizador
conservador.
