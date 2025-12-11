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
            echo controller('hero02', 0, ['{hero02-content}' => $heroContent]);
            ?>

            <main>
                <?php
                $contactHeader    = controller('moduleH2Type01', 0);
                $primaryContactCta = controller('moduleButtonType01', 0);
                echo controller('moduleH1Type02', 0, ['{a-button-primary}' => $primaryContactCta]);

                $secondaryButtonA = controller('moduleButtonType02', 0);
                $secondaryButtonB = controller('moduleButtonType02', 1);

                echo controller('sect01', 0, [
                    '{header-primary}'     => $contactHeader,
                    '{a-button-secondary}' => $secondaryButtonA,
                    '{d-button-secondary}' => $secondaryButtonB,
                    'items'                => 4,
                ]);
                ?>
                <section>
                    
                    <?php
                    echo controller('moduleH2Type01', 1);

                    $primaryButtonA = controller('moduleButtonType01', 1);
                    $primaryButtonB = controller('moduleButtonType01', 2);

                    echo controller('art08', 0, [
                        '{a-button-primary}' => $primaryButtonA,
                        '{b-button-primary}' => $primaryButtonB,
                        'items'              => 2,
                    ]);
                    ?>
                </section>

                <section>
                    <?php
                    echo controller('moduleH2Type01', 2);
                    
                    // artForm01 Refactorizado (instancia 00)
                    echo controller('artForm01', 0);
                    ?>
                </section>
                
            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>



</body>

</html>
