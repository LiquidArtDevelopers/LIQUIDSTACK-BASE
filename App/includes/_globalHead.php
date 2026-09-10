<!-- Meta config -->
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<?php
$escapeMeta = static fn (mixed $value): string => htmlspecialchars(
    (string) $value,
    ENT_QUOTES | ENT_SUBSTITUTE,
    'UTF-8'
);

$headCspNonce = isset($cspNonce)
    && is_string($cspNonce)
    && preg_match('/\A[A-Za-z0-9+\/_=-]+\z/D', $cspNonce) === 1
        ? $cspNonce
        : null;
$headScriptNonceAttribute = $headCspNonce === null
    ? ''
    : ' nonce="' . $escapeMeta($headCspNonce) . '"';

$pageMeta = isset($pageMeta) && is_array($pageMeta)
    ? $pageMeta
    : [];
$legacyTitle = isset($title) && is_object($title)
    ? (string) ($title->text ?? '')
    : '';
$legacyDescription = isset($description) && is_object($description)
    ? (string) ($description->content ?? '')
    : '';
$pageTitle = (string) ($pageMeta['title'] ?? $legacyTitle);
$pageHeadline = (string) ($pageMeta['headline'] ?? $pageTitle);
$pageDescription = (string) (
    $pageMeta['description'] ?? $legacyDescription
);

$rootUrl = rtrim((string) ($_ENV['RAIZ'] ?? ''), '/');
$currentPath = isset($url) && is_string($url) && $url !== '' ? $url : '/';
$defaultMetaUrl = $rootUrl . $currentPath;
$metaUrl = is_string($pageMeta['canonical'] ?? null)
    && trim((string) $pageMeta['canonical']) !== ''
        ? (string) $pageMeta['canonical']
        : $defaultMetaUrl;
$hasMetaImageOverride = array_key_exists('image', $pageMeta);
$metaImageUrl = $hasMetaImageOverride
    ? (is_string($pageMeta['image'])
        && trim($pageMeta['image']) !== ''
            ? $pageMeta['image']
            : null)
    : $rootUrl . '/assets/img/dummy/dummy_1200.avif';
$metaType = ($pageMeta['type'] ?? null) === 'article'
    ? 'article'
    : 'website';
$metaAlternates = is_array($pageMeta['alternates'] ?? null)
    ? $pageMeta['alternates']
    : null;
$metaXDefault = is_string($pageMeta['x_default'] ?? null)
    ? $pageMeta['x_default']
    : null;
$metaPublishedAt = is_string($pageMeta['published_at'] ?? null)
    ? $pageMeta['published_at']
    : null;
$metaUpdatedAt = is_string($pageMeta['updated_at'] ?? null)
    ? $pageMeta['updated_at']
    : null;

$normalizeBool = static function (mixed $value): bool {
    if (is_bool($value)) {
        return $value;
    }

    $filtered = filter_var(
        $value,
        FILTER_VALIDATE_BOOLEAN,
        FILTER_NULL_ON_FAILURE
    );

    return $filtered ?? false;
};

$devModeEnv = $_ENV['DEV_MODE'] ?? getenv('DEV_MODE') ?? false;
$devMode = $normalizeBool($devModeEnv);
$pageLang = isset($lang) && is_string($lang) ? $lang : '';
$appConfig = [
    'devMode' => $devMode,
    'lang' => $pageLang !== '' ? $pageLang : null,
    'defaultLang' => $_ENV['LANG_DEFAULT'] ?? null,
    'route' => $content ?? ($resources ?? null),
    'multiLang' => $normalizeBool($_ENV['MULTILANG'] ?? false),
    'simplifiedDefault' => $normalizeBool(
        $_ENV['ES_SIMPLIFICADO'] ?? false
    ),
];
$jsonScriptFlags = JSON_UNESCAPED_SLASHES
    | JSON_UNESCAPED_UNICODE
    | JSON_HEX_TAG
    | JSON_HEX_AMP
    | JSON_HEX_APOS
    | JSON_HEX_QUOT
    | JSON_THROW_ON_ERROR;
?>

<!-- Variant metadata -->
<title data-lang="title"><?= $escapeMeta($pageTitle) ?></title>
<meta name="description" data-lang="description" content="<?= $escapeMeta($pageDescription) ?>">
<link rel="canonical" href="<?= $escapeMeta($metaUrl) ?>">

<?php if ($metaAlternates === null): ?>
<?= hreflangAlternates($pageLang, $currentPath) ?>
<?php else: ?>
    <?php foreach ($metaAlternates as $alternateLocale => $alternateUrl): ?>
        <?php if (is_string($alternateLocale) && is_string($alternateUrl)): ?>
<link rel="alternate" hreflang="<?= $escapeMeta($alternateLocale) ?>" href="<?= $escapeMeta($alternateUrl) ?>">
        <?php endif; ?>
    <?php endforeach; ?>
    <?php if ($metaXDefault !== null): ?>
<link rel="alternate" hreflang="x-default" href="<?= $escapeMeta($metaXDefault) ?>">
    <?php endif; ?>
<?php endif; ?>

