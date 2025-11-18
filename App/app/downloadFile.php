<?php
// require_once "../App/models/_credencial.php";
// if (isset($_SESSION["id_rol"])) {
//     $file = $_GET["file"] ?? null;
//     $path = "../App/files/";
//     //Verificar si existe la credencial por sesión desde el email
//     $credential = Credencial::where("email_login", $_SESSION["email"]);
//     if ($credential) {
//         $files = scandir($path);
//         if ($files) {
//             $files = array_filter($files, fn($cb_file) => $cb_file === $file);
//             $file = array_shift($files);
//             if ($file) {
//                 // Configuración de las cabeceras http para descargar archivos
//                 header("Content-Type: application/pdf");
//                 header("Content-disposition: attachment; filename=\"" . basename($file) . "\"");
//                 // Leer y enviar el archivo
//                 readfile("$path/$file");
//                 //Limpiar el buffer 
//                 flush();
//                 exit();
//             }
//         }
//     }
// }


// opción sin credenciales

$file = $_GET["file"] ?? null;
$path = __DIR__."/../files/";

$files = scandir($path);
if ($files) {
    $files = array_filter($files, fn($cb_file) => $cb_file === $file);
    $file = array_shift($files);
    if ($file) {
        // Configuración de las cabeceras http para descargar archivos
        header("Content-Type: application/pdf");
        header("Content-disposition: attachment; filename=\"" . basename($file) . "\"");
        // Leer y enviar el archivo
        readfile("$path/$file");
        //Limpiar el buffer 
        flush();
        exit();
    }
}
    


header("Location: ./");
exit;
