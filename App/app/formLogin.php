<?php

require_once __DIR__."/../class/_comprobaciones.php";
require_once __DIR__."/../models/_credencial.php";
$comprobacion = new clase_comprobaciones;
$lang = $_COOKIE["cookie_custom_lang"] ?? "es";
$translate_path = __DIR__ ."/../config/languages/login/$lang.json";
if (isset($_POST)) {

    $email = $_POST["usuario"];
    $pass = $_POST["password"];
    $exists_file = file_exists($translate_path);
    $translate_messages = $exists_file ?  file_get_contents($translate_path) : null;
    $translate_messages = $translate_messages ? json_decode($translate_messages) : null;
    $errors = $translate_messages ? $translate_messages->errors : null;
    //Comprobaciones de correo (user)
    //Vacía
    if (empty(trim($email))) {
        $fallo = true;
        $mensaje = $errors?->empty_email ?? "Empty email";
        $campo = "email_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "empty_email");
    }
    // NÚMERO
    if (is_numeric($email)) {
        $fallo = true;
        $mensaje = $errors?->numeric_email ?? "The email cannot be a number";
        $campo = "email_error";
        devolver_respuesta($mensaje, $fallo, $campo, $campo, data_lang: "numeric_email");
    }
    // >100
    $numCaracteres = strlen($email);
    if ($numCaracteres > 100) {
        $fallo = true;
        $mensaje = $errors?->max_length ?? "The email must have a maximum of 100 characters.";
        $campo = "email_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "max_length");
    }
    // VALID
    if ($comprobacion->validar_email($email) == 0 && !empty($email)) {
        $fallo = true;
        $mensaje = $errors?->email_invalid ?? "The email does not have correct syntax";
        $campo = "email_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "email_invalid");
    }

    //Si es peligroso
    if ($comprobacion->validar_peligroso($email) == 1) {
        $fallo = true;
        $mensaje = $errors?->insecure_email ?? "The value contains values ​​that are not supported for security reasons. Please change it.";
        $campo = "email_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "insecure_email");
    }

    //Comprobaciones de password
    //Vacía
    if (empty(trim($pass))) {
        $fallo = true;
        $mensaje = $errors?->empty_password ?? "You must enter a password";
        $campo = "password_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "empty_password");
    }


    // Comprobar en tabla credenciales si existe o no ese usuario y contraseña.
    $credential = Credencial::where("email_login", value: $email);
    // Si no son las credenciales correctas
    if ($credential !== null && $credential->verifyPassword($pass)) {
        // Si existe, apuntar fecha acceso en credenciales, crear SESSION de este usuario y revolver json de todo OK. En JS haremos la redirección a la página de zona privada después de hacer una animación
        //Guardamos la fecha y hora de la conexión en el modelo
        $credential->last_conection = date("Y-m-d H:i:s");
        //Eliminamos el token del modelo
        $credential->token = "";
        $credential->token_data_limit = "";
        $credential->save(); // Guardamos el registro en base de datos
        //Creamos la session y guardamos el email en ella
        start_secure_config_session();

        // Regenera el ID de sesión para prevenir secuestro
        session_regenerate_id(true);
        $_SESSION["email"] = $credential->email_login;
        $_SESSION["id_rol"] = $credential->id_rol;
        $_SESSION["id_usuario"] = $credential->id_usuario;
        // $_SESSION["nombre"] = $credencial->nombre;
        devolver_respuesta(
            mensaje: "success",
            fallo: false,
            campo: "email_error"
        );
    }
    // Devolver respuesta de error
    devolver_respuesta(
        mensaje: $errors?->login_error ?? "The username or password is invalid",
        fallo: true,
        campo: "email_error",
        data_lang: "login_error"
    );
} else {

    // NO ENTRA POR POST, devolvemos fallo
    $fallo = true;
    $mensaje = $errors?->bad_request ?? "No data is being received from the form";
    $campo = "email_error";
    devolver_respuesta($mensaje, $fallo, $campo, data_lang: "bad_request");
}

function start_secure_config_session()
{
    // Establecer los parámetros de la sesión para protegerla
    $sessionParams = [
        'lifetime' => 0, // La cookie de sesión se eliminará cuando el navegador se cierre
        'path' => '/', // La cookie de sesión será válida para todo el dominio
        'domain' => '', // Se puede definir el dominio (dejamos vacío para usar el dominio actual)
        'secure' => true, // Solo se enviará la cookie a través de conexiones HTTPS
        'httponly' => true, // La cookie no será accesible desde JavaScript (protege contra XSS)
        'samesite' => 'Strict', // Evita que la cookie se envíe con solicitudes de terceros (protege contra CSRF)
    ];

    if (session_status() === PHP_SESSION_DISABLED) {
        // Establecer los parámetros de la sesión antes de iniciar la sesión
        session_set_cookie_params($sessionParams);
        //Comenzar la session
        session_start();
    }
}
