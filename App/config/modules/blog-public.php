<?php

declare(strict_types=1);

/*
 * Shared security sources for BASE public Blog shells. The allowlist covers
 * the optional CookieLad loader already present in the project-owned head.
 */
return [
    'security_sources' => [
        'script' => ['https://webda.eus'],
        'style' => ['https://webda.eus'],
        'image' => ['https://webda.eus'],
        'connect' => ['https://webda.eus'],
    ],
];
