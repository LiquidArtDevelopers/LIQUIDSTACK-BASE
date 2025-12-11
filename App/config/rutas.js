// Poner las rutas amigables completas como clave de segundo nivel y en cada idioma.
// Este objeto de objetos sirve para buscar el index de la ruta e idioma actual, y buscar la ruta homóloga en el nuevo idioma seleccionado. Sólo se usa la clave, el valor se pone de momento sólo donde esté el contenido.
// El valor tras la clave (que es una ruta), debe ser el nombre de la carpeta de languages, ya que desde js cogerá de ahí los json de idiomas.


export default {
    'es':{
        '/es/templates': 'templates',
        '/es/showroom': 'showroom',
        '/es/descargar?file={file}': 'downloadFile',

        '/' : 'home',
        '/es/servicios' : 'servicios',
        '/es/servicios/servicio' : 'servicio',
        '/es/contacto' : 'contacto',
        '/es/acceso' : 'login',
        '/es/area-socio' : 'socio',
        '/es/area-socio/documentos-club' : 'documentos',
        '/es/area-socio/comunicados-socios' : 'comunicados',
        '/es/logout' : 'logout',
        '/es/recordar-contraseña' : 'remember-password',
        '/es/restablecer-contraseña?t={token}' : 'reset-password'
    },
    'eu':{
        '/eu/templates': 'templates',
        '/eu/showroom': 'showroom',
        '/eu/deskargatu?file={file}': 'downloadFile',

        '/eu' : 'home',
        '/es/serbitzuak' : 'servicios',
        '/es/serbitzuak/serbitzua' : 'servicio',
        '/es/kontaktua' : 'contacto',
        '/eu/sarrera' : 'login',
        '/eu/bazkide-gunea' : 'socio',
        '/eu/bazkide-gunea/klubeko-dokumentuak' : 'documentos',
        '/eu/bazkide-gunea/oharrak-bazkideentzat' : 'comunicados',
        '/eu/logout' : 'logout',
        '/eu/gogoratu-pasahitza' : 'remember-password',
        '/eu/berrezarpen-pasahitza?t={token}' : 'reset-password'
    },
}
