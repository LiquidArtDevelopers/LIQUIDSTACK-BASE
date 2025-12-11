<!DOCTYPE html>
<html lang="<?= $lang ?>">

<head>
    <!-- Global & Variant HEAD -->
    <?php include_once __DIR__.'/../includes/_globalHead.php' ?>
</head>

<body>

    <!-- Global BODY -->
    <?php include_once __DIR__.'/../includes/_globalBody.php' ?>

    <!-- NAV -->
    <?php include __DIR__.'/../includes/_nav.php' ?>


    <div id="smooth-wrapper">
        <div id="smooth-content">

            <?php
            $heroButton  = controller('moduleButtonType01', 0);
            $heroContent = controller('moduleH1Type01', 0, [
                '{a-button-primary}' => $heroButton,
            ]);
            echo controller('hero01', 0, ['{hero01-content}' => $heroContent]);
            ?>

            <main>
                <?php
                $servicesHeader = controller('moduleH2Type01', 1);
                $ctaA           = controller('moduleButtonType02', 0);
                $ctaB           = controller('moduleButtonType02', 1);
                $ctaC           = controller('moduleButtonType02', 2);

                echo controller('sect02', 0, [
                    '{header-primary}'     => $servicesHeader,
                    '{a-button-secondary}' => $ctaA,
                    '{b-button-secondary}' => $ctaB,
                    '{c-button-secondary}' => $ctaC,
                    'items'                => 3,
                ]);
                ?>
                <section>
                    <?php
                    echo controller('art04', 0, ['items' => 3]);

                    $primaryCta = controller('moduleButtonType01', 0);
                    echo controller('art16', 0, [
                        '{button-primary}' => $primaryCta,
                    ]);

                    echo controller('art05', 0, ['items' => 4]);
                    ?>
                </section>
            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>



</body>

</html>
