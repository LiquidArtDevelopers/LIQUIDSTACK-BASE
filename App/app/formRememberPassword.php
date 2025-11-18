<?php

require_once __DIR__."/../config/config.php";
require_once __DIR__."/../class/_comprobaciones.php";
require_once __DIR__."/../repositorios/_usersRepository.php";
require_once __DIR__."/../models/_credencial.php";
require_once __DIR__."/../models/_admins.php";
require_once __DIR__."/../models/_usuarios.php";


$comprobacion = new clase_comprobaciones;
$lang = $_COOKIE["cookie_custom_lang"] ?? "es";
$translate_path = __DIR__ . "/../config/languages/remember-password/$lang.json";
if (isset($_POST)) {
    $email = $_POST["email"];
    $exists_file = file_exists($translate_path);
    $translate_messages = $exists_file ?  file_get_contents($translate_path) : null;
    $translate_messages = $translate_messages ? json_decode($translate_messages) : null;
    $errors = $translate_messages ? $translate_messages->errors : null;
    //Comprobaciones
    //Vacía
    if (empty($email)) {
        $fallo = true;
        $mensaje = $errors?->empty_email ?? "Empty email";
        $campo = "email_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "empty_email");
    }
    // NÚMERO
    if (is_numeric($email)) {
        $fallo = true;
        $mensaje =  $errors?->numeric_email ?? "The email cannot be a number";
        $campo = "email_error";
        devolver_respuesta($mensaje, $fallo, $campo, data_lang: "numeric_email");
    }
    // >100
    $numCaracteres = strlen($email);
    if ($numCaracteres > 200) {
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

    //  Comprobamos si existe el usuario con el email desde las credenciales
    $crendencial = Credencial::where("email_login", $email);
    if (!$crendencial) {
        // Verificamos si existe un usuario con ese email en la tabla admins
        $admin = Admin::where("email", $email);
        if ($admin) {
            $user_name = $admin->nombre;
            $id_usuario = $admin->id_admin;
        } else {
            //Si no existe, comprobar si existe el usuario con el email desde la API
            $user = UsersRepository::findByEmail($email);
            // Si el usuario no existe en la API devolver una respuesta de error al cliente
            if (!$user) {
                devolver_respuesta(
                    fallo: true,
                    mensaje: $errors?->email_not_register ?? "Email not registered. Please check it or contact technical support.",
                    campo: "email_error",
                    code: 401,
                    data_lang: "email_not_register"
                );
            }
            // Comprobamos si ya existe un usuario con ese id en la tabla credenciales.
            $crendencial = Credencial::where("id_usuario", $user->id_user);

            if ($crendencial) {
                // Si existe, actualizamos su correo electrónico con el proporcionado por la API
                $crendencial->email_login = $user->email;
                $crendencial->save();
                $user_name = $user->name;
                $usuario = Usuario::where("id_usuario", $user->id_user);
                $usuario->email = $user->email;
                $usuario->save();
            } else {
                //Si no existe, creamos un nuevo registro en la tabla usuarios con los datos de la API
                $user = UsersRepository::findByID($user->id_user);
                if (!$user) {
                    devolver_respuesta(
                        fallo: true,
                        mensaje: $errors?->register_error ?? "Registration error. Please contact technical support.",
                        campo: "email_error",
                        code: 500
                    );
                }
                $usuario = new Usuario([
                    "id_usuario" => $user->id_user,
                    "num_socio" => $user->membership_number,
                    "nombre" => $user->first_name,
                    "apellidos" => $user->last_name,
                    "email" => $user->email,
                    "telefono" => $user->mobile,
                ]);
                if (!$usuario->create()) {
                    devolver_respuesta(
                        fallo: true,
                        mensaje: $errors?->register_error ?? "Registration error. Please contact technical support.",
                        campo: "email_error",
                        code: 500
                    );
                }
                $id_usuario = $usuario->id_usuario;
                $user_name = $usuario->nombre;
            }
        }
        // Si se ha creado un nuevo usuario, creamos credenciales
        if (isset($id_usuario)) {
            $role = $admin ? ROLES::ADMIN : ROLES::USER;
            $crendencial = Credencial::createCredential($id_usuario, $email, $role);

            if (!$crendencial) {
                devolver_respuesta(
                    fallo: true,
                    mensaje: $errors?->register_error ?? "Registration error. Please contact technical support.",
                    campo: "email_error",
                    code: 500
                );
            }
        }
    } else {
        // Si el usuario ya tiene credenciales, obtenemos su nombre según el rol
        if ($crendencial->id_rol == ROLES::ADMIN->value) {
            $admin = Admin::where("email", $email);
            $user_name = $admin?->nombre;
        } else {
            $user = Usuario::where("email", $email);
            $user_name = $user?->nombre;
        }
    }
    // Si no encontramos un nombre de usuario, error
    if (!isset($user_name) || is_null($user_name)) {
        devolver_respuesta(
            fallo: true,
            mensaje: $errors?->username_error ?? "Error retrieving user. Contact technical support.",
            campo: "email_error",
            code: 500
        );
    }
    // Enviamos el email con el token de acceso
    $crendencial->sendMailWithToken($user_name);
    devolver_respuesta(
        fallo: false,
        mensaje: $translate_messages?->success ?? "Check your email inbox.",
        campo: "email_error",
        code: 201,
        data_lang: "success"
    );
}