<meta name="robots" data-lang="robots" content="<?= $escapeMeta(
    isset($robots) && is_object($robots) ? ($robots->content ?? '') : ''
) ?>">
<meta name="mobile-web-app-capable" content="yes">
<meta name="referrer" content="origin">

<!-- Social metadata -->
<meta property="og:type" content="<?= $escapeMeta($metaType) ?>">
<meta property="og:title" content="<?= $escapeMeta($pageTitle) ?>">
<meta property="og:description" content="<?= $escapeMeta($pageDescription) ?>">
<meta property="og:url" content="<?= $escapeMeta($metaUrl) ?>">
<?php if ($metaImageUrl !== null): ?>
<meta property="og:image" content="<?= $escapeMeta($metaImageUrl) ?>">
<?php endif; ?>
<?php if ($metaType === 'article' && $metaPublishedAt !== null): ?>
<meta property="article:published_time" content="<?= $escapeMeta($metaPublishedAt) ?>">
<?php endif; ?>
<?php if ($metaType === 'article' && $metaUpdatedAt !== null): ?>
<meta property="article:modified_time" content="<?= $escapeMeta($metaUpdatedAt) ?>">
<?php endif; ?>

<meta name="twitter:card" content="<?= $metaImageUrl === null ? 'summary' : 'summary_large_image' ?>">
<meta name="twitter:title" content="<?= $escapeMeta($pageTitle) ?>">
<meta name="twitter:description" content="<?= $escapeMeta($pageDescription) ?>">
<?php if ($metaImageUrl !== null): ?>
<meta name="twitter:image" content="<?= $escapeMeta($metaImageUrl) ?>">
<?php endif; ?>
<meta name="twitter:url" content="<?= $escapeMeta($metaUrl) ?>">

<script<?= $headScriptNonceAttribute ?>>
window.__APP_CONFIG__ = <?= json_encode($appConfig, $jsonScriptFlags) ?>;
</script>

<!-- Global icons -->
<link rel="icon" href="<?= $escapeMeta($rootUrl . '/favicon.ico') ?>" type="image/x-icon">
<link rel="icon" href="<?= $escapeMeta($rootUrl . '/assets/img/logos/isotipo-32x32.png') ?>" type="image/png">
<link rel="icon" href="<?= $escapeMeta($rootUrl . '/assets/img/logos/isotipo-192x192.png') ?>" type="image/png">
<link rel="shortcut icon" href="<?= $escapeMeta($rootUrl . '/assets/img/logos/isotipo-32x32.png') ?>" type="image/png">
<link rel="apple-touch-icon-precomposed" href="<?= $escapeMeta($rootUrl . '/assets/img/logos/isotipo-180x180.png') ?>" type="image/png">
<meta name="msapplication-TileImage" content="<?= $escapeMeta($rootUrl . '/assets/img/logos/isotipo-270x270.png') ?>">

<!-- Variant resources -->
<?php if ($devMode): ?>
<script<?= $headScriptNonceAttribute ?> type="module" src="<?= $escapeMeta(liquidstack_dev_vite_origin()) ?>/@vite/client"></script>
<script<?= $headScriptNonceAttribute ?> defer type="module" src="<?= $escapeMeta(liquidstack_dev_vite_origin()) ?>/src/js/<?= $escapeMeta($resources ?? '') ?>.js"></script>
<?php else: ?>
<link rel="preload" href="<?= $escapeMeta($rootUrl . '/assets/fonts/Anton-Regular.ttf') ?>" as="font" type="font/ttf" crossorigin>
<link rel="preload" href="<?= $escapeMeta($rootUrl . '/assets/fonts/Poppins-Medium.ttf') ?>" as="font" type="font/ttf" crossorigin>
    <?php $stylesheets = is_array($css ?? null) ? $css : [$css ?? '']; ?>
    <?php foreach ($stylesheets as $stylesheet): ?>
        <?php if (is_string($stylesheet) && $stylesheet !== ''): ?>
<link rel="stylesheet" href="<?= $escapeMeta($stylesheet) ?>">
        <?php endif; ?>
    <?php endforeach; ?>
    <?php if (isset($js) && is_string($js) && $js !== ''): ?>
<script<?= $headScriptNonceAttribute ?> defer type="module" src="<?= $escapeMeta($js) ?>"></script>
    <?php endif; ?>
<?php endif; ?>

<!-- CookieLad is optional and only starts with a project-owned key. -->
<?php
$cookieLadKey = trim((string) ($_ENV['COOKIE_LAD_KEY'] ?? ''));
$cookieLadColorCandidate = trim((string) (
    $_ENV['COOKIE_LAD_COLOR'] ?? '000000'
));
$cookieLadColor = preg_match(
    '/\A[0-9a-f]{6}\z/i',
    $cookieLadColorCandidate
) === 1
    ? strtolower($cookieLadColorCandidate)
    : '000000';
?>
<?php if ($cookieLadKey !== ''): ?>
<script<?= $headScriptNonceAttribute ?> defer src="https://webda.eus/apis/cookielad/loader.js?key=<?= rawurlencode($cookieLadKey) ?>&amp;color=<?= rawurlencode($cookieLadColor) ?>"></script>
<?php endif; ?>

