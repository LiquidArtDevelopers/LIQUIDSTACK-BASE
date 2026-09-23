# LiquidStack BASE

BASE es el starter neutro para crear proyectos LiquidStack. Contiene la
estructura que pertenece al proyecto consumidor y selecciona, por defecto, el
paquete físico `liquidstack/core` junto con WebAdmin, Blog y Commerce.

CORE aporta y actualiza la parte común; BASE aporta una aplicación dummy lista
para personalizar. AIWA, ARRO y los proyectos futuros deben poder nacer de este
repositorio sin copiar código privado de otro cliente.

## Qué contiene BASE

- La aplicación PHP/Vite, rutas y vistas públicas iniciales.
- Los shells personalizables del índice y del artículo de Blog.
- Los shells públicos de Commerce y sus recursos visuales gestionados.
- La configuración no secreta de WebAdmin, Blog y Commerce.
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

Los requisitos se separan por superficie:

- el runtime base debe satisfacer `composer check-platform-reqs --no-dev`;
- BASE exige `ext-dom` porque activa Blog y `ext-pdo_mysql` porque configura
  WebAdmin/Blog/Commerce sobre MySQL/MariaDB; Composer los comprueba al instalar;
- WebAdmin necesita además el preflight PHP descrito abajo;
- Media añade sus propios codecs, `fileinfo`, Imagick/AVIF y límites de subida;
- las pruebas de desarrollo requieren las extensiones de PHPUnit indicadas por
  `composer check-platform-reqs`, entre ellas DOM, JSON, libxml, tokenizer y
  XMLWriter;
- `composer test:create-project` y el gate de release necesitan `ext-zip` para
  inspeccionar el paquete real. Estos requisitos de tooling no deben
  confundirse con los del panel base en producción.

### Preflight de PHP en Windows

XAMPP puede estar ejecutando MariaDB aunque Composer o `npm run lad` estén
resolviendo otro PHP desde `PATH`. Antes de instalar o diagnosticar, comprueba
el binario y su configuración efectivos:

```powershell
where.exe php
where.exe composer
php --ini
php -r 'echo PHP_BINARY, PHP_EOL;'
php -r 'echo implode('','', PDO::getAvailableDrivers()), PHP_EOL;'
php -r 'echo ini_get(''zend.exception_ignore_args'') ? ''On'' : ''Off'', PHP_EOL;'
php -r 'echo in_array(''argon2id'', password_algos(), true) ? ''Argon2id disponible'' : ''Argon2id ausente'', PHP_EOL;'
composer --version
node --version
npm --version
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

La vía estable, con una etiqueta publicada y el paquete disponible en
Packagist, es:

```powershell
composer create-project liquidstack/base mi-proyecto --prefer-dist --remove-vcs
```

Si Packagist no está disponible o se necesita validar una etiqueta directamente
desde GitHub, se puede declarar el repositorio VCS de forma explícita sin
añadirlo al proyecto resultante:

```powershell
composer create-project liquidstack/base mi-proyecto `
    --repository='{"type":"vcs","url":"https://github.com/LiquidArtDevelopers/LIQUIDSTACK-BASE.git"}' `
    --prefer-dist --remove-vcs
