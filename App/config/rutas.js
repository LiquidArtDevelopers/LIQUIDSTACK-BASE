// Poner las rutas amigables completas como clave de segundo nivel y en cada idioma.
// Este objeto de objetos sirve para buscar el index de la ruta e idioma actual, y buscar la ruta homóloga en el nuevo idioma seleccionado. Sólo se usa la clave, el valor se pone de momento sólo donde esté el contenido.
// El valor tras la clave (que es una ruta), debe ser el nombre de la carpeta de languages, ya que desde js cogerá de ahí los json de idiomas.


export default {
    'es':{
        '/es/templates': 'templates',
        '/es/showroom': 'showroom',
        '/es/descargar?file={file}': 'downloadFile',

        '/' : 'login',
        '/es/area-socio' : 'socio',
        '/es/area-socio/documentos-club' : 'documentos',
        '/es/area-socio/comunicados-socios' : 'comunicados',
        '/es/recordar-contraseña' : 'remember-password',
        '/es/restablecer-contraseña' : 'reset-password'
    },
    'eu':{
        '/eu/templates': 'templates',
        '/eu/showroom': 'showroom',
        '/eu/descargar?file={file}': 'downloadFile',

        '/eu' : 'login',
        '/eu/bazkide-gunea' : 'socio',
        '/eu/bazkide-gunea/klubeko-dokumentuak' : 'documentos',
        '/eu/bazkide-gunea/oharrak-bazkideentzat' : 'comunicados',
        '/eu/gogoratu-pasahitza' : 'remember-password',
        '/eu/berrezarpen-pasahitza' : 'reset-password'
    },
}
