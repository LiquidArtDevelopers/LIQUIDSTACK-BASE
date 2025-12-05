<?php
require_once __DIR__ . "/../app/_conexionBBDD.php";
require_once __DIR__ . "/_activeRecord.php";


ActiveRecord::setConectionDB($con);
class Usuario extends ActiveRecord
{
    public static ?string $table = "ls_usuarios";
    public  string $id_name = "id_usuario";
    public $id_usuario;
    public $num_socio;
    public $nombre;
    public $apellidos;
    public $email;
    public $telefono;

    public function __construct($data = [])
    {
        $this->id_usuario = $data["id_usuario"] ?? null;
        $this->num_socio = $data["num_socio"] ?? null;
        $this->nombre = $data["nombre"] ?? null;
        $this->apellidos = $data["apellidos"] ?? null;
        $this->email = $data["email"] ?? null;
        $this->telefono = $data["telefono"] ?? null;
    }
}
