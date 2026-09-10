# LiquidStack BASE

BASE es el starter neutro para crear proyectos LiquidStack. Contiene la
estructura que pertenece al proyecto consumidor y selecciona, por defecto, el
paquete físico `liquidstack/core` junto con Blog y WebAdmin.

CORE aporta y actualiza la parte común; BASE aporta una aplicación dummy lista
para personalizar. AIWA, ARRO y los proyectos futuros deben poder nacer de este
repositorio sin copiar código privado de otro cliente.

## Qué contiene BASE

- La aplicación PHP/Vite, rutas y vistas públicas iniciales.
- Los shells personalizables del índice y del artículo de Blog.
- La configuración no secreta de Blog y WebAdmin.
- Recursos, idiomas y showroom neutros para empezar un proyecto.
- `.env.example` con valores de desarrollo deliberadamente públicos.
- `example_liquidstack_dev.sql`, un snapshot demostrativo de la base modular.
- Pruebas de contrato propias del starter.

La base de datos, usuarios, correo, dominios, branding, navegación, copy y
credenciales reales siempre pertenecen al proyecto consumidor. CORE no los
inventa ni los toma de AIWA o ARRO.

## Requisitos

- PHP 8.1 o posterior.
- Composer 2.
- Node `^20.19.0` o `>=22.12.0`.
- MySQL/MariaDB para el snapshot de ejemplo y para los módulos en este starter.

### Preflight de PHP en Windows

XAMPP puede estar ejecutando MariaDB aunque Composer o `npm run lad` estén
resolviendo otro PHP desde `PATH`. Antes de instalar o diagnosticar, comprueba
el binario y su configuración efectivos:

```powershell
where.exe php
php --ini
php -r 'echo implode('','', PDO::getAvailableDrivers()), PHP_EOL;'
php -r 'var_export((bool) ini_get(''zend.exception_ignore_args'')); echo PHP_EOL;'
php -r 'var_export(defined(''PASSWORD_ARGON2ID'')); echo PHP_EOL;'
```

WebAdmin sobre MySQL/MariaDB necesita, como mínimo:

- `pdo_mysql`;
- soporte de Argon2id;
- `zend.exception_ignore_args=On`.

Los requisitos de Media son adicionales: `fileinfo`, Imagick con AVIF y límites
de subida adecuados. Que falte uno de ellos no significa que haya que ejecutar
migraciones. Si `php` no es el binario correcto, se puede indicar al supervisor
sin imponer una ruta universal:

```powershell
$env:LIQUIDSTACK_DEV_PHP_BINARY = 'C:\ruta\al\php.exe'
npm run lad
```

`C:\xampp\php\php.exe` es solo un ejemplo frecuente. Tras cambiar de binario o
`php.ini`, reinicia `npm run lad` y repite `composer liquidstack:doctor`.

## Crear un proyecto

1. Copia o clona BASE sin `vendor`, `node_modules`, `composer.lock`,
   `package-lock.json` ni assets compilados.
2. Crea el entorno privado:

   ```powershell
   Copy-Item -LiteralPath '.env.example' -Destination '.env'
   ```

3. Sustituye los valores demo descritos en la siguiente sección. Si vas a
   importar el snapshot, conserva sus dos emails bootstrap hasta reconciliar
   las cuentas por primera vez.
4. Instala las dependencias:

   ```powershell
   composer install
   npm install
   ```

5. Importa el snapshot de ejemplo o parte de una DB vacía.
6. Ejecuta `composer liquidstack:doctor` antes de levantar el panel.
7. Personaliza rutas, idiomas, tema, navegación, footer, identidad y copy.

BASE no versiona `composer.lock`: un proyecto nuevo resuelve así una versión
compatible y actual de CORE. El proyecto derivado sí puede decidir versionar su
propio lock.

## Valores demo: cambiar antes de desplegar

