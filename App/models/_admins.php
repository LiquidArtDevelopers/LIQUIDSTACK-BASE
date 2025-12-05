<?php
require_once __DIR__ . "/../app/_conexionBBDD.php";
require_once __DIR__ . "/_activeRecord.php";


ActiveRecord::setConectionDB($con);
class Admin extends ActiveRecord
{
    public static ?string $table = "ls_admins";
    public  string $id_name = "id_admin";
    public $id_admin;
    public $nombre;
    public $email;
    public $telefono;

    public function __construct($data = [])
    {

        $this->id_admin = $data["id_admin"] ?? null;
        $this->nombre = $data["nombre"] ?? null;
        $this->email = $data["email"] ?? null;
        $this->telefono = $data["telefono"] ?? null;
    }
}
