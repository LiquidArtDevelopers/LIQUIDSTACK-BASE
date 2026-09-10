import { createUpdateLanguagesPlugin } from "./tools/liquidstack/vite/update-languages-plugin.mjs";
import { defineConfig, loadEnv } from "vite"; // Importa utilidades para definir la configuración y cargar variables de entorno
import { basename, extname } from "path"; // Extrae nombres de archivo y extensiones para manipular rutas
import fg from "fast-glob"; // Busca archivos usando patrones glob eficientes
import fullReload from "vite-plugin-full-reload"; // Recarga el navegador cuando cambian archivos ajenos a Vite

const BASE_ROUTE = "./src/js"; // Define la ruta base donde residen los archivos de entrada JS

const routes = fg.sync("src/js/*.js").map((p) => basename(p, ".js")); // Obtiene el listado de vistas JS y se queda con sus nombres

const inputConfig = routes.reduce( // Construye el objeto de entradas para Rollup a partir de las rutas detectadas
  (cfg, page) => ({ // Acumula la configuración existente y añade la nueva entrada
    ...cfg, // Copia las entradas previas del acumulador
    [page]: `${BASE_ROUTE}/${page}.js`, // Registra la ruta completa del archivo JS de la vista
  }),
  {}, 
);

export default defineConfig(({ mode }) => { // Exporta la configuración principal de Vite en función del modo
  const env = { ...process.env, ...loadEnv(mode, process.cwd(), "LANG_") }; // Combina variables de entorno del sistema y prefijadas con LANG_

  return { // Devuelve el objeto de configuración
    plugins: [ // Define la lista de plugins a cargar
      createUpdateLanguagesPlugin(env), // Inserta el plugin de actualización de idiomas
      fullReload(["public/index.php", "App/**/*.php", "App/config/languages/**/*.json"]), // Fuerza recarga completa cuando cambian PHP o JSON de idiomas
    ],
    publicDir: false, // Desactiva la carpeta pública por defecto de Vite
    envPrefix: ["VITE_", "LANG_"], // Limita las variables de entorno accesibles al cliente a estos prefijos
    build: { // Opciones específicas para el proceso de compilación
      emptyOutDir: false, // Evita que Vite elimine la carpeta de salida antes de compilar
      manifest: true, // Genera el archivo manifest.json en el directorio de salida
      rollupOptions: { // Configuración adicional para Rollup
        input: inputConfig, // Define las entradas de compilación detectadas dinámicamente
        output: { // Ajustes del resultado generado
          entryFileNames: "assets/js/[name]-[hash].js", // Establece el patrón para los archivos de entrada JS
          chunkFileNames: "assets/js/[name]-[hash].js", // Define el patrón para los chunks de JS
          assetFileNames: ({ name }) => { // Determina la ruta final de los assets según su extensión
            const ext = extname(name ?? ""); // Extrae la extensión del asset actual
            if (ext === ".css") { // Trata específicamente los archivos CSS
              return "assets/css/[name]-[hash][extname]"; // Devuelve el patrón de nombre para CSS
            }
            if (/\.(png|jpe?g|svg|gif|webp|avif|ico)$/.test(name ?? "")) { // Detecta archivos de imagen
              return "assets/img/[name]-[hash][extname]"; // Devuelve el patrón de nombre para imágenes
            }
            if (/\.(mp4|webm|ogg)$/.test(name ?? "")) { // Detecta archivos de vídeo
              return "assets/video/[name]-[hash][extname]"; // Devuelve el patrón de nombre para vídeos
            }
            if (/\.(woff2?|ttf|otf|eot)$/.test(name ?? "")) { // Detecta fuentes
              return "assets/fonts/[name]-[hash][extname]"; // Devuelve el patrón de nombre para fuentes
            }
            return "assets/[name]-[hash][extname]"; // Patrón por defecto para otros assets
          },
        },
      },
      outDir: "./public/", // Indica la carpeta donde Vite guardará los archivos compilados
    },
    server: { // Opciones del servidor de desarrollo
      // `npm run lad` inyecta el origen efectivo tras reservar un puerto libre.
      // El fallback solo conserva compatibilidad con `npm run dev` directo.
      origin: env.LIQUIDSTACK_DEV_APP_ORIGIN ?? "http://localhost:1309",
    },
  };
});
