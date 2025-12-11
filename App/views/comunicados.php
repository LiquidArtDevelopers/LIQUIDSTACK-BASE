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

            <?php
            $c = controller('moduleH1Type01', 0);            
            echo controller('hero02', 0, ['{hero02-content}' => $c]);
            ?>

            <main>
                <?php
                $h2       = controller('moduleH2Type01', 1);
                $b0  = controller('moduleButtonType02', 0);
                // $b1  = controller('moduleButtonType02', 0);
                // $b2  = controller('moduleButtonType02', 0);
                ?>

                <?php
                echo controller('sect02', 0, [
                    '{header-primary}'     => $h2,

                    '{a-button-secondary}' => $b0,
                    // '{b-button-secondary}' => $b1,
                    // '{c-button-secondary}' => $b2,

                    'items'                => 1
                ]);
                ?>
            </main>

            <!-- FOOTER -->
            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>


</body>

</html>