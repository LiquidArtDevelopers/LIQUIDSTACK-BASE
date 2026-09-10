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
            'content'   => 'templates',
            'view'      => '../App/views/_showroom.php'
        ],
        '/es/descargar?file={file}' => [
            'view' => '../App/app/downloadFile.php',
            'session' => false,
            'sitemap' => false
        ],
        // Páginas comerciales
        '/' => [
            'resources' => 'home',
            'content' => 'home',
            'view' => '../App/views/home.php'
        ],
        '/es/blog' => [
            'resources' => 'blog',
            'content' => 'blog',
            'view' => '../App/views/blog.php',
            'session' => false
        ],
        '/es/blog/page/{page}' => [
            'resources' => 'blog',
            'content' => 'blog',
            'view' => '../App/views/blog.php',
            'session' => false,
            'sitemap' => false
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
        // Par simétrico del alias EU para preservar el mapeo entre idiomas.
        '/es/deskargatu?file={file}' => [
            'view' => '../App/app/downloadFile.php',
            'session' => false,
            'sitemap' => false
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
            'content'   => 'templates',
            'view'      => '../App/views/_showroom.php'
        ],
        '/eu/deskargatu?file={file}' => [
            'view' => '../App/app/downloadFile.php',
            'session' => false,
            'sitemap' => false
        ],
        // Páginas comerciales
        '/eu' => [
            'resources' => 'home',
            'content' => 'home',
            'view' => '../App/views/home.php'
        ],
        '/eu/blog' => [
            'resources' => 'blog',
            'content' => 'blog',
            'view' => '../App/views/blog.php',
            'session' => false
        ],
        '/eu/blog/page/{page}' => [
            'resources' => 'blog',
            'content' => 'blog',
            'view' => '../App/views/blog.php',
            'session' => false,
            'sitemap' => false
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
        // Alias simétrico del endpoint canónico generado por sectTabs01.
        '/eu/descargar?file={file}' => [
            'view' => '../App/app/downloadFile.php',
            'session' => false,
            'sitemap' => false
        ]
    ],

];