`.env.example` incluye estos defaults públicos para que BASE sea reproducible
en local:

| Variable | Valor demo |
| --- | --- |
| `BBDD_NAME` | `example_liquidstack_dev` |
| `BBDD_USER` | `example_user` |
| `BBDD_PASS` | `example_pass` |
| `LIQUIDSTACK_WEBADMIN_SECURITY_KEY` | clave pública marcada `EXAMPLE_ONLY...` |
| superadmin de sistema | `aranaz@webda.eus` |
| admin del sitio | `aranaz@gmail.com` |

La contraseña de DB y la clave WebAdmin no son secretos válidos de producción.
Cada proyecto debe rotarlas en su `.env`, que está ignorado por Git. Para crear
una clave base64url aleatoria de 43 caracteres con el PHP efectivo:

```powershell
php -r '$b=random_bytes(32); echo rtrim(strtr(base64_encode($b), ''+/'', ''-_''), ''=''), PHP_EOL;'
```

También deben cambiarse `RAIZ`, `DOMAIN`, `DOMAIN_URL`, todos los `MAIL_*`, los
datos legales `VITE_BUSINESS_*`, CookieLad y cualquier ruta privada antes de un
despliegue real. `https://example.com` es un origen reservado, no un dominio de
producción.

## Elegir módulos

CORE es el único paquete físico publicado. WebAdmin y Blog son selectores
lógicos de esa misma versión:

| Selección directa | Resultado |
| --- | --- |
| `liquidstack/core` | CORE sin módulos internos |
| `liquidstack/webadmin` | CORE + WebAdmin |
| `liquidstack/blog` | CORE + WebAdmin + Blog |

Comandos de selección:

```powershell
composer require liquidstack/core
composer require liquidstack/webadmin
composer require liquidstack/blog
```

El `composer.json` de BASE ya selecciona `liquidstack/blog`, por lo que una
instalación nueva dispone también de WebAdmin. Composer distribuye el código,
pero nunca aplica migraciones ni crea usuarios automáticamente.

## Conexión de base de datos

Blog y WebAdmin usan por defecto la conexión `shared` declarada en
`App/config/modules/blog.php` y `App/config/modules/webadmin.php`. Esa opción
lee:

```dotenv
BBDD_NAME=example_liquidstack_dev
BBDD_USER=example_user
BBDD_PASS=example_pass
BBDD_SERVER=127.0.0.1
```

Si un proyecto decide usar la conexión dedicada `liquidstack`, debe cambiar
ambos módulos a la vez y completar todo el bloque `LIQUIDSTACK_DB_*`. No mezcles
un módulo en `shared` y otro en `liquidstack`.

La creación de la DB y del usuario SQL se hace fuera del repositorio. BASE no
incluye `CREATE USER`, contraseñas del servidor ni `GRANT`.

## Opción A: importar el snapshot demo

El fichero raíz `example_liquidstack_dev.sql` contiene:

- el esquema resultante de las 30 migraciones canónicas actuales;
- roles, capacidades y semillas técnicas;
- las dos cuentas iniciales en estado de invitación, sin contraseña;
- categorías, etiquetas y artículos neutros de ejemplo en español y euskera.

No contiene **datos** de sesiones, tokens de invitación, outbox, rate limits,
analítica, auditoría o credenciales; tampoco contiene hashes de contraseña,
usuarios SQL ni permisos del servidor. Sus tablas vacías sí forman parte del
esquema. El SQL es una fotografía reproducible para BASE; las migraciones de
CORE siguen siendo la fuente canónica. Impórtalo únicamente en una DB de
desarrollo vacía: el dump reconstruye sus tablas y no debe ejecutarse sobre
datos que se quieran conservar.

Ejemplo de importación desde PowerShell, suponiendo que `mysql.exe` está en
`PATH`:

