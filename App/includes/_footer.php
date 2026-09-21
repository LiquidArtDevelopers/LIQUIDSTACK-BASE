<footer>
    <?php
    // Global megamenu rendered via controller
    $liquidstackPublicNavigation = require __DIR__
        . '/../config/public-navigation.php';
    echo controller('navMegamenu01', 0, [
        'offices' => [],
        'show_private_access' => false,
        'public_link_keys' => $liquidstackPublicNavigation(
            (string) ($GLOBALS['lang'] ?? '')
        ),
    ]);
    unset($liquidstackPublicNavigation);
    ?>

    <?php
    echo controller('footerInfo01', 0);
    ?>
        
</footer>
