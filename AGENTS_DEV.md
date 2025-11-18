# Proceso de creación de recursos y lógica de desarrollo

## Creación de nuevos recursos de diseño de contenido

El stack cuenta con recursos de diseño de contenido que se han ido creando a lo largo de los diferentes proyectos y se mantienen para su reutilización. A nivel de producción, la vista, recursos y contenido que se cargan en cliente van en función de la url solicitada y su idioma.

El controlador principal del index.php carga los json correspondientes a la ruta y el idioma. Estos json se extraen a variables-objeto que se cargan en global por lo que se tendrán en cuenta incluso después de que se renderice todo el contenido de la vista que corresponda a la url. La vista cuenta con snipers que cargan un controlador, el cual renderiza un template sustituyendo los placeholdes por las variables objeto, por lo que se construye el contenido html de forma dinámica y teniendo en cuenta el contenido pertinente.

La idea de la construcción de nuevos recursos de contenido es la creación de todos los ficheros por cada nuevo recurso, siguiendo la lógica actual, respetando la escalabilidad y demás detalles.

La composición de cada recurso cuenta con:

- Un template html escalable con placeholders para el contenido estático y variable. Este html respeta la semántica y la jerarquía de encabezados y permite escalabilidad de contenido a través de placeholders que puedan cargar un número variable de items iguales en estructura (ejemplo de un slider con un número a decidir de viñetas). El número de items que se carguen se manejará desde el sniper del controlador PHP.

- Un sniper de controlador que carga el controlador PHP específico del recurso. Este sniper se encarga de llamar a la función "controller" enviando varios parámetros: 
    - El nombre del controlador para poder cargar el fichero del controlador pertinente.
    - Un valor numérico que permita distingirse a modo de versión de otros sniper del mismo recurso en la misma vista por llevar contenido diferente. Si se usan dos sniper de un mismo recurso y comparten versión, tendrán el mismo contenido.
    - Opcional un array asociativo que permita asignar a los placeholders indicados en el mismo otros valores. Esto sirve por si se guarda el valor renderizado de un recurso en una variable, y esta se asigna como valor a un placeholder de otro recurso (ver ejemplos en _templates.php)

- Un controlador que sustituye los placeholders del template html por variables objeto y lo renderiza. Este controlador es el que tiene la lógica escalable y el que sustituye los placeholders por contenido y/o variables objeto. Puede recibir como parámetro valores que se asignarán a los placeholders indicados. Algunos de estos controladores generan de forma dinámica recursos de estructura igual, que se diferencian por un valor incremental ($letter), asignando variables objeto de clave diferente. Al final el controlador devuelve la renderización del template con las sustituciones.

- Un recurso .scss donde irán los estilos particulares de dicho recurso. Este archivo cargará con @use elementos de configuración que traerán las variables del proyecto.
- Un recurso opcional .js, que de igual forma tendrá la lógica dentro de una función init y que cargará los recursos que requiera.

Si un recurso, por ejemplo el artículo 5, se incluye dentro de la vista "inicio", debera existir dentro del archivo inicio.scss el @use del recurso del artículo 5. Lo mismo si lleva requiere js, su recurso será incluido en inicio.js.


En etapa de desarrollo, vite recarga en caliente tanto php como js y scss. Según el php se modifica, vite ejecuta de forma automátic la función de añadir al json las claves valor del controlador que se haya añadido en la vista. Lo mismo si se quita, borrándo dichas claves siempre que no sea un recurso global. Lo que no hace de forma automática es añadir el @use del recurso scss al scss principal de la vista.

## Guía para agentes

Cuando el usuario solicite crear un nuevo recurso o mejorar uno existente, sigue estos pasos:

1. **Template HTML**
   - Ubícalo en `App/templates/` con el prefijo `_` y placeholders para todo el contenido dinámico.
   - Mantén la semántica y permite un número variable de items. Los placeholders repetibles se ampliarán según el parámetro `items`.

2. **Sniper / vista**
   - En las vistas utiliza `controller('nombre', $version, $placeholders, $items)` para invocar al recurso.
   - `$items` indica cuántos elementos debe generar el controlador.

3. **Controlador PHP**
   - Reside en `App/controllers/` y recibe los parámetros del sniper.
   - Genera las claves de idioma combinando `$pad` y `$letter` para cada item solicitado.
   - Sustituye los placeholders del template y devuelve el HTML renderizado.

