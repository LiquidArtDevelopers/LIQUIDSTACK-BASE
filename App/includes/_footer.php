<footer>
    <?php
    // Global megamenu rendered via controller
    echo controller('navMegamenu01', 0);
    ?>

    <?php
    echo controller('footerInfo01', 0, [
        'footerInfo01_00_img1' => ''
    ]);
    ?>
        
</footer>