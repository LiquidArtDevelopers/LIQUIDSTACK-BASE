# Changelog

Todos los cambios relevantes de LiquidStack BASE se documentan en este
fichero. BASE tiene un ciclo SemVer independiente de CORE.

## [Unreleased]

## [1.4.0] - 2026-09-21

### Added

- El showroom incorpora una categoría Commerce con sus tres recursos y veinte
  prendas Matrix localizadas para probar catálogo, taxonomías, ficha y lista de
  interés sin crear registros en la DB ni contenido en WebAdmin.
- La mochila canónica de Commerce suma los hooks PHP, JavaScript y SCSS del
  showroom y pasa de 26 a 29 ficheros gestionados.

### Changed

- La navegación project-owned de BASE añade Tienda solo cuando la superficie
  pública de Commerce está habilitada y conserva el path exacto configurado por
  locale; los consumidores existentes deben adoptar esta composición de forma
  explícita para no sobrescribir sus menús personalizados.

## [1.3.0] - 2026-09-21

### Added

- Commerce queda seleccionado por defecto junto con WebAdmin y Blog, con sus
  26 ficheros canónicos, catálogo multidioma, consultas mediante lista de
  interés y entrega diferida de sus dos correos a través de outbox.
- BASE documenta y distribuye las tres migraciones iniciales de Commerce sin
  ejecutarlas automáticamente.

### Changed

- Los proyectos nuevos parten de CORE `^1.33`, la primera línea compatible con
  Commerce.
- La superficie pública de Commerce nace cerrada; cada proyecto debe preparar
  y validar su catálogo antes de activar `public.enabled` y, si lo desea, el
  contador público de consultas mediante `social_proof.enabled`.

## [1.2.1] - 2026-09-21

### Fixed

- El README separa inequívocamente las releases de BASE y CORE y reduce la
  publicación al bloque invariable `composer release`. El gate detecta la única
  versión pendiente del changelog, avisa si falta o es ambigua y pregunta la
  descripción del tag antes de validar y hacer el push atómico.

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
