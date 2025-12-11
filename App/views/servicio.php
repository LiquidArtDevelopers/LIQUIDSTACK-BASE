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
            echo controller('hero00', 0, ['{hero00-content}' => $heroContent]);
            ?>

            <main>
                <section>                
                    <?php
                    echo controller('moduleH2Type01', 2);

                    $secondaryCta = controller('moduleButtonType01', 1);
                    echo controller('moduleH1Type02', 0, ['{a-button-primary}' => $secondaryCta]);

                    echo controller('art03', 0, ['items' => 4]);
                    echo controller('art10', 0, ['items' => 3]);
                    echo controller('art12', 0, ['items' => 3]);
                    ?>
                </section>
            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>



</body>

</html>
