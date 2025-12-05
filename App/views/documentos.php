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

if (!function_exists('resolveDocumentHref')) {
    function resolveDocumentHref(?string $href, string $lang): string
    {
        if (!$href) {
            return '#';
        }

        if (preg_match('/^(?:[a-z][a-z0-9+.-]*:|\/\/|\/)/i', $href)) {
            return $href;
        }

        $base = rtrim($_ENV['RAIZ'] ?? '', '/');

        return $base . '/' . $lang . '/' . ltrim($href, '/');
    }
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
            <header>
                <?php
                $boton   = controller('moduleButtonType01', 0);
                echo controller('moduleH1Type01', 0, [
                    '{a-button-primary}' => $boton
                ]);
                ?>
            </header>    
        
            <main>
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
            </main>
            <!-- como el footer no es fixed, lo meto también dentro del smoother -->
            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>


</body>

</html>