4. **Estilos y JS**
   - Crea `src/scss/resources/_recurso.scss` y, si procede, `src/js/resources/recurso.js`.
   - Importa estos archivos en los scss/js principales de la vista mediante `@use` o `import`.

5. **Actualización de idiomas**
   - Ejecuta `php tools/update-languages.php <vista>` para añadir las nuevas claves al JSON correspondiente.

6. **Comprobaciones**
   - Ejecuta `php -l` en cada archivo PHP modificado.
   - Asegúrate de que la cantidad de items generados coincide con `$items` y que cada clave de idioma es única.

7. **Valores de referencia en `templates`**
   - El número de `items` definido en `App/views/_templates.php` actúa como cantidad por defecto para el controlador. Al refactorizar un recurso existente, conserva en `App/config/languages/templates/*.json` valores «dummy» para ese número de items. Estas entradas sirven como referencia cuando el recurso se incluye en otras vistas con un mayor número de elementos.
   - Si cambias los nombres de las claves al refactorizar, actualiza esas claves en los JSON de `templates` pero **no elimines sus valores**. El script `update-languages.php` borra cualquier clave sin valor y, al reutilizar el recurso en otras vistas, las claves aparecerán vacías.

8. **Índice de instancia en las claves**
   - Las claves de los JSON deben incluir el índice de instancia (`00`, `01`, etc.) seguido de la letra del item, p. ej. `recurso_00_a_img`. Si el índice se omite, `update-languages.php` interpreta que la clave no se usa y la eliminará al modificar `items` o al reutilizar el recurso en otras vistas. Asegúrate de que el controlador genere nombres con `$pad` y que los JSON de `templates` conserven esas claves de referencia.

9. **Prefijo de las claves de idioma**
   - El prefijo de cada clave debe coincidir exactamente con el nombre del controlador (por ejemplo, `sectTabs01_`). Si se emplean abreviaturas distintas, `update-languages.php` no podrá reutilizar los valores de referencia y eliminará las entradas al variar `items`.

10. **JS para items variables**
    - La lógica en los archivos JS debe basarse en los índices de los elementos del DOM y no en atributos `data-*` derivados de claves de idioma. Así se evita que al cambiar el número de items aparezcan animaciones o comportamientos erróneos.

### Nota sobre controladores y comentarios de rangos

- Todos los controladores de contenido deben iniciar con el bloque de comentarios que documenta los rangos mínimo y máximo de cada pieza de copy.
- Los valores dummy presentes en los JSON de `templates` contienen información particular acordada con el cliente. No inventes ni modifiques esos textos salvo que el encargo lo solicite expresamente.
- En nuevas tareas donde se creen controladores adicionales, limita los cambios al docblock de rangos y a la estructura necesaria; cualquier redacción o ajuste de contenido debe validarse con el usuario antes de aplicarse.

## Gestión de jerarquía de encabezados

- Cuando el placeholder `{header-primary}` se sustituya por un recurso cuyo encabezado principal use un nivel diferente al previsto originalmente, el controlador responsable debe recalcular automáticamente los niveles de los encabezados secundarios asociados. Cada encabezado descendiente debe aumentar su nivel relativo (`hN → hN+1`) respetando el límite máximo de `<h6>`.
- Implementa esta lógica mediante un helper reutilizable para evitar cálculos dispersos. Un ejemplo sencillo sería:

  ```php
  function buildHeadingTag(int $baseLevel, int $increment = 0): string {
      $level = min(6, max(1, $baseLevel + $increment));
      return 'h' . $level;
  }
  ```

  Con este helper un controlador puede generar tanto el encabezado principal como los secundarios, por ejemplo `buildHeadingTag($baseLevel, 1)` para el subtítulo.
- Si el recurso inyectado no permite inferir su nivel de encabezado (por ejemplo, porque el markup proviene de un editor externo), habilita un parámetro opcional en el `controller()` que permita fijar explícitamente el nivel base. Una llamada ilustrativa sería `controller('hero', $version, ['base_heading_level' => 3])`, que el controlador utilizaría como `$baseLevel` al invocar `buildHeadingTag`.

## Nota sobre traducciones

- Comprueba siempre que las claves `data-lang` creadas por los controladores mantengan su estructura de objeto en los JSON (por ejemplo `text`, `alt`, `title`, etc.). El script `update-languages.php` completará las propiedades vacías utilizando los templates si detecta arrays vacíos, pero asegúrate de que cada texto o atributo traducible tenga su variable objeto y el `data-lang` correspondiente para evitar que se creen entradas planas.
