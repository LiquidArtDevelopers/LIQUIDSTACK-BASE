<?php
//  Evita cache para que el navegador no guarde vistas protegidas
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header("Expires: 0");

//  Redirección si no hay sesión
if (!isset($_SESSION["id_rol"])) {
    header("Location:" . $_ENV['RAIZ'] . "/" . $lang);
    exit;
}

require_once "../App/models/_usuarios.php";
require_once "../App/models/_admins.php";

$email = $_SESSION["email"] ?? null;
$id_usuario = $_SESSION["id_usuario"] ?? null;

$usuario = $id_usuario ? (Usuario::where("id_usuario", $id_usuario) ?? Admin::where("email", $email)) : null;
$nombre = strtolower($usuario->nombre);
$num_socio = $usuario->num_socio ?? null;

if (!$usuario) {
    header("Location: ./logout");
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
            <header data-speed="0.95">
                <div class="content" data-speed="0.8">
                    <h1>
                        <div>
                            <span data-lang="welcome"><?= $welcome->text ?></span>
                            <span><?= $nombre ?></span>
                        </div>
                        <span data-lang="h1"><?= $h1->text ?></span>
                    </h1>
                    <img data-lang="icon" src="<?= $_ENV['RAIZ'] ?>/assets/img/logos/logo-black.svg" alt="<?= $icon->alt ?>" title="<?= $icon->title ?>">
                    <?php if ($num_socio) : ?>
                        <p><span data-lang="header_num_socio"><?= $header_num_socio->text ?></span> <span><?= $num_socio ?></span></p>
                    <?php endif ?>
                </div>
                <p data-speed="0.9">LSD</p>
                <div class="sombra"></div>
                <div class="triangulo"></div>
            </header>        

            <main>
                <section>

                    <?php
                    // moduleH2Type01 Refactorizado (fondo oscuro y animación)
                    echo controller('moduleH2Type01', 0);                    
                    ?>

                    
                    <?php
                    // moduleButtonType02 Refactorizado (simple)
                    $b1 = controller('moduleButtonType02', 0);
                    ?>
                    <?php
                    // moduleButtonType02 Refactorizado (simple)
                    $b2 = controller('moduleButtonType02', 1);
                    ?>                 

                    <?php
                    echo controller('art01', 0, [
                        '{a-button-secondary}' => $b1,
                        '{b-button-secondary}' => $b2,
                        'items'               => 2,
                    ]);
                    ?>

                    <?php
                    // artSlider01 Refactorizado (instancia 00)
                    echo controller('artSlider01', 0, ['items' => 5]);
                    ?>
                </section>
            </main>


            
            <!-- FOOTER -->
            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>


</body>

</html>