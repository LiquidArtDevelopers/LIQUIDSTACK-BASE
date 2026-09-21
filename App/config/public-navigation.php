<?php

declare(strict_types=1);

/**
 * Navegación pública propia del proyecto.
 *
 * Los módulos pueden aportar rutas, pero nunca reescriben el menú de un
 * consumidor. Commerce solo se anuncia cuando su superficie pública está
 * habilitada y dispone de una ruta exacta para el idioma activo.
 *
 * @return Closure(string, ?array): list<array{link:string,text:string,href?:string}>
 */
return static function (
    string $locale,
    ?array $commerceConfig = null
): array {
    $links = [[
        'link' => 'navMegamenu01_00_blog',
        'text' => 'navMegamenu01_00_blogText',
    ]];

    if ($commerceConfig === null) {
        $configPath = __DIR__ . '/modules/commerce.php';
        if (!is_file($configPath) || is_link($configPath)) {
            return $links;
        }

        try {
            $loadedConfig = require $configPath;
        } catch (Throwable) {
            return $links;
        }
        $commerceConfig = is_array($loadedConfig) ? $loadedConfig : [];
    }

    $path = $commerceConfig['public_paths'][$locale] ?? null;
    if (
        ($commerceConfig['public']['enabled'] ?? false) !== true
        || !is_string($path)
        || preg_match(
            '#\A/[a-z0-9]+(?:-[a-z0-9]+)*(?:/[a-z0-9]+(?:-[a-z0-9]+)*)*\z#D',
            $path
        ) !== 1
    ) {
        return $links;
    }

    $links[] = [
        'link' => 'navMegamenu01_00_commerce',
        'text' => 'navMegamenu01_00_commerceText',
        'href' => $path,
    ];

    return $links;
};
