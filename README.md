Stack BASE: plantilla de nuevos proyectos LiquidStack

# Tips para instalación y uso de este framework

A continuación describiremos algunas casuísticas y tips a tener en cuenta para la instalación, configuración inicial y uso del framework.

## Crear un proyecto desde BASE

BASE contiene la estructura inicial que CORE no debe sobrescribir en un
proyecto ya existente. En particular, su `src/scss/_config.scss` es la
referencia completa del contrato de colores actual: familias `color00` a
`color04`, variantes y filtros SVG. Los recursos estándar de CORE solo
dependen de `color00` a `color03`; `color04` y posteriores quedan para tema y
modificadores del proyecto.

Al crear un proyecto:

1. Copia o clona BASE sin `vendor`, `node_modules`, `composer.lock` ni los
   assets compilados.
2. Ejecuta `composer install` y `npm install`.
3. Crea `.env` desde `.env.example`.
4. Ejecuta `composer liquidstack:doctor` para conocer los requisitos locales
   pendientes, sin aplicar migraciones.
5. Personaliza los valores de `_config.scss`, pero conserva las claves del
   contrato.
6. Define las rutas, idiomas, navegación, branding y copy propios.

Si la copia física de BASE incluye un `composer.lock` local, elimínalo antes de
la primera instalación para no heredar una versión antigua de CORE. BASE no
versiona ese lock.

## Qué actualiza CORE y qué conserva el proyecto

`composer install` y `composer update liquidstack/core` sincronizan recursos,
controladores, templates, helpers, herramientas, catálogo del showroom y las
skills base de `.codex/skills`. La sincronización es aditiva y usa el
manifiesto `.liquidstack/core/managed-files.json`: actualiza copias conocidas,
añade novedades y preserva personalizaciones locales desconocidas.

BASE selecciona `liquidstack/blog`, que activa también su dependencia
`webadmin`; ambos se distribuyen desde el mismo paquete versionado de CORE.
Esto deja disponibles sus providers, assets y shell público desde el primer
`composer install`, sin copiar implementaciones desde otro proyecto. Su uso
real sigue siendo explícito: cada proyecto aporta secretos y configuración,
revisa `doctor`, hace backup y solo entonces autoriza sus migraciones.

El starter aporta además una vista de índice personalizable en `/es/blog` y
`/eu/blog`, el shell de artículo y configuraciones no secretas para ambos
módulos. WebAdmin vive en `/admin`; Blog y WebAdmin comparten por defecto la
conexión `BBDD_*` con prefijos de tabla independientes. Cambiar a la conexión
dedicada `liquidstack` es una decisión project-owned y exige completar las
variables `LIQUIDSTACK_DB_*`.

Son propiedad del proyecto y no se sustituyen de forma global:

- `src/scss/_config.scss`, `_global.scss` y los SCSS/JS de cada página;
- `App/config/routes/get.php`, `post.php` y `rutas.js`;
- `.env`, idiomas habilitados, navegación, footer, logos y copy;
- base de datos, usuarios, medios, correo y credenciales;
- `.codex/config.toml` y las skills locales no gestionadas por CORE.

Las rutas privadas propias que añada cada proyecto deben declarar
`'sitemap' => false`. Las rutas de WebAdmin y Blog pertenecen a sus providers
de CORE y no se duplican en `App/config/routes/get.php`.

CookieLad queda desactivado mientras `COOKIE_LAD_KEY` esté vacío. Cada proyecto
debe usar su propia clave y color en `.env`; BASE no distribuye credenciales de
consentimiento ni modifica el DOM interno del widget.

CORE solo amplía `_config.scss` de forma quirúrgica cuando falta una variable
requerida; no cambia colores existentes. Por eso BASE mantiene el fichero de
referencia completo para que un proyecto recién creado no nazca con aliases
históricos incompatibles.

## Desarrollo local

