# Proceso de creaciÃ³n de recursos y lÃ³gica de desarrollo

## CreaciÃ³n de nuevos recursos de diseÃ±o de contenido

El stack cuenta con recursos de diseÃ±o de contenido que se han ido creando a lo largo de los diferentes proyectos y se mantienen para su reutilizaciÃ³n. A nivel de producciÃ³n, la vista, recursos y contenido que se cargan en cliente van en funciÃ³n de la url solicitada y su idioma.

El controlador principal del index.php carga los json correspondientes a la ruta y el idioma. Estos json se extraen a variables-objeto que se cargan en global por lo que se tendrÃ¡n en cuenta incluso despuÃ©s de que se renderice todo el contenido de la vista que corresponda a la url. La vista cuenta con snipers que cargan un controlador, el cual renderiza un template sustituyendo los placeholdes por las variables objeto, por lo que se construye el contenido html de forma dinÃ¡mica y teniendo en cuenta el contenido pertinente.

La idea de la construcciÃ³n de nuevos recursos de contenido es la creaciÃ³n de todos los ficheros por cada nuevo recurso, siguiendo la lÃ³gica actual, respetando la escalabilidad y demÃ¡s detalles.

La composiciÃ³n de cada recurso cuenta con:

- Un template html escalable con placeholders para el contenido estÃ¡tico y variable. Este html respeta la semÃ¡ntica y la jerarquÃ­a de encabezados y permite escalabilidad de contenido a travÃ©s de placeholders que puedan cargar un nÃºmero variable de items iguales en estructura (ejemplo de un slider con un nÃºmero a decidir de viÃ±etas). El nÃºmero de items que se carguen se manejarÃ¡ desde el sniper del controlador PHP.

- Un sniper de controlador que carga el controlador PHP especÃ­fico del recurso. Este sniper se encarga de llamar a la funciÃ³n "controller" enviando varios parÃ¡metros: 
    - El nombre del controlador para poder cargar el fichero del controlador pertinente.
    - Un valor numÃ©rico que permita distingirse a modo de versiÃ³n de otros sniper del mismo recurso en la misma vista por llevar contenido diferente. Si se usan dos sniper de un mismo recurso y comparten versiÃ³n, tendrÃ¡n el mismo contenido.
    - Opcional un array asociativo que permita asignar a los placeholders indicados en el mismo otros valores. Esto sirve por si se guarda el valor renderizado de un recurso en una variable, y esta se asigna como valor a un placeholder de otro recurso (ver ejemplos en _templates.php)

- Un controlador que sustituye los placeholders del template html por variables objeto y lo renderiza. Este controlador es el que tiene la lÃ³gica escalable y el que sustituye los placeholders por contenido y/o variables objeto. Puede recibir como parÃ¡metro valores que se asignarÃ¡n a los placeholders indicados. Algunos de estos controladores generan de forma dinÃ¡mica recursos de estructura igual, que se diferencian por un valor incremental ($letter), asignando variables objeto de clave diferente. Al final el controlador devuelve la renderizaciÃ³n del template con las sustituciones.

- Un recurso .scss donde irÃ¡n los estilos particulares de dicho recurso. Este archivo cargarÃ¡ con @use elementos de configuraciÃ³n que traerÃ¡n las variables del proyecto.
- Un recurso opcional .js, que de igual forma tendrÃ¡ la lÃ³gica dentro de una funciÃ³n init y que cargarÃ¡ los recursos que requiera.

Si un recurso, por ejemplo el artÃ­culo 5, se incluye dentro de la vista "inicio", debera existir dentro del archivo inicio.scss el @use del recurso del artÃ­culo 5. Lo mismo si lleva requiere js, su recurso serÃ¡ incluido en inicio.js.


En etapa de desarrollo, vite recarga en caliente tanto php como js y scss. SegÃºn el php se modifica, vite ejecuta de forma automÃ¡tic la funciÃ³n de aÃ±adir al json las claves valor del controlador que se haya aÃ±adido en la vista. Lo mismo si se quita, borrÃ¡ndo dichas claves siempre que no sea un recurso global. Lo que no hace de forma automÃ¡tica es aÃ±adir el @use del recurso scss al scss principal de la vista.

## GuÃ­a para agentes

Cuando el usuario solicite crear un nuevo recurso o mejorar uno existente, sigue estos pasos:

1. **Template HTML**
   - UbÃ­calo en `App/templates/` con el prefijo `_` y placeholders para todo el contenido dinÃ¡mico.
   - MantÃ©n la semÃ¡ntica y permite un nÃºmero variable de items. Los placeholders repetibles se ampliarÃ¡n segÃºn el parÃ¡metro `items`.

2. **Sniper / vista**
   - En las vistas utiliza `controller('nombre', $version, $placeholders, $items)` para invocar al recurso.
   - `$items` indica cuÃ¡ntos elementos debe generar el controlador.

3. **Controlador PHP**
   - Reside en `App/controllers/` y recibe los parÃ¡metros del sniper.
   - Genera las claves de idioma combinando `$pad` y `$letter` para cada item solicitado.
   - Sustituye los placeholders del template y devuelve el HTML renderizado.

4. **Estilos y JS**
   - Crea `src/scss/resources/_recurso.scss` y, si procede, `src/js/resources/recurso.js`.
   - Importa estos archivos en los scss/js principales de la vista mediante `@use` o `import`.

