<!DOCTYPE html>
<html lang="<?= $lang ?>">

<head>
    <!-- Global & Variant HEAD -->
    <?php include_once __DIR__.'/../includes/_globalHead.php'?>
</head>

<body>

    

    <!-- Global BODY -->
    <?php include_once __DIR__.'/../includes/_globalBody.php'?>  

    <!-- NAV -->
    <?php include __DIR__.'/../includes/_nav.php' ?>


    <div id="smooth-wrapper">
        <div id="smooth-content">

            <?php
            $boton   = controller('moduleButtonType01', 0);
            $content = controller('moduleH1Type01', 0, [
                '{a-button-primary}' => $boton
            ]);
            echo controller('hero01', 0, ['{hero01-content}' => $content]);
            echo controller('hero00', 0, ['{hero00-content}' => $content]);
            echo controller('hero02', 0, ['{hero02-content}' => $content]);
            ?>

            <main>

                <section>
                    <?php
                    echo controller('artScatter01', 0);
                    ?>
                </section>

                <section>
                    <?php
                    echo controller('artMarquee01', 0, [
                        'items'      => 4,
                        'items_row1' => 4,
                        'items_row2' => 4,
                        'with_images'=> false
                    ]);
                    ?>
                </section>

                <section>
                    <?php
                    $scaleButton = controller('moduleButtonType01', 0);
                    echo controller('artScale01', 0, [
                        '{button-primary}' => $scaleButton,
                    ]);
                    ?>
                </section>

                <?php
                echo controller('sectionParallax01', 0, [
                    'items'      => 3,
                    'list_items' => 3,
                ]);
                ?>

                <?php
                $particlesButtonPrimary   = controller('moduleButtonType01', 0);
                $particlesButtonSecondary = controller('moduleButtonType02', 0);

                $particlesStep1Title = controller('moduleH2Type01', 0);
                $particlesStep2Title = controller('moduleH2Type01', 1);
                $particlesStep3Title = controller('moduleH2Type01', 2);

                $particlesStep1Text = $GLOBALS['moduleH1Type02_00_p01_text']->text ?? '';
                $particlesStep2Text = $GLOBALS['moduleH1Type02_00_p02_text']->text ?? '';
                $particlesStep3Text = $GLOBALS['moduleTest_00_p_text']->text ?? '';

                $particlesContent = <<<HTML
                <article data-particles-step data-particles-align="left" data-particles-shape="cube" data-particles-shape-ratio="0.94" data-particles-shape-scale="0.9" data-particles-shape-offset-x="0.26">
                    <div class="sectionParticles01-copy">
                        {$particlesStep1Title}
                        <p data-lang="moduleH1Type02_00_p01_text">{$particlesStep1Text}</p>
                        <div class="sectionParticles01-cta">{$particlesButtonPrimary}</div>
                    </div>
                </article>
                <!-- MATRIX CONTROLS (min/max)
                SHAPE (afecta al conjunto matrix completo):
                - data-particles-shape-ratio: % de particulas dedicadas al shape (0.3-1). Menos = menos letras+cortina.
                - data-particles-shape-scale: escala base del shape (0.2-1.3). En matrix puede auto-aumentar para cubrir viewport.
                - data-particles-shape-offset-x: desplaza en X (-0.45 a 0.45).
                - data-particles-shape-hold: pausa en el centro (0-0.85; >0.85 se recorta).

                CORTINA (BG) - USAR ESTOS:
                - data-particles-matrix-bg-cols: columnas de la cortina (10-420).
                - data-particles-matrix-bg-rows: filas de la cortina (12-320).
                - data-particles-matrix-bg-column-density: % columnas activas (0.2-2.5; 1=100%).
                - data-particles-matrix-bg-column-fill: largo de las columnas (0.3-1.8).
                - data-particles-matrix-bg-column-alpha: brillo de columnas (0.5-2.2).
                - data-particles-matrix-bg-noise-density: ruido aleatorio (0-2.5).
                - data-particles-matrix-bg-row-spacing: salto vertical (1-6; 1=mas continuo).
                - data-particles-matrix-bg-density: base/fallback (0.2-2.5). Solo se usa si no defines bg-column-density o bg-noise-density.

                FALLBACKS (solo si NO hay bg-*):
                - data-particles-matrix-cols: columnas fallback (10-420).
                - data-particles-matrix-rows: filas fallback (12-320).
                - data-particles-matrix-density: densidad base fallback (0.25-2.5).
                - data-particles-matrix-column-density: columnas activas fallback (0.2-2.5).
                - data-particles-matrix-column-fill: largo fallback (0.3-1.8).
                - data-particles-matrix-column-alpha: brillo fallback (0.5-2.2).
                - data-particles-matrix-noise-density: ruido fallback (0-2.5).
                - data-particles-matrix-row-spacing: salto vertical fallback (1-6).

                GLIFOS/FONT:
                - data-particles-matrix-font-scale: tamano del glifo (0.4-1.2).

                MOVIMIENTO:
                - data-particles-matrix-speed: velocidad de caida (0.5-14).

                LETRAS:
                - data-particles-matrix-word-src: imagen de las letras.
                - data-particles-matrix-word-count: particulas SOLO letras (60-max disponible; se recorta si te pasas).
                - data-particles-matrix-word-letter-gap: separacion interna (0-0.2).
                - data-particles-matrix-word-particle-scale: tamano particulas letras (0.5-1.2).
                - data-particles-matrix-word-image-scale: escala imagen letras (0.18-0.8).
                - data-particles-matrix-word-image-boost: densidad de muestreo (1-10).
                - data-particles-matrix-word-image-step: paso muestreo (1-4; 1 mas denso).
                - data-particles-matrix-word-image-offset-x/y: desplazamiento (-0.4 a 0.4).
                -->
                <article data-particles-step data-particles-align="right"
                data-particles-shape="matrix"
                data-particles-shape-ratio="1"
                data-particles-shape-scale="1.3"
                data-particles-shape-offset-x="0"
                data-particles-shape-hold="1"
                data-particles-matrix-bg-cols="360"
                data-particles-matrix-bg-rows="160" 
                data-particles-matrix-bg-density="2"
                data-particles-matrix-bg-column-density="2.2"
                data-particles-matrix-bg-column-fill="1.6"
                data-particles-matrix-bg-column-alpha="0.2"
                data-particles-matrix-bg-noise-density="0.35"
                data-particles-matrix-bg-row-spacing="1"
                data-particles-matrix-font-scale="0.40"
                data-particles-matrix-speed="5"
                data-particles-matrix-word-src="/assets/img/particles/matrix.png"
                data-particles-matrix-word-count="6000"
                data-particles-matrix-word-letter-gap="0"
                data-particles-matrix-word-particle-scale="1"
                data-particles-matrix-word-image-scale="0.34"
                data-particles-matrix-word-image-boost="8"
                data-particles-matrix-word-image-step="1"
                data-particles-matrix-word-image-offset-x="-0.17"
                data-particles-matrix-word-image-offset-y="0">
                    <div class="sectionParticles01-copy">
                        {$particlesStep2Title}
                        <p data-lang="moduleH1Type02_00_p02_text">{$particlesStep2Text}</p>
                        <div class="sectionParticles01-cta">{$particlesButtonSecondary}</div>
                    </div>
                </article>
                <article data-particles-step data-particles-align="left" data-particles-shape="blackhole" data-particles-shape-ratio="0.92" data-particles-shape-scale="1.1" data-particles-shape-depth="1.6" data-particles-shape-depth-jitter="0.18" data-particles-shape-offset-x="0.18" data-particles-bh-disk-inner="0.34" data-particles-bh-disk-outer="0.74" data-particles-bh-disk-thickness="0.08" data-particles-bh-halo="0.26" data-particles-bh-rim="0.16" data-particles-bh-tilt="18">
                    <div class="sectionParticles01-copy">
                        {$particlesStep3Title}
                        <p data-lang="moduleTest_00_p_text">{$particlesStep3Text}</p>
                        <div class="sectionParticles01-cta">{$particlesButtonPrimary}</div>
                    </div>
                </article>
                HTML;

                echo controller('sectionParticles01', 0, [
                    '{content}' => $particlesContent,
                ]);
                ?>



                <?php
                // moduleH2Type01 Refactorizado (fondo oscuro y animación)
                $h2 = controller('moduleH2Type01', 0);
                ?>

                <?php
                // moduleH1Type02 (título y texto centrados sin fondo)
                $moduleH1Type02Button = controller('moduleButtonType01', 0);
                echo controller('moduleH1Type02', 0, [
                    '{a-button-primary}' => $moduleH1Type02Button,
                ]);
                ?>

                <?php
                $boton01 = controller('moduleButtonType01', 0);
                $boton02 = controller('moduleButtonType01', 0);
                echo controller('sect01', 0, [
                    '{header-primary}'     => $h2,
                    '{a-button-secondary}' => $boton01,
                    '{d-button-secondary}' => $boton02,
                    'items'               => 4
                ]);
                ?>


                
                <?php
                $h2       = controller('moduleH2Type01', 1);
                $boton01  = controller('moduleButtonType02', 0);
                $boton02  = controller('moduleButtonType02', 0);
                $boton03  = controller('moduleButtonType02', 0);
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
                

                <?php
                // moduleH2Type01 Refactorizado (fondo oscuro y animación)
                $h2 = controller('moduleH2Type01', 2);
                echo controller('sectTabs01', 0, ['{section-h2}' => $h2, 'items' => 3]);
                ?>



                <section>
                    
                    <?php
                    // moduleH2Type01 Refactorizado (fondo oscuro y animación)
                    echo controller('moduleH2Type01', 3);
                    ?>


                    <?php
                    // moduleButtonType01 Refactorizado (flecha animada · oscuro)
                    $moduleButton02 = controller('moduleButtonType01', 0);
                    ?>
                    <?php
                    // moduleButtonType02 Refactorizado (simple)
                    $moduleButton02a = controller('moduleButtonType02', 0);
                    ?>
                    <?php
                    // moduleButtonType02 Refactorizado (simple)
                    $moduleButton02b = controller('moduleButtonType02', 0);
                    ?>                 

                    <?php
                    echo controller('art01', 0, [
                        '{a-button-secondary}' => $moduleButton02a,
                        '{b-button-secondary}' => $moduleButton02b,
                        '{button-primary}'    => $moduleButton02,
                        'items'               => 2,
                    ]);
                    ?>

                    <?php
                    $moduleButton02b = controller('moduleButtonType02', 0);
                    echo controller('art02', 0, [
                        '{a-button-primary}' => $moduleButton02b,
                        '{b-button-primary}' => $moduleButton02b,
                        'items'              => 2,
                    ]);
                    ?>

                                        
                    <?php
                    echo controller('art03', 0, ['items' => 4]);
                    ?>


                    <?php
                    // art04 Refactorizado (instancia 00)
                    echo controller('art04', 0, ['items' => 3]);
                    ?>

                    <?php
                    // art05-2 Refactorizado (instancia 00)
                    echo controller('art05', 0, ['items' => 4]);
                    ?>

                    <?php
                    // art06 Refactorizado (instancia 00)
                    echo controller('art06', 0, ['items' => 3]);
                    ?>

                    <?php
                    // art07 Refactorizado (instancia 00)
                    echo controller('art07', 0);
                    ?>

                    <?php
                    $art16Button = controller('moduleButtonType01', 0);
                    echo controller('art16', 0, [
                        '{button-primary}' => $art16Button,
                    ]);
                    ?>

                    <?php
                    $art17Header = controller('moduleH2Type01', 4);
                    $art17Cta    = controller('moduleButtonType02', 0);

                    echo controller('art17', 0, [
                        '{header-primary}'   => $art17Header,
                        '{a-button-primary}' => $art17Cta,
                        'items'              => 2,
                        'list_items'         => [
                            'a' => 7,
                            'b' => 6,
                        ],
                    ]);
                    ?>

                    <?php
                    // moduleButtonType01 Refactorizado (flecha animada · oscuro)
                    $moduleButton01 = controller('moduleButtonType01', 0);
                    ?>


                    <?php
                    // art08 Refactorizado (instancia 00)
                    echo controller('art08', 0, [
                        'items' => 2,
                        '{a-button-primary}' => $moduleButton01,
                        '{b-button-primary}' => $moduleButton01
                    ]);
                    ?>
                    <?php
                    // art09 Refactorizado (instancia 00)
                    echo controller('art09', 0, ['items' => 3]);
                    ?>


                    <?php
                    // art10 Refactorizado (instancia 00)
                    echo controller('art10', 0, ['items' => 3]);
                    ?>


                    <?php
                    echo controller('art11', 0, ['items' => 3]);
                    ?>


                    <?php
                    // art12 Refactorizado (instancia 00)
                    echo controller('art12', 0, ['items' => 3]);
                    ?>


                    <?php
                    // art13 Refactorizado (instancia 00)
                    echo controller('art13', 0, ['items' => 1]);
                    ?>


                    <?php
                    // moduleButtonType01 Refactorizado (flecha animada · oscuro)
                    $boton = controller('moduleButtonType01', 0);
                    ?>

                    <?php
                    // art14 Refactorizado (instancia 00)
                    echo controller('art14', 0, ['{button-primary}' => $boton]);
                    ?>


                    <?php
                    // art15 Refactorizado (instancia 00)
                    echo controller('art15', 0);
                    ?>

                    <?php
                    // art15 Refactorizado (instancia 00)
                    echo controller('art16', 0);
                    ?>

                    <?php
                    // art15 Refactorizado (instancia 00)
                    echo controller('art17', 0);
                    ?>
                    
                    <?php
                    echo controller('art18', 0, [
                        'items' => 3,
                        'list_items' => [
                            'a' => 3,
                            'b' => 3,
                            'c' => 4
                        ],
                    ]);
                    ?>

                    
                    

                    <?php
                    // artSlider01 Refactorizado (instancia 00)
                    echo controller('artSlider01', 0, ['items' => 10]);
                    ?>

                    <?php
                    // artSlider02 Refactorizado (instancia 00)
                    echo controller('artSlider02', 0, ['items' => 4]);
                    ?>
                    

                    <?php
                    // artForm01 Refactorizado (instancia 00)
                    echo controller('artForm01', 0);
                    ?>
                    <?php
                    // artAccordion01 Refactorizado (instancia 00)
                    echo controller('artAccordion01', 0, ['items' => 3]);
                    ?>


                    <?php
                    // artZipper Refactorizado — dinámico (instancia 00)
                    echo controller('artZipper', 0, ['items' => 5]);
                    ?>
                    <?php
                    /*--------------------------------------
                    _moduleTest
                    --------------------------------------*/
                    echo controller('moduleTest', 0);
                    ?>

                    <?php
                    // Módulo de imagen simple
                    echo controller('moduleImgType01', 0);
                    ?>
                    
                    
                </section>

            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>

    

</body>

</html>