```powershell
$env:MYSQL_PWD = 'example_pass'
mysql.exe --host=127.0.0.1 --user=example_user `
    --database=example_liquidstack_dev `
    --execute='SOURCE example_liquidstack_dev.sql'
Remove-Item Env:MYSQL_PWD
```

Si se usa XAMPP, `C:\xampp\mysql\bin\mysql.exe` puede ser la ruta local, pero
no es un requisito universal.

Después de importar, valida primero que el snapshot coincide con el catálogo
instalado e inicializa el storage privado de Media, que no se versiona:

```powershell
composer liquidstack:migrate --dry-run --format=json
composer liquidstack:media:init --yes --format=json
```

El dry-run debe indicar cero migraciones pendientes mientras el snapshot y la
versión instalada de CORE coincidan. Si CORE es posterior, revisa el plan, crea
un backup y aplica únicamente las migraciones nuevas.

Las cuentas del snapshot no tienen acceso utilizable y el bootstrap permanece
deliberadamente en estado `pending`. Reconcílialas para crear las filas
técnicas e invitaciones nuevas con la clave privada del proyecto. Durante esta
primera reconciliación, las variables bootstrap deben conservar exactamente
`aranaz@webda.eus` y `aranaz@gmail.com`; después las identidades se administran
desde WebAdmin y no cambiando el snapshot. Tras configurar un transporte de
correo local o real, entrega la cola de forma explícita:

```powershell
composer liquidstack:webadmin:bootstrap --yes --format=json
composer liquidstack:doctor --format=json
composer liquidstack:webadmin:mail:dispatch --limit=20
```

`liquidstack:webadmin:onboard --yes` puede componer bootstrap y entrega en un
solo paso cuando el correo ya está preparado; puede enviar mensajes reales a
las dos direcciones configuradas.

## Opción B: comenzar con una DB vacía

Con una DB vacía y el `.env` ya configurado, usa este orden:

```powershell
composer liquidstack:doctor --format=json
composer liquidstack:migrate --plan --format=json
composer liquidstack:migrate --dry-run --format=json
```

Después de revisar el plan y crear un backup verificable de la DB:

```powershell
composer liquidstack:migrate --apply --allow-destructive `
    --backup-confirmed --yes --format=json
