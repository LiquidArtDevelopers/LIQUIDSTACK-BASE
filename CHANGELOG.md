# Changelog

Todos los cambios relevantes de LiquidStack BASE se documentan en este
fichero. BASE tiene un ciclo SemVer independiente de CORE.

## [Unreleased]

## [1.2.0] - 2026-09-21

### Changed

- El repositorio de BASE conserva un lock reproducible para su mantenimiento,
  pero lo excluye del paquete distribuido: cada `create-project` resuelve el
  CORE `^1.31` más reciente y genera el lock propio del nuevo consumidor.
- WebAdmin y Blog quedan seleccionados explícitamente mediante sus alias
  lógicos; ambos siguen viajando dentro del único paquete físico CORE.
- `create-project` desvincula automáticamente la identidad de BASE, sincroniza
  los nombres Composer/npm y retira las herramientas exclusivas de publicación
  sin crear `.env`, ejecutar npm ni acceder a la base de datos.
- WebAdmin y Blog usan en proyectos nuevos un único bloque
  `LIQUIDSTACK_DB_*`; los perfiles de entorno pueden cambiar su host o puerto
  sin duplicar nombre, usuario o contraseña.
- El README convierte la puesta en marcha en un recorrido verificable: preflight
  de runtimes, gate de migraciones, puerto LAD real para onboarding, cierre de
  Media, DB remota segura, primer Git y promoción coordinada de DB + storage.

### Fixed

- El contrato de entorno conserva una estructura canónica y explica cada
  variable mediante un comentario inmediato de función y ejemplo; correo,
  bootstrap, CookieLad y storage quedan claros, y `GSAP_TOKEN` permanece
  únicamente como secreto del proceso npm.
- La clave pública `EXAMPLE_ONLY...` queda documentada como sentinel de formato
  válido pero inseguro; todo proyecto debe reemplazarla por una clave aleatoria
  privada antes de cualquier uso real.
- `swap-env` reconoce correctamente espacios alrededor de las asignaciones y
  avisa cuando un perfil cambia el endpoint de la DB modular.

## [1.1.1] - 2026-09-18

### Changed

- Se añade en el env.example la clave para el token de GSAP

## [1.1.0] - 2026-09-18

### Changed

- Se ha realizado una actualización para que cuando se crea un nuevo proyecto usando base, se instalen las últimas y más recientes dependencias de core, webadmin y blog.

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