```

Al no indicar una versión, ambas órdenes eligen la etiqueta estable más
reciente. No añadas `^1.0` al comando en Windows: al atravesar `composer.bat`
puede llegar como `1.0` y fijar por error la release antigua `v1.0.0`.
`dev-main` queda reservado para probar cambios de BASE antes de una release y
no es una versión estable para proyectos de cliente.

El paquete distribuido no incluye el `composer.lock` interno de BASE.
`create-project` resuelve la versión más reciente de CORE compatible con la
restricción declarada, activa los selectores lógicos de WebAdmin, Blog y Commerce y genera
un `composer.lock` propio para el nuevo proyecto. El inicializador de BASE
desvincula además la identidad de la plantilla a partir del nombre de la carpeta.
No crea `.env`, no instala paquetes npm, no conecta con la DB, no migra, no crea
cuentas y no ejecuta onboarding. Después sigue este orden:

1. Entra en el directorio y revisa la identidad generada en `composer.json` y
   `package.json`. Inicializa el Git del cliente, añade su remoto y completa
   dominio, `homepage` y `support` cuando existan; el inicializador no los
   inventa.
2. Conserva versionados el `composer.lock` recién generado y
   `package-lock.json`; forman parte del punto de partida reproducible. Antes
   de configurar servicios, valida la instalación con
   `composer validate --strict --no-check-publish --no-check-all` y
   `composer check-platform-reqs --no-dev`.
3. Crea el entorno privado de forma explícita:

   ```powershell
   Copy-Item -LiteralPath '.env.example' -Destination '.env'
   ```

4. Sustituye todos los valores demo, incluida la clave de seguridad. Elige una
   única conexión `LIQUIDSTACK_DB_*` para WebAdmin/Blog/Commerce y configura
   SMTP antes del onboarding. Si vas a importar el snapshot, conserva sus dos emails
   bootstrap hasta reconciliar las cuentas por primera vez.
5. Configura el acceso privado a GSAP sin versionar el token. Una opción local
   en PowerShell es:

   ```powershell
   $env:GSAP_TOKEN = '<token-privado>'
   Copy-Item -LiteralPath '.npmrc.example' -Destination '.npmrc'
   npm ci
   ```

   `.npmrc` permanece ignorado y `.npmrc.example` solo referencia
   `${GSAP_TOKEN}`. También se puede configurar el registro en el perfil de npm
   del operador, sin escribir credenciales en el proyecto. La dependencia
   actual `npm:@gsap/shockingly` necesita acceso válido al registro privado.
   `auth.json` también está ignorado y excluido del paquete: si Composer exige
   autenticación, usa `COMPOSER_AUTH` o el almacén global del operador. Nunca
   copies `.npmrc` o `auth.json` al repositorio ni al archive del cliente.
   `GSAP_TOKEN` es una variable del proceso npm: escribirla en el `.env` PHP no
   autentica el registro privado.
6. Decide el destino antes de operar: DB local o remota segura, y snapshot de
   demo o DB vacía. Sigue exactamente una de las dos rutas documentadas abajo.
7. Ejecuta en orden `doctor`, plan y dry-run. Si hay migraciones pendientes,
   detente, crea un backup y aplica solo el plan revisado; repite el dry-run
   hasta obtener cero pendientes.
8. Sigue el cierre común documentado abajo: inicializa Media, arranca
   `npm run lad`, usa el origen real que anuncie LAD para el onboarding, abre
   las dos invitaciones y realiza el smoke de `/admin`, Blog, Commerce y web
   pública.
9. Ejecuta `composer test`, `npm run build`, revisa `git status`/`git diff` y
   solo entonces crea el primer commit del proyecto personalizado.

El primer repositorio del cliente se prepara, sustituyendo la URL de ejemplo,
con:

```powershell
git init
git branch -M main
git remote add origin https://github.com/organizacion/mi-proyecto.git
```

Antes del primer `git add`, confirma que los secretos y outputs siguen
ignorados. `git check-ignore` debe devolver las tres rutas:

```powershell
git check-ignore .env .npmrc public/.vite/manifest.json
git status --short --ignored
```

Tras completar el smoke y revisar el lote:

```powershell
git add -A
git diff --cached --check
git status --short
git commit -m "chore: initialize client project"
git push -u origin main
```

### Desvincular la identidad de la plantilla

El hook one-shot de `create-project` usa el nombre de la carpeta para:

- sustituir `liquidstack/base` por
  `liquid-art-developers/<slug-del-proyecto>`;
- crear una descripción neutra de proyecto de cliente y conservar la licencia
  `proprietary`;
- retirar `homepage` y `support` de BASE, porque todavía no conoce el dominio ni
  el repositorio del cliente;
- cambiar `name` en `package.json` y en las dos entradas raíz de
  `package-lock.json`, sin volver a resolver dependencias;
- retirar los scripts, herramientas y pruebas que sirven exclusivamente para
  publicar nuevas releases de BASE.

El inicializador falla cerrado si el directorio no produce un slug de paquete
válido y nunca crea `.env`, remoto Git, dominio, DB ni cuentas. Revisa después
el nombre humano y la descripción, añade `homepage` y `support` cuando conozcas
las URLs reales y configura el nuevo remoto Git. Después del primer smoke,
adapta README/CHANGELOG a la documentación del cliente, conservando en ella el
runbook operativo que siga necesitando el proyecto. No dejes enlaces de soporte
hacia BASE.

El nombre `liquidstack/base` identifica únicamente el artefacto de origen; no
es una dependencia de runtime ni debe conservarse como identidad del proyecto.

La vía normal no necesita flags adicionales. Si una creación excepcional se
hizo con `--no-install --no-scripts`, la identidad sigue siendo la de BASE
porque el hook no pudo ejecutarse. La recuperación segura y explícita es:

```powershell
composer install --no-scripts
composer project:init
composer validate --strict --no-check-publish --no-check-all
```

`project:init` se elimina a sí mismo al terminar. No ejecutes `create-project`
solo con `--no-install`: el callback PHP necesita primero el autoload generado
por Composer.

Si se obtiene BASE mediante un clon manual para mantener la propia plantilla,
se usa `composer install` con su lock versionado. Para iniciar un cliente con
las versiones más recientes debe usarse `create-project`; así el lock interno
de BASE no se hereda accidentalmente.

## Ownership y ciclo de vida

BASE es una plantilla de nacimiento, no una dependencia de ejecución. Tras
crear el proyecto:

- el nuevo repositorio no depende de BASE ni recibe posteriores etiquetas de
  BASE;
- vistas, rutas, `.env`, configuración de módulos, identidad, navegación,
  footer, copy, idiomas, datos y branding pasan a ser propiedad del proyecto;
- CORE sigue siendo la dependencia actualizable y distribuye únicamente su
  contrato gestionado mediante `composer update liquidstack/core`;
- los lockfiles se actualizan conscientemente en el proyecto consumidor y se
  revisan como cualquier otro cambio versionado;
- no se debe mezclar, copiar o fusionar una BASE nueva sobre un proyecto ya
  personalizado para intentar actualizarlo.

Así, una nueva etiqueta de BASE mejora los proyectos que nazcan después, pero
no sustituye archivos project-owned de AIWA, ARRO ni de otros consumidores.

## Valores demo: cambiar antes de desplegar

`.env.example` incluye estos defaults públicos para que BASE sea reproducible
en local:

El orden de sus grupos y el comentario breve `Función` + `Ejemplo` situado
justo encima de cada variable forman la plantilla canónica. `create-project`
los entrega sin pasos adicionales a todo proyecto nuevo. Un consumidor antiguo
puede conservar al final bloques project-owned o legacy, pero no debe alterar
el orden ni la explicación de las variables comunes.

| Variable | Valor demo |
| --- | --- |
| `LIQUIDSTACK_DB_NAME` | `example_liquidstack_dev` |
| `LIQUIDSTACK_DB_USER` | `example_user` |
| `LIQUIDSTACK_DB_PASSWORD` | `example_pass` |
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

### Referencia rápida del entorno

El bloque SMTP canónico lo comparten los formularios y WebAdmin:

| Variable | Función | ¿Puede quedar vacía? |
| --- | --- | --- |
| `MAIL_HOST` | Servidor SMTP | No, si se enviará correo |
| `MAIL_PORT` | Puerto SMTP, normalmente 465 o 587 | No |
| `MAIL_ENCRYPTION` | `smtps` o `starttls` | No |
| `MAIL_USERNAME` | Cuenta autenticada y dirección From | No |
| `MAIL_PASSWORD` | Credencial SMTP | No |
| `MAIL_FROM_NAME` | Nombre visible del remitente | No |
| `MAIL_ADMIN` | Destinatario principal de formularios públicos | No, si hay formularios |
| `MAIL_LAD` | Copia oculta técnica opcional de formularios | Sí |
| `MAIL_LAD_BIS` | Segunda copia oculta técnica opcional | Sí |
| `MAIL_WEB` | Compatibilidad con código project-owned antiguo | Sí; BASE no la usa |

WebAdmin nunca usa `MAIL_ADMIN`, `MAIL_LAD`, `MAIL_LAD_BIS` o `MAIL_WEB` como
destinatarios de invitaciones o recuperaciones. Envía únicamente a la identidad
validada por cada flujo. BASE declara
`LIQUIDSTACK_WEBADMIN_MAIL_TRANSPORT=smtp`; el runtime mantiene el valor vacío
como compatibilidad y ambos usan el bloque anterior. `local_capture_smtp` se reserva a un
capturador loopback de desarrollo; solo en ese modo se completan
`LIQUIDSTACK_WEBADMIN_SMTP_HOST`, `..._PORT` y los dos `..._MAIL_FROM_*`.

Ejemplo local, suponiendo que ya existe un capturador externo escuchando solo
en loopback y sin relay:

```dotenv
DEV_MODE=1
RAIZ=http://localhost:1309
LIQUIDSTACK_WEBADMIN_MAIL_TRANSPORT=local_capture_smtp
LIQUIDSTACK_WEBADMIN_SMTP_HOST=127.0.0.1
LIQUIDSTACK_WEBADMIN_SMTP_PORT=1025
LIQUIDSTACK_WEBADMIN_MAIL_FROM_ADDRESS=no-reply@localhost.test
LIQUIDSTACK_WEBADMIN_MAIL_FROM_NAME="WebAdmin local"
```

CORE no instala ni arranca ese capturador. Si no hay un proceso escuchando en
el puerto indicado, las invitaciones y recuperaciones no se entregarán.

`LIQUIDSTACK_WEBADMIN_SECURITY_KEY` es un secreto permanente del proyecto, no
una contraseña de usuario. Debe ser única, aleatoria y estable. El sentinel
`EXAMPLE_ONLY...` tiene un formato aceptable, pero es deliberadamente público e
inseguro; hay que sustituirlo antes de cualquier uso real. Las
variables `LIQUIDSTACK_WEBADMIN_SYSTEM_SUPERADMIN_EMAIL` y
`LIQUIDSTACK_WEBADMIN_SITE_ADMIN_EMAIL` son dos identidades distintas usadas
una sola vez por el onboarding inicial. Reciben invitaciones para crear sus
contraseñas; escribirlas en `.env` no activa las cuentas ni convierte esos
correos en destinatarios automáticos de recuperación.

`COOKIE_LAD_KEY` identifica la configuración remota de consentimiento del
proyecto; si está vacía, el loader no se monta. `COOKIE_LAD_COLOR` personaliza
su color hexadecimal. El widget sigue siendo la fuente de verdad de las
preferencias y el proyecto no debe cargar analítica, marketing o embeds antes
del consentimiento correspondiente.

`LIQUIDSTACK_WEBADMIN_MEDIA_STORAGE_ROOT` puede quedar vacía en loopback, pero
si se usa Media en producción debe señalar un directorio absoluto, privado y
persistente fuera del release. `LIQUIDSTACK_BLOG_SITEMAP_CACHE_ROOT` solo es
obligatoria si se activa expresamente `sitemap_cache.enabled=true`; con la
caché desactivada puede quedar vacía. Git ignore evita versionar esos datos,
pero no impide que un despliegue borre una ruta mal situada: DB y storage deben
respaldarse, trasladarse y restaurarse como una unidad.

Commerce reutiliza esa misma biblioteca Media. No tiene un segundo storage.
`LIQUIDSTACK_COMMERCE_INQUIRY_RECIPIENT` es el buzón que recibe cada solicitud
de información; debe configurarse antes de activar la superficie pública.
`LIQUIDSTACK_COMMERCE_PRIVACY_VERSION` identifica el texto legal aceptado y se
guarda junto a la solicitud. Cambiar el aviso legal exige avanzar ese valor.
`LIQUIDSTACK_COMMERCE_DEVELOPMENT_FIXTURES=1` habilita datos ficticios solo con
`DEV_MODE=1`; debe permanecer en `0` para cualquier uso real.

## Elegir módulos

CORE es el único paquete físico publicado. WebAdmin, Blog y Commerce son
selectores lógicos de esa misma versión:

| Selección directa | Resultado |
| --- | --- |
| `liquidstack/core` | CORE sin módulos internos |
| `liquidstack/webadmin` | CORE + WebAdmin |
| `liquidstack/blog` | CORE + WebAdmin + Blog |
| `liquidstack/commerce` | CORE + WebAdmin + Commerce |

Comandos de selección:

```powershell
composer require liquidstack/core
composer require liquidstack/webadmin
composer require liquidstack/blog
composer require liquidstack/commerce
```

El `composer.json` de BASE ya selecciona Blog y Commerce; ambos reutilizan el
mismo WebAdmin. Composer distribuye código, configuración inicial y recursos,
pero nunca aplica migraciones, inicializa Media, crea usuarios ni habilita la
tienda pública automáticamente.

## Conexión de base de datos

BASE configura WebAdmin, Blog y Commerce con el perfil `liquidstack` en sus
ficheros `App/config/modules/*.php`. Los tres módulos comparten una sola
conexión y leen exclusivamente:

```dotenv
LIQUIDSTACK_DB_HOST=127.0.0.1
LIQUIDSTACK_DB_PORT=3306
LIQUIDSTACK_DB_NAME=example_liquidstack_dev
LIQUIDSTACK_DB_USER=example_user
LIQUIDSTACK_DB_PASSWORD=example_pass
LIQUIDSTACK_DB_CHARSET=utf8mb4
```

`liquidstack` significa «DB de los módulos», no «DB de producción». El valor de
`LIQUIDSTACK_DB_HOST` determina el destino visible desde el proceso actual:

- `127.0.0.1` o `localhost` cuando la DB está en la misma máquina;
- el extremo local de un túnel SSH/VPN cuando la DB está en otra red;
- un hostname interno del proveedor cuando el stack ya se ejecuta en
  producción.

Nombre, usuario, contraseña y charset se escriben una sola vez en el `.env`
privado. Los perfiles `.env.development` y `.env.production` pueden sustituir
el host y, si el endpoint lo exige, el puerto al ejecutar `npm run lad` o
`npm run build`; así no se duplican las credenciales. Revisa siempre el mensaje
de `swap-env` antes de ejecutar un comando que pueda escribir en DB.

Por ejemplo, si el desarrollo accede mediante una red privada y el hosting ve
su propia DB en loopback, solo cambia esta clave entre perfiles:

```dotenv
# .env.development: endpoint accesible por VPN o red privada desde el equipo.
LIQUIDSTACK_DB_HOST=db-proyecto.red-privada.test
LIQUIDSTACK_DB_PORT=3307

# .env.production: PHP y MariaDB viven en el mismo hosting.
LIQUIDSTACK_DB_HOST=127.0.0.1
LIQUIDSTACK_DB_PORT=3306
```

Una DB de producción vacía sigue la opción B. Si ya contiene el esquema y los
datos promovidos desde local, no se importa el snapshot ni se adopta por
intuición: se valida con `doctor` y `migrate --dry-run` antes de escribir.

CORE no configura todavía opciones PDO de TLS/CA. No conectes el portátil
directamente a un MySQL/MariaDB público sin una red confiable y cifrada. Para
trabajar contra producción desde local usa preferentemente VPN o túnel SSH y
limita el usuario SQL; rota cualquier credencial temporal después del corte.

El perfil alternativo `shared` y las variables `BBDD_*` existen solo por
compatibilidad con aplicaciones antiguas que tienen una zona privada de negocio
propia. No representan desarrollo/producción. Un proyecto que conserve esa zona
puede tener ambos bloques porque son dos dominios de datos distintos; BASE no
incluye esa aplicación legacy. Nunca pongas la misma DB modular en ambos
namespaces.

La creación de la DB y del usuario SQL se hace fuera del repositorio. BASE no
incluye `CREATE USER`, contraseñas del servidor ni `GRANT`. Al crear una DB que
recibirá el snapshot, usa `utf8mb4` con cotejamiento
`utf8mb4_unicode_ci`; el propio SQL declara ese contrato en sus tablas.

## Opción A: importar el snapshot demo

El fichero raíz `example_liquidstack_dev.sql` contiene:

- el esquema resultante del catálogo incluido en esta release de BASE;
- roles, capacidades y semillas técnicas;
- las dos cuentas iniciales en estado de invitación, sin contraseña;
- categorías, etiquetas y artículos neutros de ejemplo en español y euskera.

No contiene **datos** de sesiones, tokens de invitación, outbox, rate limits,
analítica, auditoría o credenciales. También excluye cestas, solicitudes,
contactos y agregados sociales de Commerce. Tampoco contiene hashes de
contraseña, usuarios SQL ni permisos del servidor. Sus tablas vacías sí
forman parte del esquema. El SQL es una fotografía reproducible para BASE; las
migraciones de CORE siguen siendo la fuente canónica. Impórtalo únicamente en
una DB de desarrollo vacía: el dump reconstruye sus tablas y no debe
ejecutarse sobre datos que se quieran conservar.

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
instalado:

```powershell
composer liquidstack:doctor --format=json
composer liquidstack:migrate --plan --format=json
composer liquidstack:migrate --dry-run --format=json
```

No continúes con Media ni onboarding mientras el dry-run muestre pendientes o
bloqueadores. Si CORE es posterior al snapshot, revisa el plan, crea un backup,
aplica únicamente las migraciones nuevas con el comando confirmado de la
opción B y repite el dry-run hasta obtener cero pendientes. Entonces sigue el
cierre común.

Las cuentas del snapshot no tienen acceso utilizable y el bootstrap permanece
deliberadamente en estado `pending`. Durante esta primera reconciliación, las
variables bootstrap deben conservar exactamente `aranaz@webda.eus` y
`aranaz@gmail.com`. `onboard` completa las filas técnicas, genera las
invitaciones y contacta el SMTP: puede enviar mensajes reales. Abre ambos
enlaces y establece las contraseñas. Hasta entonces «He olvidado mi contraseña»
no envía correo porque una identidad `invited` todavía no tiene credencial que
recuperar.

No sustituyas este paso por `bootstrap` + dispatcher salvo en una recuperación
operativa deliberada. Después de activar las dos cuentas, la DB es la fuente de
verdad y las identidades se administran desde WebAdmin, no editando el snapshot
ni cambiando las variables bootstrap.

## Opción B: comenzar con una DB vacía local o de producción

Con una DB vacía y el `.env` ya configurado, usa este orden:

```powershell
composer liquidstack:doctor --format=json
composer liquidstack:migrate --plan --format=json
composer liquidstack:migrate --dry-run --format=json
```

Después de revisar el plan y crear un backup verificable de la DB, aplica las
migraciones seguras:

```powershell
composer liquidstack:migrate --apply --yes --format=json
composer liquidstack:migrate --dry-run --format=json
```

Solo si el plan identifica realmente migraciones destructivas, repite el
`--apply` autorizado añadiendo `--allow-destructive --backup-confirmed`. No
uses esos flags de forma preventiva.

No continúes hasta que el segundo dry-run confirme cero pendientes y ningún
bloqueador. `migrate --apply` es una mutación y exige autorización consciente;
Cuando sea necesario, `--backup-confirmed` declara que el backup ya existe, no
lo crea. La ausencia
de un driver PHP o de una directiva de runtime no se corrige migrando. En
diagnóstico no se modifican automáticamente `php.ini`, `.env`, `PATH` ni la DB.

Las migraciones crean esquema e infraestructura, no artículos de ejemplo. Esos
datos solo proceden del snapshot demo o de entradas creadas desde WebAdmin.
Cuando el esquema esté al día, sigue el cierre común.

## Cierre común: Media, onboarding y smoke

Con el dry-run a cero, inicializa el storage privado de Media:

```powershell
composer liquidstack:media:init --yes --format=json
```

Arranca el proyecto en una primera consola y conserva el proceso abierto:

```powershell
npm run lad
```

LAD busca puertos libres; por eso no hay que asumir `1309`. Copia el origen PHP
exacto que anuncie, abre una segunda consola y úsalo temporalmente al crear los
enlaces de activación. Sustituye `1310` por el puerto real:

```powershell
$env:RAIZ = 'http://localhost:1310'
composer liquidstack:webadmin:onboard --yes --format=json
composer liquidstack:doctor --format=json
```

Mantén esa segunda consola abierta. El override solo la afecta a ella y evita
generar invitaciones hacia un puerto distinto. Los enlaces `localhost` solo se
abren en esa misma máquina.
En una instalación ya desplegada, el onboarding debe usar el origen HTTPS real
y accesible del proyecto, no un puerto local ni el valor `example.com`.

Abre las dos invitaciones, define las contraseñas y comprueba `/admin`, Blog y
la web pública. En la segunda consola, repite `onboard`; al verificar el par
2/2 no debe duplicar usuarios ni invitaciones. Deja entonces vacías las dos
variables bootstrap en el `.env` privado, ejecuta el `doctor` final y retira el
override:

```powershell
composer liquidstack:webadmin:onboard --yes --format=json
composer liquidstack:doctor --format=json
Remove-Item Env:RAIZ
```

La DB pasa a ser la fuente de verdad. Un `bootstrap_ready=false` posterior
puede ser una advertencia no bloqueante sobre la capacidad de iniciar otra DB;
no invalida el 2/2 ya verificado.

`media:init` y onboarding son mutaciones deliberadas. No se ejecutan desde
`composer install`, `composer update` ni desde una tarea de diagnóstico.

## Producción: DB vacía o promoción con datos

- Para una DB productiva nueva y vacía, configura el perfil de producción y
  sigue la opción B en el entorno que realmente vaya a servir la aplicación.
- Para trasladar contenido existente, respalda y restaura conjuntamente la DB
  completa —incluida `ls_module_migrations`— y el storage Media. Cambiar
  `LIQUIDSTACK_DB_*` o la ruta de storage no mueve ni adopta datos.
- Antes de escribir en el destino, verifica credenciales, origen HTTPS,
  storage persistente, `doctor`, plan y dry-run. Conserva una copia recuperable
  hasta terminar el smoke.
- El despliegue debe preservar el storage fuera del release; `.gitignore` no
  protege frente a limpiezas, extracciones o sincronizaciones con borrado.

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
`.env`; no borra las credenciales privadas que ya existen. BASE incluye
`LIQUIDSTACK_DB_HOST=127.0.0.1` en ambos como default seguro. Si desarrollo debe
usar una DB remota mediante túnel/VPN, cambia únicamente el host del perfil de
desarrollo; conserva el endpoint visto desde el hosting en producción. El
script informa de las claves aplicadas y no selecciona una DB por `DEV_MODE`.

El cambio de perfil es físico: `npm run build` aplica `.env.production` sobre
`.env` y deja esos valores activos al terminar. Antes de volver a ejecutar
`doctor`, migraciones o comandos editoriales desde local, recupera el perfil
esperado con `npm run lad` o `node scripts/swap-env.mjs development` y verifica
en el mensaje del script y en `doctor` que el host es el previsto.

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

## Commerce: activo por defecto

BASE instala el selector `liquidstack/commerce` y sus 29 ficheros canónicos,
con `App/config/modules/commerce.php` en `public.enabled=true`. Por ello Tienda
aparece en la navegación de un proyecto nuevo; cada consumidor puede cambiarlo
a `false` si decide no usar el módulo público. Los paths de catálogo y lista de
interés se derivan de `App/config/langs.php`: hay
segmentos propios para español, euskera e inglés y un fallback neutral para
otros locales. No dupliques esas rutas en `App/config/routes/get.php` ni en
`App/config/rutas.js`; el provider de CORE las resuelve después de las rutas
estáticas del proyecto.

El showroom incorpora la categoría `/es/showroom/commerce` (y su equivalente
por idioma) con los tres recursos públicos y veinte prendas ficticias inspiradas
en Matrix. Son fixtures de presentación declaradas exclusivamente en
`App/views/showroom/_commerce.php`: sirven para probar tarjetas, búsqueda,
taxonomías, ficha y lista de interés, pero nunca se insertan en la DB, aparecen
en WebAdmin ni alimentan el catálogo público. Al crear productos reales no hay
que ocultarlas ni borrarlas porque ambas fuentes están totalmente separadas.

La navegación sigue siendo propiedad del proyecto. BASE compone sus enlaces en
`App/config/public-navigation.php`: Blog se muestra siempre y Tienda se añade
solo cuando `commerce.php` tiene `public.enabled=true`, usando sin reconstruir
el path exacto de `public_paths` para el locale activo. Un proyecto consumidor
ya existente debe adoptar expresamente ese helper y sus claves localizadas en
sus propios `_nav.php`, `_footer.php` y catálogos; actualizar CORE no sobrescribe
automáticamente menús ya personalizados.

Commerce comparte con WebAdmin la conexión `LIQUIDSTACK_DB_*`, el transporte
SMTP y la biblioteca Media. Las tres migraciones iniciales son
`0001_commerce_catalog`, `0002_commerce_inquiries` y
`0003_commerce_capabilities`. Revísalas y aplícalas con el flujo común de
migraciones anterior; no necesitan un procedimiento distinto para Commerce:

```powershell
composer liquidstack:doctor --format=json
composer liquidstack:migrate --plan --format=json
composer liquidstack:migrate --dry-run --format=json
# Crea y verifica el backup de DB + Media antes de autorizar la escritura.
composer liquidstack:migrate --apply --yes --format=json
composer liquidstack:migrate --dry-run --format=json
```

Añade `--allow-destructive --backup-confirmed` únicamente si el plan real
informa migraciones destructivas. Esos flags no crean el backup ni deben
usarse por defecto.

Después configura el destinatario de consultas, la versión de privacidad y
SMTP; inicializa Media por el procedimiento común y crea productos, categorías,
etiquetas, atributos y sus variantes de idioma desde WebAdmin. El modo inicial
es exclusivamente `inquiry`: la venta/pago permanece visible como capacidad
futura, pero no es seleccionable. La lista de interés usa una cookie necesaria
HttpOnly, no `localStorage`, y envía dos correos desde un outbox propio: acuse al
visitante y aviso al destinatario administrativo.

En producción programa el dispatcher one-shot desde el scheduler del hosting,
con una frecuencia acorde al proyecto:

```powershell
composer liquidstack:commerce-mail-dispatch --limit=20
```

El comando procesa un lote y termina; Composer no instala cron ni envía correo
durante `install` o `update`. Antes de publicar valida traducciones, URLs,
política de privacidad, catálogo, ficha, lista de interés, correos y sitemap.
Cambiar `public.enabled` a `false` mantiene cerrada toda la superficie pública
aunque el módulo siga disponible en WebAdmin. El contador
«X solicitudes de información» también nace desactivado: habilita
`social_proof.enabled=true` solo como opt-in tras decidir que ese dato debe ser
público y revisar su umbral `minimum_count`.

## Qué personalizar en cada proyecto

Como mínimo:

- `.env`, perfiles y dominios;
- idiomas y slugs públicos;
- `App/config/routes/get.php`, `post.php` y `rutas.js`;
- `App/config/modules/blog.php`, `webadmin.php` y `commerce.php`;
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
composer require "liquidstack/core:^1.35" --with-all-dependencies
```

No hace falta actualizar Blog, WebAdmin o Commerce por separado: comparten la
versión de CORE. El caret se conserva para recibir las siguientes releases
estables `1.x`. `composer update` sin paquete también puede actualizar PHPMailer,
Dotenv, PHPUnit y cualquier otra dependencia; úsalo solo cuando quieras revisar
todo el lock.

Para separar la resolución de dependencias de la escritura de ficheros
gestionados y revisar el lote antes de aplicarlo:

```powershell
composer require "liquidstack/core:^1.35" --with-all-dependencies `
    --no-plugins --no-scripts
composer liquidstack:sync --plan
composer liquidstack:sync --dry-run --format=json
composer liquidstack:sync --apply --plan-hash=sha256:... --yes
composer install
```

El hash solo sirve para el estado exacto que produjo el dry-run. Si CORE, un
destino o el estado cambian, `sync.plan_changed` obliga a revisar un plan nuevo.
El `composer install` final ejecuta las fases deliberadamente separadas del
sync de ficheros: contrato SCSS, Vite, dependencias frontend y skills.

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
una carpeta `dist` adicional. El starter se distribuye sin
`public/.vite/manifest.json` ni bundles compilados para no fijar hashes
obsoletos: después de configurar el registro npm, ejecuta `npm ci` y
`npm run build`. Hasta entonces `doctor` puede avisar de que falta el manifest;
no es una razón para migrar la DB.

El cierre funcional de un proyecto con Blog/WebAdmin/Commerce debe comprobar como
usuario real, al menos:

- home, navegación, footer, cookies y cambio de idioma;
- login, logout y concurrencia con otros stacks;
- listado, creación, edición, publicación y previsualización de posts;
- categorías, etiquetas, SEO, index/follow y acciones del listado;
- biblioteca de medios y límites del servidor;
- índice y artículo públicos, metadatos, sitemap y 404;
- gestión Commerce, catálogo, ficha, filtros, lista de interés, emails y
  contador de solicitudes, cuando `public.enabled=true`;
- responsive y consola/red del navegador sin errores inesperados.

## Releases de BASE

Esta sección se aplica únicamente al checkout mantenedor de BASE. El
inicializador la conserva como referencia documental, pero elimina del proyecto
cliente los scripts, herramientas y tests citados aquí; no intentes publicar un
cliente con el release gate de la plantilla.

BASE tiene un ciclo SemVer independiente de CORE. Sus etiquetas describen el
punto de partida de proyectos nuevos; no se instalan ni se mezclan sobre
proyectos ya nacidos.

### Publicar BASE: bloque corto para PowerShell

Después de confirmar los cambios y dejar el árbol limpio, ejecuta únicamente:

```powershell
composer release
```

Antes de pegarlo, mueve las notas de `Unreleased` a una única sección fechada
`## [X.Y.Z] - AAAA-MM-DD`, confirma los cambios con Git y comprueba que
`git status --short` no muestre nada. Igual que en CORE, `composer release`
detecta la versión desde el changelog y solicita confirmación y descripción.
Si falta una versión pendiente o hay varias, se detiene antes del gate.

El gate exige el árbol limpio, comprueba rama, remoto, changelog, locks y
etiqueta; después valida Composer, ejecuta las pruebas y crea un consumidor
temporal, instala npm, audita y construye el archive. Solo al terminar publica
`main` y la etiqueta con un push atómico. La descripción solicitada pertenece
al tag y no reescribe el commit. No hace falta ejecutar `git push` por separado;
si ya lo hiciste, el gate también lo admite. Nunca copies aquí la versión de CORE:
por ejemplo, BASE `v1.2.0` y CORE `v1.32.0` son releases independientes.

`composer test:create-project` usa el archive local antes de publicar. Tras
crear la etiqueta se puede repetir contra GitHub y, cuando el paquete esté
registrado, contra Packagist:

```powershell
composer test:create-project -- --source=vcs
composer test:create-project -- --source=packagist
```

Ambos modos externos ejecutan un `create-project` real con `--prefer-dist` y
`--remove-vcs`; el fallback VCS usa el remoto canónico de BASE. Si no se indica
`--version`, omiten ese argumento y Composer prueba la última release estable.
`--version=v1.4.2` permite comprobar una etiqueta exacta. No ejecutan
migraciones, Media ni onboarding.

Para diagnosticar sin publicar se puede usar
`composer release -- --dry-run`. No es un paso obligatorio:
repite el gate completo y puede tardar varios minutos.

El alta inicial de `liquidstack/base` en Packagist es un paso externo y
separado del gate Git. Tras registrarlo, Packagist descubre las etiquetas del
repositorio; el fallback VCS documentado en «Crear un proyecto» permite validar
GitHub de forma independiente.

Marcar además el repositorio como GitHub Template es compatible y opcional: no
cambia el paquete ni el flujo `create-project`.

## Fuente de verdad operativa

Las instrucciones especializadas se distribuyen en `.codex/skills`. Para
desarrollo, módulos y promociones hacia CORE deben usarse las skills
`dev-stack`, `liquidstack-module-operations` y
`liquidstack-resource-migration`; este README explica el arranque del starter y
no sustituye sus contratos de trabajo.