1. Completa tu `.env` (se puede generar copiando `.env.example`) con todas las credenciales y secretos del proyecto. Ese archivo nunca se versiona y actúa como fuente de verdad para el resto de variables.
2. Personaliza `.env.production` y `.env.development` únicamente con las claves que deben variar entre perfiles (por defecto redefinen `RAIZ`, `DEV_MODE`, `DISPLAY_ERROR` y `LANG_SKIP_UPDATE`).
3. Usa Node `^20.19` o `>=22.12` e instala dependencias con `npm install`.
4. Para trabajar en desarrollo existe un comando que levanta todo el entorno:
   - `npm run lad` aplica `.env.development`, busca para PHP el primer puerto
     libre desde `1309` y para Vite el primero desde `5173`, e inyecta ambos
     orígenes efectivos al runtime.
   - También puedes usar `npm run dev` si ya tienes un servidor PHP iniciado manualmente.
5. Antes del primer build real sustituye el origen reservado `https://example.com`
   de `.env.production` por el dominio canónico del proyecto. Después ejecuta
   `npm run build`, que sincroniza ese perfil, genera el sitemap multilingüe con
   `hreflang` y compila los assets dentro de `public/assets`.

Los recursos se sirven siempre desde `public/assets`, por lo que no se genera ninguna carpeta `dist` adicional.

### Puertos locales concurrentes

No hay que editar archivos para abrir varios proyectos a la vez. Cada
`npm run lad` reserva sus puertos y mantiene estable la pareja elegida durante
ese proceso. Por ejemplo, si otro stack usa `1309` y `5173`, el siguiente
normalmente arrancará en `1310` y `5174`.

Los overrides `LIQUIDSTACK_DEV_APP_PORT` y
`LIQUIDSTACK_DEV_VITE_PORT` fuerzan puertos exactos y fallan si están
ocupados. `LIQUIDSTACK_DEV_PHP_BINARY` permite escoger el ejecutable PHP sin
imponer una instalación concreta. El supervisor publica además
`LIQUIDSTACK_DEV_APP_ORIGIN`, `LIQUIDSTACK_DEV_VITE_ORIGIN` y una identidad
opaca del proyecto; las sesiones de WebAdmin no dependen del número de puerto
y permanecen separadas entre stacks y dominios.

### Gestión de perfiles `.env`

- El script `node scripts/swap-env.mjs <perfil>` **no** borra tu `.env`. En su lugar lee `.env.<perfil>` y sobreescribe únicamente las claves listadas (ej. `RAIZ`, `DEV_MODE`, `DISPLAY_ERROR`) dentro de tu `.env` existente. Si `.env` no existe, se crea a partir de `.env.example` para que tengas el resto de variables disponibles.
- Para crear un nuevo perfil (por ejemplo `staging`) duplica `.env.production` como `.env.staging` e incluye únicamente los pares `CLAVE=valor` que deban imponerse sobre tu `.env` habitual. Después ejecuta `node scripts/swap-env.mjs staging && npm run <tarea>`.
- Si necesitas sobreescribir temporalmente una variable, lanza primero `node scripts/swap-env.mjs <perfil>` y modifica la clave directamente en `.env`. El archivo `.env` conservará el resto de valores personalizados y sólo se tocarán las claves definidas en el perfil la próxima vez que corras el script.

## Herramientas de desarrollo

Durante el desarrollo disponemos de varios scripts auxiliares:

- `php tools/update-languages.php <slug>`: analiza la vista indicada y los includes globales para generar o completar los ficheros de idiomas en `App/config/languages/<slug>/<lang>.json`.
- `php App/tools/build-sitemap.php`: crea `public/sitemap.xml` con todas las variantes de idioma enlazadas mediante `xhtml:link`.

## Validación y pruebas

- Instala las dependencias PHP (incluido `liquidstack/core` con versionado semántico compatible) con `composer install`.
- Ejecuta `vendor/bin/phpunit` o `composer test` para correr las pruebas unitarias de helpers/controladores y el smoke test de `public/index.php`.
- Lanza esta batería después de actualizar `liquidstack/core` para detectar regresiones en el enrutado y en los recursos compartidos.

## Paquete reutilizable `liquidstack/core`

