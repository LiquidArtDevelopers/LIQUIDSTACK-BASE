<?php
class ActiveRecord
{
    protected static $conn;
    public static ?string $table = null;
    public  string $id_name;


    public static function consultarSQL($stmt): array
    {
        $stmt->execute();
        $result = $stmt->get_result();
        // Iterar los resultados
        $array = [];
        while ($registro = $result->fetch_assoc()) {
            $array[] = static::crearObjeto($registro);
        }
        // liberar la memoriaw
        $stmt->free_result();
        // retornar los resultados
        return $array;
    }

    // Crea el objeto en memoria que es igual al de la BD
    protected static function crearObjeto($registro): ActiveRecord
    {
        $objeto = new static;
        foreach ($registro as $key => $value) {
            if (property_exists($objeto, $key)) {
                $objeto->$key = $value;
            }
        }
        return $objeto;
    }
    // crear o actualizar objeto en la base de datos
    public function save(): bool
    {
        $id = $this->id_name;
        if (!is_null($this->$id)) {
            // actualizar
            $resultado = $this->update();
        } else {
            // Creando un nuevo registro
            $resultado = $this->create();
        }
        return $resultado;
    }

    public static function all($order = [
        "desc" => true,
        "order_by" => []
    ]): array
    {
        if (is_null(static::$table)) {
            throw new Exception("El método all no puede acceder al nombre de la tabla en ActiveRecord");
        }

        // Consulta SQL para obtener todos los registros
        $query = "SELECT * FROM " . static::$table;
        $query .= (isset($order["order_by"]) && count($order["order_by"])) ? " ORDER BY " . join(" ,", $order["order_by"]) . " ;" : ";";
        $stmt = mysqli_prepare(self::$conn, $query);

        // Ejecutar la consulta y obtener los resultados
        $result = self::consultarSQL($stmt);

        // Retornar todos los objetos correspondientes a los registros
        return ($result);
    }
    // crea un nuevo registro
    public function create(): bool
    {
        $attributes = self::getAtributos();
        $id = $this->id_name;
        if (!is_null($this->$id)) {
            $attributes[$id] = $this->$id;
        }
        // Insertar en la base de datos
        $query = " INSERT INTO " . static::$table . " ( ";
        $query .= join(', ', array_keys($attributes));
        $query .= " ) VALUES (";
        $query .= join(", ", array_fill(0, count(array_keys($attributes)), '?'));
        $query .= ");";
        $stmt = mysqli_prepare(self::$conn, $query);
        $types = $this->types ?? str_repeat("s", count($attributes));
        $stmt->bind_param($types, ...array_values($attributes));
        if ($stmt->execute()) {
            if (!$this->$id)   $this->$id =  mysqli_insert_id(self::$conn);
            $stmt->free_result();
            return true;
        }
        $stmt->free_result();
        return false;
    }
    // Identificar y unir los atributos de la BD
    private function getAtributos()
    {
        $atributos = [];
        $columnsDB = self::getColums();
        foreach ($columnsDB as $columna) {
            if ($columna === $this->id_name) continue;
            $atributos[$columna] = $this->$columna;
        }
        return $atributos;
    }
    public function update(): bool
    {
        $id = $this->id_name;
        $attributes = $this->getAtributos();
        $attributesWithParams = array_map(fn($key) => "{$key}=?", array_keys($attributes));
        // Consulta SQL
        $query = "UPDATE " . static::$table . " SET ";
        $query .=  join(', ', $attributesWithParams);
        $query .= " WHERE " . $id . "=" . $this->$id;
        $query .= " LIMIT 1;";

        $stmt = mysqli_prepare(self::$conn, $query);
        $types = $this->types ?? str_repeat("s", count($attributes));
        $stmt->bind_param($types, ...array_values($attributes));
        $executed = $stmt->execute();
        if ($executed) {
            $stmt->free_result();
            return mysqli_affected_rows(self::$conn);
        }
        $stmt->free_result();
        return false;
    }

    public static function where(string $column, string $value)
    {
        $model = new static;
        if (!isset($model::$table)) {
            throw new Exception("El método where no puede acceder al nombre de la tabla en ActiveRecord");
        }
        $query = "SELECT *  FROM " . $model::$table . " WHERE $column=?;";
        $stmt = mysqli_prepare(self::$conn, $query);
        $stmt->bind_param('s', $value);
        $result = self::consultarSQL($stmt);
        $model = array_shift($result);
        return $model;
    }

    public static function setConectionDB($conn)
    {
        self::$conn = $conn;
    }
    // Eliminar un Registro por su ID
    public function delete()
    {
        $id_name = $this->id_name;
        $query = "DELETE FROM "  . static::$table . " WHERE $id_name = ? LIMIT 1;";
        $stmt = mysqli_prepare(self::$conn, $query);
        $stmt->bind_param("s", $this->$id_name);
        if ($stmt->execute()) {
            $stmt->free_result();
            $rows_affected = mysqli_affected_rows(self::$conn);
            if ($rows_affected > 0) return true;
        }
        return false;
    }

    public static function getColums()
    {
        $query = "SELECT * FROM " . static::$table . "  LIMIT 1";
        $result = mysqli_query(self::$conn, $query);

        if ($result) {
            $columns = [];
            while ($field = $result->fetch_field()) {
                $columns[] = $field->name;
            }
            // Liberar el resultado
            $result->free();
            return $columns;
        }
        return [];
    }
}
