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
            <main>
                <div id="contenedor_formulario">
                    <h1 data-lang="title"><?= $title->text ?></h1>
                    <div class="info">
                        <p data-lang="info1"><?= $info1->text ?></p>
                        <p data-lang="info2"><?= $info2->text ?></p>
                        <p data-lang="info3"><?= $info3->text ?></p>
                    </div>
                    <div class="contenedor_formulario">
                        <div>
                            <div>
                                <form id="formulario" method="post" class="cuadro">
                                    <span id="email_error" class="error"></span>
                                    <label data-lang="email_label" for="correoId" style="display:none;"><?= $email_label->text ?></label>
                                    <input data-lang="email_input" id="correoId" class="campo" type="text" name="email" placeholder="<?= $email_input->placeholder ?>" required>

                                    <input data-lang="send_button" value="<?= $send_button->value ?>" type="submit" class="boton" id="boton_formulario">
                                </form>
                                <!-- loader nuevo -->
                                <div class="moduleLoader01 loaderBaseLad cube-wrapper" id="loaderPrimary">
                                    <div class="cube">
                                        <div class="sides">
                                            <div class="top"></div>
                                            <div class="right"></div>
                                            <div class="bottom"></div>
                                            <div class="left"></div>
                                            <div class="front"></div>
                                            <div class="back"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="enviado" class="cuadro">
                    <img data-lang="enviado" src="<?= $_ENV['RAIZ'] ?>/assets/img/system/check-OK.svg" width="50" height="50" loading="lazy" class="lazyload" alt="<?= $enviado->alt ?>" title="<?= $enviado->title ?>">
                    <div class="caja">
                        <h4 data-lang="email_success_message"><?= $email_success_message->text ?></h4>
                        <a data-lang="go_to_homepage" href="<?= $_ENV['RAIZ'] ?>/<?=$lang?>" class="boton" title="<?= $go_to_homepage->title ?>"><?= $go_to_homepage->text ?></a>
                    </div>
                </div>
            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>



</body>

</html>