- El núcleo del stack se publica como paquete Composer con namespace `App\Core\` y helpers cargados vía autoload.
- Los eventos `post-install-cmd` y `post-update-cmd` sincronizan automáticamente `public/index.php` y los activos PHP críticos desde CORE hacia el proyecto consumidor.
- El punto de entrada `public/index.php` delega ahora en `App\Core\Application`, que centraliza la carga de entorno, rutas y helpers.
- Los controladores, templates y herramientas agnósticas se copian automáticamente a `App/` tras `composer install`/`composer update`, de modo que en producción siguen disponibles fuera de `vendor`. Esto incluye `App/tools`, que reaparece en cada instalación aunque BASE lo ignore.
- Los recursos frontend se sincronizan hacia `src/js/resources`, `src/scss/resources` y `public/assets` antes de lanzar Vite.

## Editor en línea de traducciones

El editor en línea sólo está disponible cuando `DEV_MODE=true` en el entorno y permite ajustar textos y atributos de cualquier elemento con `data-lang` sin recargar la página.

### Puesta en marcha

1. Arranca el stack con `npm run lad`, que levanta el servidor PHP y Vite en modo desarrollo.
2. Accede a la URL local elegida por el supervisor con `DEV_MODE=1`. El
   editor no depende del antiguo sistema de usuarios; nunca expongas este modo
   en un dominio público.

### Uso del editor

- Mantén pulsada la tecla `Ctrl` y haz doble clic sobre cualquier elemento con `data-lang` para abrir el modal de edición. El atajo también funciona sobre enlaces sin navegar gracias al bloqueo temporal del `click` con `Ctrl`.
- El modal muestra todos los campos disponibles para esa clave (texto, `href`, `alt`, etc.). Ajusta los valores necesarios y pulsa **Guardar** para enviarlos a `/languages/update`.
- Puedes seleccionar varios elementos a la vez si el doble clic se realiza sobre un contenedor que agrupa varias claves; cada una aparecerá como una sección dentro del formulario.
- Los enlaces (`<a>`) y ahora también los contenedores multimedia (`<video>`) incluyen automáticamente sus elementos hijos con `data-lang` (como `<source>`) en el formulario, de forma que puedas ajustar de una sola pasada todos los atributos relacionados.
- Para imágenes y otras etiquetas multimedia, el modal añade una sección **Atributos HTML** donde podrás actualizar `srcset`, `sizes`, `width`, `height`, `loading` y el resto de atributos gestionados desde los JSON. Al guardar se escriben los nuevos valores en los ficheros de idioma y se reflejan de inmediato en la vista para su comprobación.
- Las etiquetas sin contenido textual (como `<img>`, `<meta>` o `<input>`) ocultan automáticamente el campo **text** y sólo muestran los atributos editables definidos en los JSON, evitando confusiones con valores que no se utilizan.
- Pulsa `Esc` o el botón **Cancelar** para cerrar sin aplicar cambios.

### Cambio de idioma

- El selector de idiomas actualiza la URL y todo el contenido sin recargar la página. Tras este cambio, el editor detecta automáticamente el nuevo idioma y limpia su caché interna, por lo que al volver a abrirlo mostrará los textos actualizados sin necesidad de refrescar manualmente.
- Los enlaces relativos editados se reescriben con la ruta correspondiente al idioma activo, y las rutas vacías se sustituyen por la home del idioma actual.

## Uso de controladores en las views

Las views PHP pueden renderizar componentes reutilizables mediante la función `controller('nombre', índice, [vars])`. Cada controlador devuelve un fragmento HTML y puede recibir parámetros para sustituir placeholders.

En los ficheros SCSS y JS de cada vista se deben importar manualmente los recursos de los controladores utilizados mediante `@use` o `import`. Si se elimina un controlador de una vista, también deben retirarse sus imports correspondientes.

### Enlaces multilingües y rutas externas en los controladores

Cuando un recurso necesite exponer un enlace configurable desde los JSON de idiomas utiliza siempre el helper `resolve_localized_href()` definido en `App/config/helpers.php`. Este helper centraliza la construcción del `href` combinando la raíz del proyecto (`$_ENV['RAIZ']`), el idioma activo y la ruta configurada, respetando al mismo tiempo valores absolutos para URLs externas o esquemas especiales (`mailto:`, `tel:`, `#ancla`, etc.).

