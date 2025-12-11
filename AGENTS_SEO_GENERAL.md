# INTRUCCIONES GENERALES PARA EL SEO DE CUALQUIER PROYECTO

### 1. Preparación y fuentes
- Antes de redactar, revisa `AGENTS_INFO_CUSTOMER.md` para reutilizar únicamente datos confirmados (textos comerciales, valores, partners, coberturas, etc.). No menciones servicios que no aparezcan en ese dossier ni extrapoles alcances nuevos.
- Si faltan direcciones, teléfonos o correos en el dossier, marca el hueco como pendiente y solicita confirmación; no inventes datos ni fechas.
- Añade al dossier cualquier información nueva validada por el cliente antes de usarla en otros documentos.
- Los controladores PHP incluyen comentarios con los rangos mínimos y máximos de palabras/caracteres por recurso. Revísalos antes de proponer nuevos textos y mantenlos como referencia.

### 2. Arquitectura SEO por url e idioma

- Consulta siempre `AGENTS_SEO_CUSTOMER.md` antes de generar o revisar textos orientados a posicionamiento. El documento recoge, por ruta e idioma, los vectores de palabras clave a combinar y detalla las guías de extensión por recurso.
- Al actualizar `AGENTS_SEO_CUSTOMER.md`, documenta para cada URL y cada idioma los 4 vectores de palabras clave (servicio/solución/producto, atributos diferenciadores, finalidad/aplicación/sector y localidad) y explica cualquier matiz necesario para que el generador de contenido respete estas directrices.


#### Límite y combinación de topónimos

- Distingue entre topónimos locales (localidades específicas) y macroterritoriales (provincias/departamentos/regiones amplias). Los primeros definen la URL; los segundos amplían el alcance territorial.
- Limita cada vector de localidad a un máximo de tres topónimos por URL e idioma:
  - Uno de ellos debe ser una provincia o departamento (macroterritorial).
  - Los otros uno o dos pueden ser municipios, comarcas o zonas específicas.
  - No repitas la misma combinación exacta de topónimos entre distintas URLs en el mismo idioma para evitar canibalizaciones.

#### Otras reglas SEO complementarias

- Evalúa si el contenido propuesto satisface por sí solo la intención de búsqueda objetivo antes de darlo por válido.
- Usa en el copy los keywords propuestos en los vectores correspondientes y 3–6 variantes semánticas/entidades relacionadas para evitar keyword stuffing y aumentar la naturalidad del texto. Esta regla se aplica a los vectores de servicio/solución/producto, atributos diferenciadores y finalidad/aplicación/sector.
- No uses porcentajes de densidad. Prioriza el flujo natural, evita keyword stuffing y no repitas una misma palabra más de dos veces seguidas en un párrafo; recurre a sinónimos y variantes semánticas.
- Si se añaden nuevas rutas o se modifican objetivos SEO, actualiza `AGENTS_SEO_CUSTOMER.md` antes de elaborar o ajustar los textos asociados para evitar canibalizaciones.

### 3. Redacción y tono
- Mantén un tono cercano, educativo y profesional que transmita confianza sin infantilizar, reforzando los compromisos del cliente.
- Dirígete de tú a tú al usuario final y a su empresa, personaliza los mensajes y combina lenguaje técnico con explicaciones claras para públicos no especializados.
- Sustenta las afirmaciones con datos, citas o referencias verificables y cita la fuente cuando proceda.
- Objetivo: contenido útil, fiable y creado para personas.
- Destaca sólo en bloques de texto introductorios algunas keywords en negrita, sin abusar No lo uses en títulos.

### 4. Elementos estructurales on-page
- Title único (≤60–65 caracteres) y persuasivo; evita el spam de palabras clave.
- Meta description atractiva orientada a clic sin repetir keywords de manera artificial.
- H1 único por página y coherente con el title. Incluye la propuesta de valor en las primeras 100 palabras junto con el topónimo principal si aplica.
- Añade 1–2 H2/H3 relevantes que organicen el contenido y respondan a búsquedas relacionadas.
- Utiliza párrafos cortos y apóyate en listas, tablas, resúmenes ejecutivos y bloques destacados para mejorar la escaneabilidad.
- Incluye comparativas, pros/contras y ejemplos concretos que ilustren la propuesta.
- Asegura que todo anchor text sea descriptivo y aporte contexto.
- Añade ALT descriptivo a 1–2 imágenes clave cuando proceda, aportando contexto real y variando el vocabulario (no repitas la keyword en todos los ALT).
- Crea recursos visuales o multimedia cuando sea relevante y describe su función dentro del copy.

### 5. Buenas prácticas adicionales
- Comprueba que cada pieza cubre la necesidad del usuario de principio a fin, sin derivar a contenido de poco valor ni generar “doorway pages”.
- Revisa que la semántica y la estructura sean coherentes entre idiomas, respetando las particularidades culturales.
- Documenta cualquier información nueva validada en los repositorios correspondientes para facilitar futuras iteraciones.

### 6. Zonas rojas (evita de forma taxativa)
- Keyword stuffing (repetir palabras clave de forma antinatural en texto, headings, ALT, metas o listados).
- Contenido producido a escala sin valor real, “doorway pages”, texto oculto/cloaking o datos estructurados engañosos.
- Abuso de la reputación del sitio o reutilización de dominios caducados con fines manipulativos.
- Cualquier práctica que comprometa la fiabilidad, la utilidad o la experiencia del usuario.
