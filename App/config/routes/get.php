<?php

return [
    /* ====================
       Rutas en CASTELLANO
       ==================== */
    'es' => [
        /* --- Páginas sistema --- */
        '/es/templates' => [
            'resources' => 'templates',
            'content'   => 'templates',
            'view'      => '../App/views/_templates.php'
        ],
        '/es/showroom' => [
            'resources' => 'templates',
            'content'   => 'showroom',
            'view'      => '../App/views/_showroom.php'
        ],
        "/es/descargar?file={file}" => [
            'view' => '../App/app/downloadFile.php'
        ],

        // Páginas comerciales
        '/' => [
            'resources' => 'home',
            'content' => 'home',
            'view' => '../App/views/home.php'
        ],
        '/es/servicios' => [
            'resources' => 'servicios',
            'content' => 'servicios',
            'view' => '../App/views/servicios.php'
        ],
        '/es/servicios/servicio' => [
            'resources' => 'servicio',
            'content' => 'servicio',
            'view' => '../App/views/servicio.php'
        ],
        '/es/contacto' => [
            'resources' => 'contacto',
            'content' => 'contacto',
            'view' => '../App/views/contacto.php'
        ],
        

        // Páginas con acceso privado
        '/es/acceso' => [
            'resources' => 'login',
            'content' => 'login',
            'view' => '../App/views/login.php'
        ],
        '/es/area-socio' => [
            'resources' => 'socio',
            'content' => 'socio',
            'view' => '../App/views/socio.php'
        ],
        '/es/area-socio/documentos-club' => [
            'resources' => 'documentos',
            'content' => 'documentos',
            'view' => '../App/views/documentos.php'
        ],
        '/es/area-socio/comunicados-socios' => [
            'resources' => 'comunicados',
            'content' => 'comunicados',
            'view' => '../App/views/comunicados.php'
        ],

        "/es/logout" => [
            "view" => "../App/app/logout.php"
        ],
        '/es/recordar-contraseña' => [
            'resources' => 'remember-password',
            'content' => 'remember-password',
            'view' => '../App/views/remember-password.php'
        ],
        '/es/restablecer-contraseña?t={token}' => [
            'resources' => 'reset-password',
            'content' => 'reset-password',
            'view' => '../App/views/reset-password.php'
        ]

        
    ],

    /* ====================
    Rutas en EUSKERA
    ==================== */
    'eu' => [
        /* --- Páginas sistema --- */
        '/eu/templates' => [
            'resources' => 'templates',
            'content'   => 'templates',
            'view'      => '../App/views/_templates.php'
        ],
        '/eu/showroom' => [
            'resources' => 'templates',
            'content'   => 'showroom',
            'view'      => '../App/views/_showroom.php'
        ],
        "/eu/deskargatu?file={file}" => [
            'view' => '../App/app/downloadFile.php'
        ],

        // Páginas comerciales
        '/eu' => [
            'resources' => 'home',
            'content' => 'home',
            'view' => '../App/views/home.php'
        ],
        '/eu/serbitzuak' => [
            'resources' => 'servicios',
            'content' => 'servicios',
            'view' => '../App/views/servicios.php'
        ],
        '/eu/serbitzuak/serbitzua' => [
            'resources' => 'servicio',
            'content' => 'servicio',
            'view' => '../App/views/servicio.php'
        ],
        '/eu/kontaktua' => [
            'resources' => 'contacto',
            'content' => 'contacto',
            'view' => '../App/views/contacto.php'
        ],

        // Páginas con acceso privado
        '/eu/sarrera' => [
            'resources' => 'login',
            'content' => 'login',
            'view' => '../App/views/login.php'
        ],
        '/eu/bazkide-gunea' => [
            'resources' => 'socio',
            'content' => 'socio',
            'view' => '../App/views/socio.php'
        ],
        '/eu/bazkide-gunea/klubeko-dokumentuak' => [
            'resources' => 'documentos',
            'content' => 'documentos',
            'view' => '../App/views/documentos.php'
        ],
        '/eu/bazkide-gunea/oharrak-bazkideentzat' => [
            'resources' => 'comunicados',
            'content' => 'comunicados',
            'view' => '../App/views/comunicados.php'
        ],

        "/eu/logout" => [
            "view" => "../App/app/logout.php"
        ],
        '/eu/gogoratu-pasahitza' => [
            'resources' => 'remember-password',
            'content' => 'remember-password',
            'view' => '../App/views/remember-password.php'
        ],
        '/eu/berrezarpen-pasahitza?t={token}' => [
            'resources' => 'reset-password',
            'content' => 'reset-password',
            'view' => '../App/views/reset-password.php'
        ]
        
    ],

];