```php
$ctaHref = resolve_localized_href($ctaObj->href ?? '');
```

Con esta llamada los contenidos pueden introducir:

- Rutas internas (`"/distribuidores"`, `"contacto"`, etc.), que se completarán automáticamente con el dominio e idioma activo.
- URLs absolutas (`"https://example.com"`, `"mailto:info@example.com"`, …), que el helper devolverá tal y como se escriban en el JSON.

Si necesitas recuperar únicamente la ruta interna sin anteponer el dominio, pasa la opción `['absolute' => false]`:

```php
$ctaHref = resolve_localized_href($ctaObj->href ?? '', ['absolute' => false]);
```

Utiliza siempre este helper cuando añadas nuevos recursos o refactorices controladores existentes con enlaces configurables para garantizar un comportamiento homogéneo en todos los idiomas.

## Itinerario para nuevas views

1. **Arquitectura de URL**: definir manualmente en `App/config/routes/get.php` la ruta, recursos y contenido a servir por cada URL, teniendo en cuenta los diferentes idiomas y un estudio SEO del sector y del negocio.
2. **Creación de views y recursos**: para cada entrada en `get.php` crear la vista PHP, la carpeta de contenido en `App/config/languages/<slug>` (los JSON se generan con el script de idiomas) y los archivos `.scss` y `.js` en `src/` cuando la ruta haya declarado `resources`. Estos archivos deben importar los controladores necesarios según se añadan o eliminen en cada vista.

## Clase PHP para convertir en amigables las fechas

Requiere en php.ini
```bash
extension=intl
```
De esta forma podemos usar la clase PHP IntlDateFormatter. 
```php
function formattedDate($date)
{
    // Verificar si es un timestamp o string, convertirlo a DateTime
    if (!($date instanceof DateTime)) {
        $date = new DateTime($date);
    }

    // Crear un formateador de fecha en español
    $formatter = new IntlDateFormatter(
        'es_ES', // Locale español
        IntlDateFormatter::LONG, // Fecha en formato largo
        IntlDateFormatter::MEDIUM // Hora en formato medio
    );

    return $formatter->format($date);
}
```` 
Donde la llamamos y recibimos la fecha amigable.
```php
<td> <?= formattedDate($tarifa["fecha_actualizada"]); ?></td>
```



## Parámetros recomendables en php.ini para subir archivos y aumentar tiempo de ejecución
```bash
upload_max_filesize = 512M
max_file_uploads=200
max_input_vars = 5000
max_execution_time = 500
max_input_time = 500
```

## Instalación de APCU para memoria en caché de servidor XAMPP y tb en el host de Dinahosting

1. Coger tu versión de PHP en la consola

```bash
php -i | findstr "PHP Version"
php -i | findstr "Thread"
```
![alt text](/.readme/image.png)

2. Quedarse con la versión y si es NS o NTS

3. Descargar el archivo correcto de esta url: https://pecl.php.net/package/APCu/5.1.24/windows

En mi caso, es php versión 8.2.12 y NS

![alt text](/.readme/image-1.png)

4. Descomprimir el archivo y coger el **php_apcu.dll**

5. Moverlo a la dirección del XAMPP

```bash
C:\xampp\php\ext
```
6. en php.ini añadir la línea
```bash
extension=apcu
```

opcional: se pueden poner valores por defecto
```bash
[apcu]
apc.enabled=1
apc.shm_size=32M  ; Tamaño de memoria para la caché (ajusta según necesidad)
apc.ttl=3600      ; Tiempo de vida por defecto en segundos
```
7. reiniciar Apache y server VSC. comprobar en consola si está bien instalado con
```bash
php -m | findstr apcu
```

8. En php info comprobar si está instalado
```php
<?php phpinfo(); ?>
```
### Problemas comunes

- DLL no compatible: Si al reiniciar recibes un error como "The specified module could not be found", verifica que la versión de APCu coincida con tu PHP (versión, TS/NTS, 32/64 bits).

- Ruta incorrecta: Asegúrate de que extension_dir en php.ini apunte al directorio correcto (ajústalo si es necesario con extension_dir="C:\xampp\php\ext").

- En el Intelephense habrá que dar de alta este dll, por lo que iremos a configuración, donde stubs, y agregaremos "apcu"


### ejemplo de código

```php
$cache_key = 'urls_amigables_cache';
$cache_ttl = 3600;