5. **ActualizaciÃ³n de idiomas**
   - Ejecuta `php tools/update-languages.php <vista>` para aÃ±adir las nuevas claves al JSON correspondiente.

6. **Comprobaciones**
   - Ejecuta `php -l` en cada archivo PHP modificado.
   - AsegÃºrate de que la cantidad de items generados coincide con `$items` y que cada clave de idioma es Ãºnica.

7. **Valores de referencia en `templates`**
   - El nÃºmero de `items` definido en `App/views/_templates.php` actÃºa como cantidad por defecto para el controlador. Al refactorizar un recurso existente, conserva en `App/config/languages/templates/*.json` valores Â«dummyÂ» para ese nÃºmero de items. Estas entradas sirven como referencia cuando el recurso se incluye en otras vistas con un mayor nÃºmero de elementos.
   - Si cambias los nombres de las claves al refactorizar, actualiza esas claves en los JSON de `templates` pero **no elimines sus valores**. El script `update-languages.php` borra cualquier clave sin valor y, al reutilizar el recurso en otras vistas, las claves aparecerÃ¡n vacÃ­as.

8. **Ãndice de instancia en las claves**
   - Las claves de los JSON deben incluir el Ã­ndice de instancia (`00`, `01`, etc.) seguido de la letra del item, p. ej. `recurso_00_a_img`. Si el Ã­ndice se omite, `update-languages.php` interpreta que la clave no se usa y la eliminarÃ¡ al modificar `items` o al reutilizar el recurso en otras vistas. AsegÃºrate de que el controlador genere nombres con `$pad` y que los JSON de `templates` conserven esas claves de referencia.

9. **Prefijo de las claves de idioma**
   - El prefijo de cada clave debe coincidir exactamente con el nombre del controlador (por ejemplo, `sectTabs01_`). Si se emplean abreviaturas distintas, `update-languages.php` no podrÃ¡ reutilizar los valores de referencia y eliminarÃ¡ las entradas al variar `items`.

10. **JS para items variables**
    - La lÃ³gica en los archivos JS debe basarse en los Ã­ndices de los elementos del DOM y no en atributos `data-*` derivados de claves de idioma. AsÃ­ se evita que al cambiar el nÃºmero de items aparezcan animaciones o comportamientos errÃ³neos.

### Nota sobre controladores y comentarios de rangos

- Todos los controladores de contenido deben iniciar con el bloque de comentarios que documenta los rangos mÃ­nimo y mÃ¡ximo de cada pieza de copy.
- Los valores dummy presentes en los JSON de `templates` contienen informaciÃ³n particular acordada con el cliente. No inventes ni modifiques esos textos salvo que el encargo lo solicite expresamente.
- En nuevas tareas donde se creen controladores adicionales, limita los cambios al docblock de rangos y a la estructura necesaria; cualquier redacciÃ³n o ajuste de contenido debe validarse con el usuario antes de aplicarse.

## GestiÃ³n de jerarquÃ­a de encabezados

- Cuando el placeholder `{header-primary}` se sustituya por un recurso cuyo encabezado principal use un nivel diferente al previsto originalmente, el controlador responsable debe recalcular automÃ¡ticamente los niveles de los encabezados secundarios asociados. Cada encabezado descendiente debe aumentar su nivel relativo (`hN â†’ hN+1`) respetando el lÃ­mite mÃ¡ximo de `<h6>`.
- Implementa esta lÃ³gica mediante un helper reutilizable para evitar cÃ¡lculos dispersos. Un ejemplo sencillo serÃ­a:

  ```php
  function buildHeadingTag(int $baseLevel, int $increment = 0): string {
      $level = min(6, max(1, $baseLevel + $increment));
      return 'h' . $level;
  }
  ```

  Con este helper un controlador puede generar tanto el encabezado principal como los secundarios, por ejemplo `buildHeadingTag($baseLevel, 1)` para el subtÃ­tulo.
- Si el recurso inyectado no permite inferir su nivel de encabezado (por ejemplo, porque el markup proviene de un editor externo), habilita un parÃ¡metro opcional en el `controller()` que permita fijar explÃ­citamente el nivel base. Una llamada ilustrativa serÃ­a `controller('hero', $version, ['base_heading_level' => 3])`, que el controlador utilizarÃ­a como `$baseLevel` al invocar `buildHeadingTag`.

## Estilos responsive (mobile-first)

- En nuevos recursos, escribe el SCSS con enfoque mobile-first: base para mÃƒÂ³vil y breakpoints con `@media (min-width: ...)` para tablet/desktop.
- Evita usar `max-width` en recursos nuevos, salvo que exista una razÃƒÂ³n concreta.
- Usa las variables del config (`c.$tablet`, `c.$desktop`) para los breakpoints.
- Coloca los `@media (min-width: ...)` dentro de cada selector que lo necesite (no agrupar bloques por breakpoint).


## Nota sobre traducciones

- Comprueba siempre que las claves `data-lang` creadas por los controladores mantengan su estructura de objeto en los JSON (por ejemplo `text`, `alt`, `title`, etc.). El script `update-languages.php` completarÃ¡ las propiedades vacÃ­as utilizando los templates si detecta arrays vacÃ­os, pero asegÃºrate de que cada texto o atributo traducible tenga su variable objeto y el `data-lang` correspondiente para evitar que se creen entradas planas.



