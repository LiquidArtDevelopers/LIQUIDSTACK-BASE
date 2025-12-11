<?php

require_once __DIR__ . "/../app/_conexionBBDD.php";
require_once __DIR__ . "/_activeRecord.php";

ActiveRecord::setConectionDB($con);

class Credencial extends ActiveRecord
{
    public static ?string $table = "ls_credenciales";
    public string $id_name = "id_credencial";
    public  $id_credencial;
    public  $id_admin;
    public  $id_usuario;
    public $email_login;
    public $password;
    public $token;
    public $token_data_limit;
    public $last_conection;
    public $id_rol;

    public function __construct($data = [])
    {

        $this->id_credencial = $data["id_credencial"] ?? null;
        $this->id_usuario = $data["id_usuario"] ?? null;
        $this->id_admin = $data["id_admin"] ?? null;
        $this->email_login = $data["email_login"] ?? null;
        $this->password = $data["password"] ?? "";
        $this->token = $data["token"] ?? "";
        $this->token_data_limit = $data["token_data_limit"] ?? "";
        $this->last_conection = $data["last_conection"] ?? null;
        $this->id_rol = $data["id_rol"] ?? null;
    }

    public static function createCredential($id_usuario, $email, Roles $role): Credencial | null
    {
        $credential = new Credencial();
        $credential->id_usuario = $id_usuario;
        $credential->email_login = $email;
        $credential->last_conection = date("Y-m-d H:i:s");
        $credential->id_rol = $role->value;
        if ($credential->save()) {
            return $credential;
        }
        return null;
    }

    private  function createToken(int $dias_expiracion = 2)
    {
        $token = bin2hex(random_bytes((20 - (20 % 2)) / 2));
        $fecha_actual = date("Y-m-d");
        //sumo 2 día2
        $caducidad = date("Y-m-d", strtotime($fecha_actual . "+ " . $dias_expiracion . " days"));
        $this->token = $token;
        $this->token_data_limit = $caducidad;
    }

    public function isTokenExpired(): bool
    {
        // Obtener la fecha actual
        $fecha_actual = date("Y-m-d");
        // Comparar si la fecha actual es posterior a la fecha de caducidad
        return ($fecha_actual > $this->token_data_limit);
    }
    public function hash_password()
    {
        $this->password = password_hash($this->password, PASSWORD_BCRYPT);
    }
    public function verifyPassword(string $password): bool
    {
        return password_verify($password, $this->password);
    }
    public function sendMailWithToken($nombreDestinatario)
    {
        if (!$this->email_login) {
            throw new Exception("No se pudo obtener el mail para enviar el token en recordar contraseña.");
        }

        $this->createToken();
        $this->save();
        $correoEmisor = $_ENV["MAIL_WEB"];
        $nombreEmisor = "ATSS";
        $destinatario = $this->email_login;
        $lang = $_COOKIE['cookie_custom_lang'] ?? $_ENV['LANG_DEFAULT'];
        $asunto = match ($lang) {
            "es" => "ATSS - Acceso Temporal",
            "eu" => "ATSS - Aldi baterako sarbidea",
            default => "ATSS - Temporary access"
        };
        $route_token = getMatchRouteByLang("/es/restablecer-contraseña?t={token}", $lang);
        if (!$route_token) {
            $fallbacks = [
                "es" => "/es/restablecer-contraseña?t={token}",
                "eu" => "/eu/berrezarpen-pasahitza?t={token}",
            ];
            $route_token = $fallbacks[$lang] ?? "/$lang/restablecer-contraseña?t={token}";
        }
        $route_token = str_replace("{token}", $this->token, $route_token);
        $root = rtrim($_ENV['RAIZ'] ?? (isset($_SERVER['HTTP_HOST']) ? 'https://' . $_SERVER['HTTP_HOST'] : ''), '/');
        $link = $root . $route_token;
        $cuerpo = file_get_contents(__DIR__ . "/../templates/$lang/remember-password.html");
        $cuerpo = str_replace(["{asunto}", "{nombreDestinatario}", "{link}"], [$asunto, $nombreDestinatario, $link], $cuerpo);
        require_once "../App/app/_phpmailer.php";
    }
}