$urls_amigables = apcu_fetch($cache_key);
if ($urls_amigables === false) {
    if ($con->connect_error) die("Error de conexión: " . $con->connect_error);
    $sql = "SELECT url_amigable FROM hyegb7_distribuidores";
    $resultado = $con->query($sql);
    $urls_amigables = [];
    if ($resultado->num_rows > 0) {
        while ($fila = $resultado->fetch_assoc()) {
            if (!empty($fila["url_amigable"]) && $fila["url_amigable"] !== null) {
                $urls_amigables[] = $fila["url_amigable"];
            }
        }
    }
    apcu_store($cache_key, $urls_amigables, $cache_ttl);
    $con->close();
}
````

- Si queremos invalidar la caché
```php
apcu_delete()
```

## Uso de los Templates para reutilizar html y contenido dinámico en las views

### Guia agnostica para crear recursos (template, data-lang, scss, js, controlador)

Checklist basico para que un recurso sea reusable y escalable:

1. **Template HTML** (`App/templates/_recurso.html`)
   - Usa un wrapper con clase unica del recurso (ej. `.art18`) y opcional `{classVar}`.
   - Todo texto o atributo editable debe llevar `data-lang` y placeholders separados:
     - Texto: `data-lang="{x-dl}"` + `{x-text}`
     - Enlaces: `data-lang="{x-dl}"` + `{x-href}` + `{x-title}` + `{x-text}`
     - Imagenes: `data-lang="{x-dl}"` + `{x-src}` + `{x-alt}` + `{x-title}`
   - Para elementos repetibles usa `{items}` (y placeholders internos del item).

2. **SCSS** (`src/scss/resources/_recurso.scss`)
   - Anida todo dentro de `.artXX` para evitar conflictos con otros recursos.
   - Usa variables de `src/scss/_config.scss` (`c.$color..`, `c.$fuente..`) en lugar de hex/rgba.
   - Evita tocar `body`, `html`, `*` o reglas globales.

3. **JS** (`src/js/resources/_recurso.js`)
   - Inicializa por instancia: `document.querySelectorAll(".artXX")`.
   - Evita listeners globales si el efecto es local al recurso.
   - Para items variables usa indices del DOM, no `data-lang`.

4. **Controlador** (`App/controllers/artXX.php`)
   - Prefijo de claves: `artXX_{$pad}_...` (incluye indice `00`, `01`, etc).
   - Usa `resolve_header_levels()` para jerarquia de headings.
   - Usa `resolve_localized_href()` para enlaces.
   - Soporta `items` (numero de cards) y `list_items` (numero de `li` por item):
     - `list_items` puede ser un numero global o un array por letra/indice.
   - Si hay valores dummy en templates, puedes usarlos como fallback.

5. **Sniper en la vista**

```php
<?php
echo controller('art18', 0, [
    'items' => 3,
    'list_items' => [
        'a' => 2,
        'b' => 3,
        'c' => 4,
    ],
]);
?>
```

6. **Idiomas y templates**
   - Anade valores dummy en `App/config/languages/templates/<lang>.json` con el mismo prefijo y con indice (`00`).
   - Ejecuta `php tools/update-languages.php <slug>` para generar claves en la vista.

Primero debemos tener ya preparados los templates con sus scss correspondientes. 

![alt text](/.readme/image-2.png)

En el scss de la vista en concreto, debemos cargar el componente scss del template que vayamos a usar.

![alt text](/.readme/image-3.png)

El template tendrá placeholders { clave } que serán identificados desde la vista y sustituidos por valores estáticos o variabilizados

