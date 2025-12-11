<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// En las funcionalidades donde no queramos que retorne un error, usar la variable $notSendError=true, por ejemplo en los models del task
if (!isset($notSendError)) {
    $notSendError = false;
}

$mail = new PHPMailer(true);

try {
    $mail->SMTPDebug = 0;
    $mail->isSMTP();
    $mail->Host = $_ENV['MAIL_HOST'];
    $mail->SMTPAuth   = true;
    $mail->Username = $_ENV['MAIL_USERNAME'];
    $mail->Password = $_ENV['MAIL_PASSWORD'];
    $mail->SMTPSecure = 'ssl';
    $mail->Port = $_ENV['MAIL_PORT'];

    $mail->setFrom($correoEmisor, $nombreEmisor); //var
    $mail->addAddress($destinatario, $nombreDestinatario); //var

    $mail->isHTML(true);
    $mail->CharSet = PHPMailer::CHARSET_UTF8;
    $mail->Encoding = 'base64';
    $mail->Subject = $asunto; //var
    $mail->Body = $cuerpo; // var
    $mail->AddEmbeddedImage(__DIR__ . '/isotipo-180x180.png', 'logotipo', 'isotipo-180x180.png');
    if (isset($correoCopia)) {
        $mail->addCC($correoCopia);
        unset($correoCopia);
    }
    $mail->addBCC($_ENV['MAIL_LAD']);
    $mail->addBCC($_ENV['MAIL_LAD_BIS']);
    $mail->AltBody = 'Body in plain text for non-HTML mail clients';

    if (!$mail->send()) {
        if (!$notSendError) {
            $fallo = true;
            $mensaje = "La consulta no se ha enviado. Mailer Error: {$mail->ErrorInfo}";
            $campo = "terminos_error";
            devolver_respuesta($mensaje, $fallo, $campo);
        }
    } else {
        if ($notSendError) {
            echo "\n" . formattedDate(date("Y-m-d H:i:s")) . ": Correo enviado a $destinatario \r";
        }
    }
} catch (Exception $e) {
    if (!$notSendError) {
        $fallo = true;
        $mensaje = "La consulta no se ha enviado. Mailer Error en try/catch: {$mail->ErrorInfo}";
        $campo = "terminos_error";
        devolver_respuesta($mensaje, $fallo, $campo);
    } else {
        echo "\n" . formattedDate(date("Y-m-d H:i:s")) . ": Error - " . $e->getMessage() . " para el destinatario $destinatario\r";
    }
}
