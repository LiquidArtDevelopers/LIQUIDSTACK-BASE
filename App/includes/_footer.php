<footer>
    <?php
    // Global megamenu rendered via controller
    echo controller('navMegamenu01', 0, [
        'offices' => [],
        'show_private_access' => false,
        'public_link_keys' => [[
            'link' => 'navMegamenu01_00_blog',
            'text' => 'navMegamenu01_00_blogText',
        ]],
    ]);
    ?>

    <?php
    echo controller('footerInfo01', 0);
    ?>
        
</footer>
