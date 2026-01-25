

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
            $boton   = controller('moduleButtonType01', 0);
            $content = controller('moduleH1Type01', 0, [
                '{a-button-primary}' => $boton
            ]);
            echo controller('hero02', 0, ['{hero02-content}' => $content]);
            ?>

            <main>

            <?php
                $h2       = controller('moduleH2Type01', 0);
                $boton01  = controller('moduleButtonType02', 0);
                $boton02  = controller('moduleButtonType02', 1);
                $boton03  = controller('moduleButtonType02', 2);
                ?>

                <?php
                echo controller('sect02', 0, [
                    '{header-primary}'     => $h2,
                    '{a-button-secondary}' => $boton01,
                    '{b-button-secondary}' => $boton02,
                    '{c-button-secondary}' => $boton03,
                    'items'                => 3
                ]);
                ?>
                          
            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>



</body>

</html>