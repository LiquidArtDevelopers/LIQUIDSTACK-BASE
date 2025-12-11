<?php

require_once __DIR__."/../config/config.php";
require_once __DIR__."/../class/_comprobaciones.php";
$comprobacion = new clase_comprobaciones;

if(isset($_POST)){ 

    $ip = $_SERVER['REMOTE_ADDR'];
    $datetime = date("H:i:s d-m-Y ");

    $nombre = $_POST["nombre"];
    $correo = $_POST["correo"];

    $respuesta = $_POST["respuestaLittle"];
    $solucion = $_POST["solucionLittle"];

    $lang = $_POST["lang"];

    //COMPROBACIÓN DE LANG
    $langs= require(__DIR__.'/../config/langs.php');
    if(!in_array($lang, $langs)){
        $lang="es";
    }
    //--

    //LIQUID CAPTCHA
    //VACÍO
    if(empty($respuesta) || empty($solucion)){
        $fallo = true;
        $mensaje = "Debes resolver la operación";
        $campo = "captcha_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    //MAL RESUELTA
    if($respuesta != $solucion){
        $fallo = true;
        $mensaje = "Debes resolver correctamente la operación";
        $campo = "captcha_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }

    /* REVISIÓN CAMPO NOMBRE */
    /* comprobar que no venga vacío */
    if(empty($nombre)){
        $fallo = true;
        $mensaje = "Debes escribir un nombre";
        $campo = "nombre_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    // NÚMERO
    if(is_numeric($nombre)){
        $fallo = true;
        $mensaje = "El nombre no puede ser un número";
        $campo = "nombre_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    // 4-40
    $numCaracteres = strlen($nombre);
    if($numCaracteres < 3 || $numCaracteres > 40){
        $fallo = true;
        $mensaje = "El nombre debe tener entre 3 y 40 caracteres máximo";
        $campo = "nombre_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    // CLEAN
    $nombre = $comprobacion->filtrarValor($nombre);

   


    // CORREO
    // VACÍO (no obligatorio)
    if(empty($correo)){
        $fallo = true;
        $mensaje = "El campo del correo no puede quedar vacio";
        $campo = "correo_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    // NÚMERO
    if(is_numeric($correo)){
        $fallo = true;
        $mensaje = "El correo no puede ser un número";
        $campo = "correo_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    // >100
    $numCaracteres = strlen($correo);
    if($numCaracteres > 100){
        $fallo = true;
        $mensaje = "El correo debe tener 100 caracteres máximo";
        $campo = "correo_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    // VALID
    if($comprobacion->validar_email($correo)==0 && !empty($correo)){
        $fallo = true;
        $mensaje = "El correo no tiene una sintaxis correcta";
        $campo = "correo_error_little";
        devolver_respuesta($mensaje, $fallo, $campo);
    }
    // CLEAN
    $correo = $comprobacion->filtrarValor($correo);
    $correo = $comprobacion->minusculas($correo);



    //**** PHPMAILER ****
    //ADMIN
    $correoEmisor= $_ENV['MAIL_WEB'];
    $nombreEmisor ="Hettich WEB";
    $destinatario = $_ENV['MAIL_ADMIN'];
    $nombreDestinatario = "Hettich";
    $asunto = "[Hettich] Nuevo suscriptor web: $nombre";
    $cuerpo = '
    <html> 
        <head> 
            <title>'.$asunto.'</title>
        </head> 
        <body style="font-family:Arial; font-size:18px;">
            <div style="text-align:center;width:100%;padding:50px;height:500px;background-image:url(\'cid:fondo\');background-size:cover;">
                <a href="https://hettich-iberia.com" target="_blank"><img src="cid:logotipo" style="width: 150px;"></a>    
                <h1 style="font-size:50px;color:#005699;">Hola, '.$nombreDestinatario.'!</h1>
                <p style="font-size:40px;">Has recibido un nuevo suscriptor a través de la web.</p>               
            </div>
            <div align="left" style="width:30%; min-width:300px; margin:30px">
                <p style="margin-top: 50px;">A continuación dispone de todos los datos del suscriptor. El usuario ha aceptado la política de privacidad a través del formulario desde el que ha hecho esta consulta.</p>

                <table>
                    <thead>
                        <tr>
                            <th colspan="2">Datos del suscriptor</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Suscriptor:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$nombre.'</td>
                        </tr>
                        <tr>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Correo electrónico:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$correo.'</td>
                        </tr>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Resgistrado el:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$datetime.'</td>
                        </tr>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Idioma elegido en la web:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$lang.'</td>
                        </tr>
                    </tbody>
                </table>

                <p style="margin-top: 100px;">Un saludo,</p>
                <p><i>Equipo de Hettich</i></p>                
                <a href="https://hettich-iberia.com" target="_blank">hettich-iberia.com</a>
            </div>
        </body> 
    </html>';
    include './App/app/_phpmailer.php';

    //**** PHPMAILER ****
    //USUARIO SUSCRITO
    $correoEmisor= $_ENV['MAIL_WEB'];
    $nombreEmisor ="Hettich WEB";
    $destinatario = $correo;
    $nombreDestinatario = $nombre;
    $asunto = "[Hettich] Hemos recibido su suscripción, $nombre";
    $cuerpo = '
    <html> 
        <head> 
            <title>'.$asunto.'</title>
        </head> 
        <body style="font-family:Arial; font-size:18px;">
            <div style="text-align:center;width:100%;padding:50px;height:500px;background-image:url(\'cid:fondo\');background-size:cover;">
                <a href="https://hettich-iberia.com" target="_blank"><img src="cid:logotipo" style="width: 150px;"></a>    
                <h1 style="font-size:50px;color:#005699;">Hola, '.$nombreDestinatario.'!</h1>
                <p style="font-size:40px;">Está suscrito a nuestras novedades.</p>               
            </div>
            <div align="left" style="width:30%; min-width:300px; margin:30px">
                <p style="margin-top: 50px;">A continuación dispone de todos los datos que nos ha facilitado.
                <table>
                    <thead>
                        <tr>
                            <th colspan="2">Datos recibidos</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Suscriptor:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$nombre.'</td>
                        </tr>
                        <tr>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Correo electrónico:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$correo.'</td>
                        </tr>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Resgistrado el:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$datetime.'</td>
                        </tr>
                        <tr>
                            <td style="padding:10px;border:1px solid #b1b1b1"><b>Idioma elegido en la web:</b></td>
                            <td style="padding:10px;border:1px solid #b1b1b1">'.$lang.'</td>
                        </tr>
                    </tbody>
                </table>

                <p style="margin-top: 100px;">Un saludo,</p>
                <p><i>Equipo de Hettich</i></p>                
                <a href="https://hettich-iberia.com" target="_blank">hettich-iberia.com</a>
            </div>
        </body> 
    </html>';
    include './App/app/_phpmailer.php';

    

    
    sleep(2);
    $fallo = false;
    $mensaje="El formulario se ha enviado con éxito";
    $campo = "";
    devolver_respuesta($mensaje, $fallo, $campo);

}else{

    // NO ENTRA POR POST
    $fallo = true;
    $mensaje = "No se están recibiendo datos del formulario";
    $campo = "terminos_error_little";
    devolver_respuesta($mensaje, $fallo, $campo);
}

/* FUNCIONES-------- */
function devolver_respuesta($mensaje, $fallo, $campo){
    $arrayRespuesta = array(
        'mensaje' => $mensaje,
        'fallo' => $fallo,
        'campo' => $campo
    );
    $jsonDelArray = json_encode($arrayRespuesta);
    if($fallo){
        http_response_code("400");
    }
    echo $jsonDelArray;
    die;
}

?>