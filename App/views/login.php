<?php
//  Evita cache para que el navegador no guarde vistas protegidas
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header("Expires: 0");
if (isset($_SESSION["id_rol"])) {

    // debuguear([$lang,$urlLang,$ruta,$url, $arrayRutasGet[$lang][$url]]);
    // Cogemos con la función de Darren la URL equivalente pero en el idioma de $lang
    header("Location:" . $_ENV['RAIZ'] . getMatchRouteByLang("/es/area-socio", $lang));
    exit;
}
?>

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
            <main>
                <video data-lang="video" id="video" width="100%" height="100%" preload="auto" autoplay loop muted playsinline title="<?= $video->title ?>">
                    <source src="<?= $_ENV["RAIZ"] ?>/assets/video/dummy.webm" type="video/webm">
                    <source src="<?= $_ENV["RAIZ"] ?>/assets/video/dummy.mp4" type="video/mp4">
                </video>

                <div id="contenedor_formulario">
                    <div class="contenedor_formulario">
                        <div>
                            <div>                                
                                <form id="formulario" method="post" class="cuadro">
                                    <h1 data-lang="header_primary"><?= $header_primary->text ?></h1>
                                    <span id="email_error" class="error"></span>
                                    <label data-lang="user_label" for="usuarioId" style="display:none;"><?= $user_label->text ?></label>
                                    <input data-lang="user_input" id="usuarioId" class="campo" type="text" name="usuario" placeholder="<?= $user_input->placeholder ?>" required>

                                    <span id="password_error" class="error"></span>
                                    <div class="passwordContainer">
                                        <img data-lang="pass_view" class="showPassword" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/hidePassword.svg" alt="<?= $pass_view->alt ?>" title="<?= $pass_view->title ?>">
                                        <label data-lang="password_label" for="passwordId" style="display:none;"><?= $password_label->text ?></label>
                                        <input data-lang="password_input" id="passwordId" class="campo controlViewPass" type="password" name="password" placeholder="<?= $password_input->placeholder ?>" autocomplete="on" required>
                                    </div>

                                    <input data-lang="connect_input" value="Conectarse" type="submit" class="boton" id="boton_formulario">

                                    <a data-lang="forgot_password_link" href="<?= $_ENV["RAIZ"] ?>/<?= $lang ?>/<?= $forgot_password_link->href ?>" title="<?= $forgot_password_link->href ?>"><?= $forgot_password_link->title ?></a>
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
                    <img data-lang="enviado" src="<?= $_ENV['RAIZ'] ?>/assets/img/system/check-OK.svg" width="150" height="150" loading="lazy" class="lazyload" alt="<?= $enviado->alt ?>" title="<?= $enviado->title ?>">
                </div>
            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>



</body>

</html>