```html
<article class="art07">
    <!-- ===== Primer hijo ===== -->    
    <div class="art07-parallax">
        {span-bg-hero-img}
        <h3>
            <span data-lang="{h3-1-dl}">{h3-1-text}</span>
            <span data-lang="{h3-2-dl}">{h3-2-text}</span>
        </h3>
    </div>

    <!-- ===== Segundo hijo ===== -->
    <div>
        <p data-lang="{p-dl}">{p-text}</p>

        <h4 data-lang="{h4-dl}">{h4-text}</h4>

        <div class="art07-matrix">
            <div class="card-parallax">
                {span-bg-img}
            </div>
            <div></div>
            <div class="card-parallax">
                {span-bg-img}
            </div>
            <div></div>
            <div class="card-parallax">
                {span-bg-img}
            </div>
            <div></div>
        </div>
    </div>    
</article>
```

En la vista en cuestión, donde queramos cargar el template, incluimos las variabilización de los idiomas, incluyendo la variabilización del valor del atributo data-lang, ya que si este template se usa dos veces dentro de la misma vista pero con textos diferentes, debemos poder diferenciar los data-lang de un recurso a otro igual dentro de la misma vista.

```php
<?php
// art07
$bgImgHero='
<span class="bg"
        data-bg-mobile="https://dummyimage.com/1000x1000"
        data-bg-tablet="https://dummyimage.com/1500x1500"
        data-bg-desktop="https://dummyimage.com/2560x3500"
        style="background-image:url(https://dummyimage.com/2560x1600)">
</span>
';
$bgMatrix='
<span class="bg"
        data-bg-mobile="https://dummyimage.com/1500x1500"
        data-bg-tablet="https://dummyimage.com/2500x2500"
        data-bg-desktop="https://dummyimage.com/2560x4050"
        style="background-image:url(https://dummyimage.com/2560x1600)">
</span>
';
$pageVars = [
    /* ------- Encabezado compuesto ------- */
    '{span-bg-hero-img}' => $bgImgHero,
    '{h3-1-dl}'   => '',
    '{h3-1-text}' => 'Encabezado h3',
    '{h3-2-dl}'   => '',
    '{h3-2-text}' => 'y palabras en tipografía grande',

    /* ---------- Segundo hijo ---------- */
    '{p-dl}'   => '',
    '{p-text}' => 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Non id asperiores voluptate placeat quis similique quas itaque magni quos error corporis iusto, exercitationem ducimus libero esse animi omnis consectetur magnam.',

    '{h4-dl}'   => '',
    '{h4-text}' => 'Encabezado h4',

    '{span-bg-img}' => $bgMatrix,
    
];
echo render('/templates/_art07.html', $pageVars);
?>
```

En estos render de las plantillas incluiríamos las variables de los textos según los json de idiomas, para que se mostrase en todo momento el idioma seleccionado de forma dinámica.

Recordamos que nuestro stack funciona con tema idiomas de dos formas. Primero en función del idioma carga el contenido desde servidor usando o un json u otro, donde las variables adquieren un valor u otro según el idioma.

Pero en caso de que el usuario cambie de idioma, la página no refresca, sólo cambia la url por la equivalente en el idioma seleccionado y repasa todas las etiquetas html que tengan atributo data-lang, cogiendo su valor y buscándolo dentro del json del nuevo idioma seleccionado. Si encuentra la clave y la segunda clave de la misma (ejemplo "t01" y dentro otra clave "text"), pues ejecuta para dicho elemento html un innerHtml con el valor de la clave "txt" en este caso. Es decir, que cambia el texto visible.

Esta forma de gestionar el idioma aumenta el UX con el usuario, ya que evitamos recargar la página para cargar el contenido en otro idioma, pero si este mismo refresca la página, como se ha cambiado la url por la equivalente en el nuevo idioma, verá que se carga la misma página en el idioma seleccionado. Doble experiencia.

## Si queremos hacer un parallax en una vista donde haya scroll Smooother

Si queremos añadir el efecto parallax en algún div con una img de fondo al estilo attachment fixed, debemos añadir el componente de JS y algunos recursos más front end, ya que este estilo no convive con el efecto de GSAP.

```scss
background-attachment: fixed;
```

Lo primero es cargar nuestro recurso JS de GSAP en el JS de nuestra vista

```js
import gsapParallax from "./_gsapParallaxScroll.min.js"
```

Lo segundo será tener en cuenta que en el html, meteremos una imagen de fondo dentro de un div con clase "bg". Tendrá esta estructura de data-set que permitirá a JS saber qué imagen debe cargar de forma dinámica según se redimensione el viewport.

