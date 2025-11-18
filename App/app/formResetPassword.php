<?php

require_once __DIR__."/../config/config.php";
require_once __DIR__."/../class/_comprobaciones.php";
require_once __DIR__."/../models/_credencial.php";

$comprobacion = new clase_comprobaciones;
$lang = $_COOKIE["cookie_custom_lang"] ?? "es";
$translate_path = __DIR__ . "/../../config/languages/reset-password/$lang.json";
if (isset($_POST)) {

    $newPass = $_POST["newpassword"];
    $repeatPass = $_POST["repeatpassword"];
    $exists_file = file_exists($translate_path);
    $translate_messages = $exists_file ?  file_get_contents($translate_path) : null;
    $translate_messages = $translate_messages ? json_decode($translate_messages) : null;
    $errors = $translate_messages ? $translate_messages->errors : null;
    //Comprobaciones
    //Vacía
    if (empty($newPass)) {
        $fallo = true;
        $mensaje = $errors?->empty_password ?? "You must enter a password";
        $campo = "new_password_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "empty_password");
    }
    if (empty($repeatPass)) {
        $fallo = true;
        $mensaje = $errors?->repeat_new_password_empty ?? "You must repeat the password";
        $campo = "repeat_new_password_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "repeat_new_password_empty");
    }
    //No son iguales
    if ($newPass !== $repeatPass) {
        $fallo = true;
        $mensaje = $errors?->passwords_not_match ?? "Passwords do not match";
        $campo = "repeat_new_password_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "passwords_not_match");
    }
    //Si no es segura
    if ($comprobacion->validar_password($newPass) == 0 && !empty($newPass)) {
        $fallo = true;
        $mensaje = $errors?->incorrect_password ?? "The password is incorrect. You must comply with the security points.";
        $campo = "new_password_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "incorrect_password");
    }
    //Si es peligroso
    if ($comprobacion->validar_peligroso($newPass) == 1) {
        $fallo = true;
        $mensaje = $errors?->insecure_password ?? "The password contains values ​​that are not supported for security reasons. Please change it.";
        $campo = "new_password_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "insecure_password");
    }

    /* Continuar */
    $token = $_POST["t"] ?? null;
    //Cambiar la contraseña en la base de datos
    $credential = $token ? Credencial::where(column: "token", value: $token) : null;
    if (!$credential) {
        devolver_respuesta(
            fallo: true,
            mensaje: $errors?->invalid_access_token ?? "The access token is invalid",
            campo: "new_password_error",
            data_lang: "invalid_access_token"
        );
    }
    $credential->password = $newPass; // Lo guardamos en el modelo
    $credential->hash_password(); // Ciframos la contraseña
    // Eliminamos el token de acceso del modelo
    $credential->token = "";
    $credential->token_data_limit = "";
    $credential->save(); // Guardamos el registro actualizado en base de datos
    //NO hay que redirigir a ninguna página, sólo devolver la respuesta de abajo.
    $fallo = false;
    $mensaje = "success";
    $campo = "new_password_error";
    devolver_respuesta($mensaje, $fallo, $campo);
} else {
    // NO ENTRA POR POST, devolvemos fallo
    $fallo = true;
    $mensaje = $errors?->bad_request ?? "No data is being received from the form";
    $campo = "new_password_error";
    devolver_respuesta($mensaje, $fallo, $campo, data_lang: "bad_request");
}