<!-- Page schema -->
<?php if ($metaType !== 'article'): ?>
<?= schemaWebPageAccessibility(
    $pageLang,
    $currentPath,
    $pageTitle,
    $pageDescription,
    $headCspNonce
) ?>
<?php else: ?>
<?php
$schemaArticleId = $metaUrl . '#article';
$schemaOrganizationId = $rootUrl . '/#organization';
$schemaWebPage = [
    '@type' => 'WebPage',
    '@id' => $metaUrl . '#webpage',
    'url' => $metaUrl,
    'inLanguage' => $pageLang,
    'name' => $pageTitle,
    'description' => $pageDescription,
    'mainEntity' => ['@id' => $schemaArticleId],
];
$schemaAlternates = [];
foreach ($metaAlternates ?? [] as $alternateLocale => $alternateUrl) {
    if (!is_string($alternateLocale) || !is_string($alternateUrl)) {
        continue;
    }
    $schemaAlternates[] = [
        '@type' => 'WebPage',
        '@id' => $alternateUrl . '#webpage',
        'url' => $alternateUrl,
        'inLanguage' => $alternateLocale,
    ];
}
if ($schemaAlternates !== []) {
    $schemaWebPage['hasPart'] = $schemaAlternates;
}

$schemaBlogPosting = [
    '@type' => 'BlogPosting',
    '@id' => $schemaArticleId,
    'mainEntityOfPage' => ['@id' => $metaUrl . '#webpage'],
    'url' => $metaUrl,
    'inLanguage' => $pageLang,
    'headline' => $pageHeadline,
    'description' => $pageDescription,
    'author' => ['@id' => $schemaOrganizationId],
    'publisher' => ['@id' => $schemaOrganizationId],
];
if ($metaPublishedAt !== null) {
    $schemaBlogPosting['datePublished'] = $metaPublishedAt;
}
if ($metaUpdatedAt !== null) {
    $schemaBlogPosting['dateModified'] = $metaUpdatedAt;
}
if ($metaImageUrl !== null) {
    $schemaBlogPosting['image'] = $metaImageUrl;
    $schemaWebPage['primaryImageOfPage'] = [
        '@type' => 'ImageObject',
        'url' => $metaImageUrl,
    ];
}
$schemaArticleGraph = [
    '@context' => 'https://schema.org',
    '@graph' => [$schemaWebPage, $schemaBlogPosting],
];
?>
<script<?= $headScriptNonceAttribute ?> type="application/ld+json">
<?= json_encode($schemaArticleGraph, $jsonScriptFlags | JSON_PRETTY_PRINT) ?>
</script>
<?php endif; ?>

<!-- Generic organization schema -->
<?php
$businessUrl = $rootUrl !== '' ? $rootUrl : 'https://example.com';
$businessLogo = $businessUrl . '/assets/img/logos/isotipo-192x192.png';
$businessAddress = trim((string) (
    $_ENV['VITE_BUSINESS_ADDRESS']
        ?? $_ENV['VITE_BUSINESS_ADRESS']
        ?? ''
));
$organization = [
    '@context' => 'https://schema.org',
    '@type' => 'Organization',
    '@id' => $businessUrl . '/#organization',
    'name' => (string) ($_ENV['VITE_BUSINESS_NAME'] ?? 'Nombre de empresa'),
    'url' => $businessUrl,
    'image' => $businessLogo,
    'logo' => $businessLogo,
    'inLanguage' => $pageLang,
];
$businessPhone = trim((string) ($_ENV['VITE_BUSINESS_PHONE'] ?? ''));
$businessEmail = trim((string) ($_ENV['VITE_BUSINESS_CONTACT'] ?? ''));
if ($businessPhone !== '') {
    $organization['telephone'] = $businessPhone;
}
if ($businessEmail !== '') {
    $organization['email'] = $businessEmail;
}
$address = array_filter(
    [
        '@type' => 'PostalAddress',
        'streetAddress' => $businessAddress,
        'addressLocality' => trim((string) (
            $_ENV['VITE_BUSINESS_LOCALITY'] ?? ''
        )),
        'postalCode' => trim((string) (
            $_ENV['VITE_BUSINESS_POSTAL_CODE'] ?? ''
        )),
        'addressRegion' => trim((string) (
            $_ENV['VITE_BUSINESS_REGION'] ?? ''
        )),
        'addressCountry' => trim((string) (
            $_ENV['VITE_BUSINESS_COUNTRY'] ?? 'ES'
        )),
    ],
    static fn (mixed $value, string $key): bool =>
        $key === '@type' || $value !== '',
    ARRAY_FILTER_USE_BOTH
);
if (count($address) > 1) {
    $organization['address'] = $address;
}
$businessWeb = trim((string) ($_ENV['VITE_BUSINESS_WEB'] ?? ''));
if ($businessWeb !== '') {
    $organization['sameAs'] = [$businessWeb];
}
?>
<script<?= $headScriptNonceAttribute ?> type="application/ld+json">
<?= json_encode($organization, $jsonScriptFlags | JSON_PRETTY_PRINT) ?>
</script>
