<?php

declare(strict_types=1);

/*
 * Configuración project-owned y no secreta del panel.
 * Las credenciales, correos bootstrap y la clave privada viven en .env.
 */
return [
    'path' => '/admin',
    'database' => [
        'connection' => 'liquidstack',
        'table_prefix' => 'ls_webadmin_',
    ],
];
