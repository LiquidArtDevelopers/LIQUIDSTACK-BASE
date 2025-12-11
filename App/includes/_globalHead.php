<!-- Meta config -->
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Variant keywords-->
<title data-lang="title"><?=$title->text?></title>
<meta name="description" data-lang="description" content="<?=$description->content?>">

<!-- Variant Metas -->
<?php
    $rootUrl      = rtrim($_ENV['RAIZ'] ?? '', '/');
    $metaUrl      = $rootUrl . $url;
    $metaImageUrl = $rootUrl . '/assets/img/dummy/dummy_1200.avif';

    $normalizeBool = static function ($value): bool {
        if (is_bool($value)) {
            return $value;
        }

        $filtered = filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
        return $filtered ?? false;
    };

    $devModeEnv = $_ENV['DEV_MODE'] ?? getenv('DEV_MODE') ?? false;
    $devMode    = $normalizeBool($devModeEnv);

    $appConfig = [
        'devMode'           => $devMode,
        'lang'              => $lang ?? null,
        'defaultLang'       => $_ENV['LANG_DEFAULT'] ?? null,
        'route'             => $content ?? ($resources ?? null),
        'multiLang'         => $normalizeBool($_ENV['MULTILANG'] ?? false),
        'simplifiedDefault' => $normalizeBool($_ENV['ES_SIMPLIFICADO'] ?? false),
    ];
?>
<link rel="canonical" href="<?= $metaUrl ?>">
<!-- Alternative canonical -->
<?= hreflangAlternates($lang, $url) ?>

<meta name="robots" data-lang="robots" content="<?=$robots->content?>">

<!-- Other Global Metas -->
<meta name="mobile-web-app-capable" content="yes">
<meta name="referrer" content="origin">

<!-- Social Meta -->
<meta property="og:type" content="website">
<meta property="og:title" content="<?= $title->text ?>">
<meta property="og:description" content="<?= $description->content ?>">
<meta property="og:url" content="<?= $metaUrl ?>">
<meta property="og:image" content="<?= $metaImageUrl ?>">

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="<?= $title->text ?>">
<meta name="twitter:description" content="<?= $description->content ?>">
<meta name="twitter:image" content="<?= $metaImageUrl ?>">
<meta name="twitter:url" content="<?= $metaUrl ?>">

<script>
window.__APP_CONFIG__ = <?= json_encode($appConfig, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE); ?>;
</script>

<!-- Global Icons -->
<link rel="icon" href="<?= $_ENV['RAIZ'] ?>/favicon.ico" type="image/x-icon">
<link rel="icon" href="<?= $_ENV['RAIZ'] ?>/assets/img/logos/isotipo.svg" type="image/svg+xml">
<link rel="mask-icon" href="<?= $_ENV['RAIZ'] ?>/assets/img/logos/isotipo.svg" color="#000000" type="image/svg+xml">
<link rel="icon" href="<?= $_ENV['RAIZ'] ?>/assets/img/logos/isotipo-32x32.png" type="image/png">
<link rel="icon" href="<?= $_ENV['RAIZ'] ?>/assets/img/logos/isotipo-192x192.png" type="image/png">
<link rel="shortcut icon" href="<?= $_ENV['RAIZ'] ?>/assets/img/logos/isotipo-32x32.png" type="image/png">
<link rel="apple-touch-icon-precomposed" href="<?= $_ENV['RAIZ'] ?>/assets/img/logos/isotipo-180x180.png" type="image/png">
<meta name="msapplication-TileImage" content="<?= $_ENV['RAIZ'] ?>/assets/img/logos/isotipo-270x270.png">



<!-- Variant Resources -->

<?php if ($devMode): ?>
    <script type="module" src="http://localhost:5173/@vite/client"></script>
    <script defer src="http://localhost:5173/src/js/<?= $resources ?>.js" type="module"></script>
<?php else: ?>
  <!-- Preload fonts to improve rendering (especially Safari) -->
  <link rel="preload" href="<?= $_ENV['RAIZ'] ?>/assets/fonts/Anton-Regular.ttf" as="font" type="font/ttf" crossorigin>
  <link rel="preload" href="<?= $_ENV['RAIZ'] ?>/assets/fonts/Poppins-Medium.ttf" as="font" type="font/ttf" crossorigin>
  <link rel="stylesheet" href="<?= $css?>">
  <script defer type="module" src="<?= $js?>"></script>
<?php endif; ?>

<!-- V2 COOKIE LAD -->
<script defer src="https://webda.eus/apis/cookielad/loader.js?key=1QOLs17ExEwvHTLFfWJmJPwVa0ytQPfA&color=24658e"></script>

<!-- schema dinámico webpage y accesibility 2.0 -->
<?= schemaWebPageAccessibility( $lang, $url, $title->text, $description->content ); ?>

<!-- schema estático con datos del cliente -->
<?php
    $businessUrl  = $rootUrl !== '' ? $rootUrl : 'https://bazkide.atleticosansebastian.com';
    $businessLogo = $businessUrl . '/assets/img/logos/isotipo-192x192.png';

    $schemaLocalBusiness = [
        '@context' => 'https://schema.org',
        '@type'    => 'SportsClub',
        '@id'      => $businessUrl . '/#organization',
        'name'     => 'Club Atlético San Sebastián',
        'url'      => $businessUrl,
        'image'    => $businessLogo,
        'logo'     => $businessLogo,
        'telephone'=> '+34 943 21 53 54',
        'email'    => $_ENV['VITE_BUSINESS_CONTACT'] ?? 'comunicacion@atletico-ss.org',
        'inLanguage' => $lang ?? 'es',
        'address'  => [
            '@type'           => 'PostalAddress',
            'streetAddress'   => 'Hegaztien Pasealekua, 5',
            'addressLocality' => 'Donostia / San Sebastián',
            'postalCode'      => '20009',
            'addressRegion'   => 'Gipuzkoa',
            'addressCountry'  => 'ES',
        ],
        'geo' => [
            '@type'    => 'GeoCoordinates',
            'latitude' => 43.3023036,
            'longitude'=> -1.9944562,
        ],
        'accessibilityAPI'      => 'ARIA',
        'accessibilityControl'  => ['fullKeyboardControl', 'fullMouseControl'],
        'accessibilityFeature'  => ['highContrast', 'longDescription', 'ARIA'],
        'accessibilityHazard'   => ['noFlashingHazard', 'noMotionSimulationHazard'],
        'accessibilitySummary'  => 'Contenido accesible con contraste adecuado, navegación por teclado y marcado ARIA.',
        'hasPart' => [
            [
                '@type'      => 'WebPage',
                '@id'        => $businessUrl . '/',
                'inLanguage' => 'es',
            ],
            [
                '@type'      => 'WebPage',
                '@id'        => $businessUrl . '/eu',
                'inLanguage' => 'eu',
            ],
        ],
        'sameAs' => array_values(array_filter([
            $_ENV['VITE_BUSINESS_WEB'] ?? null,
        ])),
    ];
?>
<script type="application/ld+json">
<?= json_encode($schemaLocalBusiness, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT); ?>
</script>
