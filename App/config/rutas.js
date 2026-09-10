// Poner las rutas amigables completas como clave de segundo nivel y en cada idioma.
// Este objeto de objetos sirve para buscar el index de la ruta e idioma actual, y buscar la ruta homóloga en el nuevo idioma seleccionado. Sólo se usa la clave, el valor se pone de momento sólo donde esté el contenido.
// El valor tras la clave (que es una ruta), debe ser el nombre de la carpeta de languages, ya que desde js cogerá de ahí los json de idiomas.


export default {
    'es':{
        '/es/templates': 'templates',
        '/es/showroom': 'templates',

        '/' : 'home',
        '/es/blog' : 'blog',
        '/es/blog/page/{page}' : 'blog',
        '/es/servicios' : 'servicios',
        '/es/servicios/servicio' : 'servicio',
        '/es/contacto' : 'contacto'
    },
    'eu':{
        '/eu/templates': 'templates',
        '/eu/showroom': 'templates',

        '/eu' : 'home',
        '/eu/blog' : 'blog',
        '/eu/blog/page/{page}' : 'blog',
        '/eu/serbitzuak' : 'servicios',
        '/eu/serbitzuak/serbitzua' : 'servicio',
        '/eu/kontaktua' : 'contacto'
    },
}
