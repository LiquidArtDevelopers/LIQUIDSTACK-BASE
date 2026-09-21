<?php

declare(strict_types=1);

return [
    'public_paths' => [
        'es' => '/es/blog',
        'eu' => '/eu/blog',
    ],
    'public_index' => [
        'pagination_paths' => [
            'es' => '/es/blog/page/{page}',
            'eu' => '/eu/blog/page/{page}',
        ],
    ],
    'sitemap_path' => '/blog-sitemap.xml',
    'public_article_view' => 'App/views/blog-article.php',
    'database' => [
        'connection' => 'liquidstack',
        'table_prefix' => 'ls_blog_',
    ],
];