composer liquidstack:media:init --yes --format=json
composer liquidstack:webadmin:onboard --yes --format=json
composer liquidstack:doctor --format=json
```

`migrate --apply`, `media:init`, bootstrap y onboarding son mutaciones y exigen
autorización consciente. La ausencia de un driver PHP o de una directiva de
runtime no se corrige migrando. En diagnóstico no se modifican automáticamente
`php.ini`, `.env`, `PATH` ni la DB.

Las 30 migraciones crean esquema e infraestructura, no artículos de ejemplo.
Esos datos solo proceden del snapshot demo o de entradas creadas desde
WebAdmin.

## Desarrollo local

```powershell
npm run lad
```

El supervisor busca el primer puerto PHP libre desde `1309` y el primer puerto
Vite libre desde `5173`. Si otro stack ocupa esos puertos, avanza a `1310`,
`5174`, etc. No persiste el número elegido y separa las cookies privadas por una
identidad opaca del proyecto; varios stacks pueden permanecer autenticados a la
vez aunque los puertos cambien.

Overrides opcionales:

- `LIQUIDSTACK_DEV_APP_PORT`: fuerza un puerto PHP exacto y falla si está
  ocupado.
- `LIQUIDSTACK_DEV_VITE_PORT`: fuerza un puerto Vite exacto y falla si está
  ocupado.
- `LIQUIDSTACK_DEV_PHP_BINARY`: elige el PHP del supervisor.

En producción la separación se deriva del dominio/proyecto, no de un puerto.

Los perfiles `.env.development` y `.env.production` solo deben incluir claves
que cambian entre entornos. `scripts/swap-env.mjs` fusiona esas claves en
`.env`; no debe borrar las credenciales privadas que ya existen.

## Blog público y WebAdmin

BASE deja preparados:

- `/admin` para WebAdmin;
- `/es/blog` y `/eu/blog` para el índice público;
- `App/views/blog.php` como shell project-owned del índice;
- `App/views/blog-article.php` como shell project-owned de cada artículo;
- `App/config/modules/blog.php` para paths, paginación, sitemap y vista pública;
- `src/scss/blog.scss` y `src/js/blog.js` para la presentación del proyecto.

Las rutas privadas de los módulos pertenecen a los providers de CORE y no se
duplican en `App/config/routes/get.php`. Las rutas privadas propias del proyecto
deben declarar `'sitemap' => false`.

CookieLad permanece desactivado mientras `COOKIE_LAD_KEY` esté vacío. El shell
de artículo usa los includes globales del proyecto, de modo que navegación,
footer y consentimiento pueden mantenerse coherentes con el resto de la web.

## Qué personalizar en cada proyecto

Como mínimo:

- `.env`, perfiles y dominios;
- idiomas y slugs públicos;
- `App/config/routes/get.php`, `post.php` y `rutas.js`;
- `App/config/modules/blog.php` y `webadmin.php`;
- navegación, footer, logos, favicon y datos legales;
- copy y metadatos de cada idioma;
- `src/scss/_config.scss`, `_global.scss` y estilos de página;
- correo, CookieLad, usuarios, medios y contenido;
- estrategia de backup, cron/dispatcher y despliegue.

`src/scss/_config.scss` conserva el contrato completo de colores. Los recursos
estándar de CORE usan `color00` a `color03`; `color04` y posteriores quedan
disponibles para el tema del consumidor.

## Actualizar CORE en un consumidor

Para actualizar todo el código físico LiquidStack ya seleccionado:

```powershell
composer update liquidstack/core
```

No hace falta actualizar Blog o WebAdmin por separado: comparten la versión de
CORE. `composer update` sin paquete también puede actualizar PHPMailer,
Dotenv, PHPUnit y cualquier otra dependencia; úsalo solo cuando quieras revisar
todo el lock.

La sincronización de CORE es aditiva y se apoya en
`.liquidstack/core/managed-files.json`:

- añade ficheros nuevos;
- actualiza copias canónicas reconocidas;
- conserva personalizaciones locales desconocidas;
- no elimina de forma global ficheros del consumidor;
- fusiona catálogos de idioma sin sustituir valores locales existentes.

El manifiesto gestionado debe versionarse en cada consumidor. Tras actualizar:

```powershell
npm install
composer liquidstack:doctor
composer liquidstack:migrate --plan
composer liquidstack:migrate --dry-run
composer test
npm run build
git diff --check
git status --short
```

Revisa siempre el diff sincronizado antes de aplicar migraciones o publicar.

## Build y comprobación final

Antes del primer build sustituye el dominio reservado de `.env.production`.
Después:

```powershell
npm run build
composer test
```

El build genera el sitemap multilingüe y los assets en `public/assets`; no crea
una carpeta `dist` adicional.

El cierre funcional de un proyecto con Blog/WebAdmin debe comprobar como
usuario real, al menos:

- home, navegación, footer, cookies y cambio de idioma;
- login, logout y concurrencia con otros stacks;
- listado, creación, edición, publicación y previsualización de posts;
- categorías, etiquetas, SEO, index/follow y acciones del listado;
- biblioteca de medios y límites del servidor;
- índice y artículo públicos, metadatos, sitemap y 404;
- responsive y consola/red del navegador sin errores inesperados.

## Fuente de verdad operativa

Las instrucciones especializadas se distribuyen en `.codex/skills`. Para
desarrollo, módulos y promociones hacia CORE deben usarse las skills
`dev-stack`, `liquidstack-module-operations` y
`liquidstack-resource-migration`; este README explica el arranque del starter y
no sustituye sus contratos de trabajo.
