<?php

require_once '../App/app/verifyTokenForResetPassword.php';
?>


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
                <?php if ($isInvalidToken) { ?>
                    <div>
                        <p style="color:#fff" data-lang="token_invalid"><?= $token_invalid->text ?></p>
                    </div>
                    <?php } else { ?>
                    <div id="contenedor_formulario" >
                        <h1 data-lang="title"><?= $title->text ?></h1>
                        <div class="info">
                            <p data-lang="info_text1"><?= $info_text1->text ?></p>
                            <p data-lang="info_text2"><?= $info_text2->text ?></p>
                        </div>

                        <div class="contenedor_formulario">
                            <div>
                                <div>
                                    <form id="formulario" method="post" class="cuadro">
                                        <div class="modulePassChecker">
                                            <div class="checkCount">
                                                <img data-lang="check" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/check-ERROR.svg" alt="<?=$check->alt?>" title="<?=$check->title?>">
                                                <span data-lang="eight_min_length"><?= $eight_min_length->text ?></span>
                                            </div>
                                            <div class="checkCapital">
                                                <img data-lang="check" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/check-ERROR.svg" alt="<?=$check->alt?>" title="<?=$check->title?>">
                                                <span data-lang="missing_upp_low"><?= $missing_upp_low->text ?></span>
                                            </div>
                                            <div class="checkSpecial">
                                                <img data-lang="check" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/check-ERROR.svg" alt="<?=$check->alt?>" title="<?=$check->title?>">
                                                <span data-lang="missing_special_character"><?= $missing_special_character->text ?></span>
                                            </div>
                                            <div class="checkNum">
                                                <img data-lang="check" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/check-ERROR.svg" alt="<?=$check->alt?>" title="<?=$check->title?>">
                                                <span data-lang="missing_number"><?= $missing_number->text ?></span>
                                            </div>
                                            <div class="checkSpace">
                                                <img data-lang="check" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/check-ERROR.svg" alt="<?=$check->alt?>" title="<?=$check->title?>">
                                                <span data-lang="not_empty"><?= $not_empty->text ?></span>
                                            </div>
                                        </div>

                                        <span id="new_password_error" class="error"></span>
                                        <div class="passwordContainer">
                                            <img data-lang="pass_view" class="showPassword" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/hidePassword.svg" alt="<?=$pass_view->alt?>" title="<?=$pass_view->title?>">
                                            <label class="labelPass" data-lang="new_password_label" for="passwordId"><?= $new_password_label->text ?></label>
                                            <input data-lang="new_password_input" id="passwordId" class="campo controlViewPass" type="password" name="newpassword" placeholder="<?= $new_password_input->placeholder ?>" required>
                                            <img data-lang="check" class="checkImgInput completePasswordCheck" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/check-ERROR.svg" alt="<?=$check->alt?>" title="<?=$check->title?>">
                                        </div>

                                        <span id="repeat_new_password_error" class="error"></span>
                                        <div class="passwordContainer">
                                            <img data-lang="pass_view" class="showPassword" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/hidePassword.svg" alt="<?=$pass_view->alt?>" title="<?=$pass_view->title?>">
                                            <label class="labelPass" data-lang="repeat_new_password_label" for="repeatPasswordId"><?= $repeat_new_password_label->text ?></label>
                                            <input data-lang="repeat_new_password_input" id="repeatPasswordId" class="campo controlViewPass" type="password" name="repeatpassword" placeholder="<?= $repeat_new_password_input->placeholder ?>" required>
                                            <img data-lang="check" class="checkImgInput doublePasswordCheck" src="<?= $_ENV["RAIZ"] ?>/assets/img/system/check-ERROR.svg" alt="<?=$check->alt?>" title="<?=$check->title?>">
                                        </div>

                                        <input data-lang="change_password_button" value="<?= $change_password_button->value ?>" type="submit" class="boton" id="boton_formulario">
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
                        <img data-lang="enviado" src="<?= $_ENV['RAIZ'] ?>/assets/img/check-OK.svg" width="50" height="50" loading="lazy" class="lazyload" alt="<?= $enviado->alt ?>" title="<?= $enviado->title ?>">
                        <div class="caja">
                            <h4 data-lang="success_title"><?= $success_title->text ?></h4>
                            <p data-lang="success_paragraph"><?= $success_paragraph->text ?></p>
                            <a data-lang="go_to_login_page" href="<?= $_ENV['RAIZ'] ?>/<?=$lang?>" class="boton" title="<?= $go_to_login_page->title ?>"><?= $go_to_login_page->text ?></a>
                        </div>
                    </div>
                <?php } ?>
            </main>

            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>

    


</body>

</html>