```html
<header class="hero-parallax">
    <span class="bg"
        data-bg-mobile="https://dummyimage.com/1000x1000"
        data-bg-tablet="https://dummyimage.com/1500x1500"
        data-bg-desktop="https://dummyimage.com/2560x3500"
        style="background-image:url(https://dummyimage.com/2560x1600)">
    </span>
</header>
```
Y también hacemos referencia a bg dentro de los estilos, sin olvidar darle position relative y overflow hidden al que sea su padre
```scss
header{
    position: relative;
    overflow: hidden;
    width: 100%;
    min-height: 50dvh;
    // más estilos..
    
    // Estilos mínimos necesarios para .bg
    .bg{ 
        position:absolute;
        background-position: center;
        inset:0; 
        will-change:transform;
    }
}
```

Y después configuramos este elemento en nuestro JS de la vista, donde  hacemos referencia a la clase que contenga el elemento de clase "bg" y le decimos cuánto debe moverse tanto en desktop como móvil, además de qué ancho tendrá la imagen de fondo: "cover", "containHeight" o "containWidth".

```js
gsapParallax({
    container: ".hero-parallax",
    bg: ".bg",
    moveDesktop: 20,
    moveMobile : 20,
    sizeMode   : "cover"
});
```

Así quedaría todo el código en el JS de la vista de la página de inicio, donde además, hay otros 3 elementos que requieren de efecto parallax. Dentro de la función una vez cargue el dom, se debe poner todo ese código que incluye una función para cambiar de imagen de fondo en función del redimensioneo y tamaño del viewport.

```js
import "./_global.min.js"
import gsapParallax from "./_gsapParallaxScroll.min.js"

const doc = document
doc.addEventListener('DOMContentLoaded',()=>{

    // GSAP PARALLAX SCROLL--
    
    /* ── función que cambia la imagen según ancho ────────────────── */
    function swapBG(){
        const w = innerWidth;
        document.querySelectorAll(".bg[data-bg-mobile]").forEach(el=>{
            const url =
            w < 800  ? el.dataset.bgMobile  :
            w < 1400 ? el.dataset.bgTablet  :
                        el.dataset.bgDesktop;
            el.style.setProperty("background-image", `url(${url})`, "important");
        });
    }                               // llamada inicial

    /* --- debounce con delayedCall ----------------------------------- */
    let dc;
    const swapAndRefresh = () => {
    swapBG();
    ScrollTrigger.refresh();   // recalcula tamaños y offsets
    };

    window.addEventListener("resize", () => {
    dc && dc.kill();
    dc = gsap.delayedCall(0.15, swapAndRefresh);
    });

    /* llamada inicial */
    swapAndRefresh();


    /* ── header parallax ────────────────────────────────────────────── */
    gsapParallax({
      container: ".hero-parallax",
      bg: ".bg",
      moveDesktop: 20,
      moveMobile : 20,
      sizeMode   : "cover"
    });

    /* ── art07 parallax ────────────────────────────────────────────── */
    gsapParallax({
      container: ".art07-parallax",
      bg: ".bg",
      moveDesktop: 30,
      moveMobile : 20,
      sizeMode   : "cover"
    });

    /* ── art07 parallax grid ────────────────────────────────────────────── */
    gsapParallax({
      container: ".art07-matrix",
      sizeMode : "containHeight"   // o "containWidth" según tu ajuste final
    });    

    // FIN GSAP PARALLAX SCROLL--
    

});
```


























## Actualizar archivos de idioma

Ejecutar el script de utilidades para generar las claves de idioma faltantes a partir de una vista. El script analiza los controladores usados en la vista y en cualquier archivo incluido. Cuando un include pertenece a `php/includes`, las claves se añaden al fichero `config/languages/global`.

El script mantiene intactas las claves ya presentes y solo inserta las que falten. Las nuevas claves se rellenan con valores dummy desde `config/languages/templates`, usando únicamente los atributos requeridos por cada controlador. Requiere tener instaladas las dependencias de Composer.


```bash
php tools/update-languages.php <slug>
```

