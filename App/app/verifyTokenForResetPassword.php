<?php
require_once __DIR__."/../models/_credencial.php";

$isInvalidToken = true;

//Obtenemos el valor del token desde el query string 't'
$token = $_GET["t"] ?? null;
// Si el token no es null, verificamos si existe algún registro en la tabla credenciales
$credential = $token ? Credencial::where("token", $token) : null;
// Si la credencial existe, verificamos si el token ha expirado;
if ($credential) {
    $isInvalidToken = $credential->isTokenExpired();
    if ($isInvalidToken) {
        //Si el token ha expirado, lo eliminamos;
        $credential->token = "";
        $credential->token_data_limit = "";
        //Le indicamos al modelo que guarde el registro al que a apunta en base de datos
        $credential->save();
    }
}
