<?php

class TrabajadorController
{
    public function LISTAR_TRABAJADORES()
    {
        $query = Flight::db()->prepare("CALL PROC_TRABAJADOR_LIST()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        Flight::json($result);
    }

    public function CREAR_TRABAJADOR()
    {
        $response = null;
    
        try {
            $data = Flight::request()->data;
    
            $query = Flight::db()->prepare("CALL PROC_TRABAJADOR_CREAR(:NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CORREO, :TELEFONO, :ID_ROL, :CONTRASENIA)");
            $query->execute([
                "NOMBRES" => $data->NOMBRES,
                "APPATERNO" => $data->APPATERNO,
                "APMATERNO" => $data->APMATERNO,
                "DOCUMENTO" => $data->DOCUMENTO,
                "CORREO" => $data->CORREO,
                "TELEFONO" => $data->TELEFONO,
                "ID_ROL" => $data->ID_ROL,
                "CONTRASENIA" => $data->CONTRASENIA
            ]);
    
            $result = $query->fetchAll(PDO::FETCH_ASSOC);
    
            $response = array(
                "icon" => $result[0]["ICON"],
                "title" => "MENSAJE DEL SISTEMA",
                "text" => $result[0]["MESSAGE_TEXT"],
                "statusCode" => $result[0]["STATUS_CODE"]
            );
        } catch (Exception $err) {
            $response = array(
                "icon" => "error",
                "title" => "MENSAJE DEL SISTEMA",
                "text" => $err->getMessage(),
                "statusCode" => "500",
                "data" => null
            );
        }
    
        Flight::json($response, intval($response["statusCode"]));
    }

    public function ACTUALIZAR_TRABAJADOR()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_TRABAJADOR_ACTUALIZAR(:ID_TRABAJADOR, :NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CORREO, :TELEFONO, :ID_ROL, :ID_PRIVILEGIO, :CONTRASENIA)");
            $query->execute([
                "ID_TRABAJADOR" => $data->ID_TRABAJADOR,
                "NOMBRES" => $data->NOMBRES,
                "APPATERNO" => $data->APPATERNO,
                "APMATERNO" => $data->APMATERNO,
                "DOCUMENTO" => $data->DOCUMENTO,
                "CORREO" => $data->CORREO,
                "TELEFONO" => $data->TELEFONO,
                "ID_ROL" => $data->ID_ROL,
                "ID_PRIVILEGIO" => $data->ID_PRIVILEGIO,
                "CONTRASENIA" => $data->CONTRASENIA
            ]);

            $result = $query->fetchAll(PDO::FETCH_ASSOC);

            $response = array(
                "icon" => $result[0]["ICON"],
                "title" => "MENSAJE DEL SISTEMA",
                "text" => $result[0]["MESSAGE_TEXT"],
                "statusCode" => $result[0]["STATUS_CODE"]
            );
        } catch (Exception $err) {
            $response = array(
                "icon" => "error",
                "title" => "MENSAJE DEL SISTEMA",
                "text" => $err->getMessage(),
                "statusCode" => "500",
                "data" => null
            );
        }

        Flight::json($response, intval($response["statusCode"]));
    }

    public function ELIMINAR_TRABAJADOR_DEFINITIVO()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_TRABAJADOR_ELIMINAR_DEFINITIVO(:ID_TRABAJADOR)");
            $query->execute(["ID_TRABAJADOR" => $data->ID_TRABAJADOR]);

            $response = array(
                "icon" => "success",
                "title" => "MENSAJE DEL SISTEMA",
                "text" => "Trabajador eliminado definitivamente",
                "statusCode" => "200"
            );
        } catch (Exception $err) {
            $response = array(
                "icon" => "error",
                "title" => "MENSAJE DEL SISTEMA",
                "text" => $err->getMessage(),
                "statusCode" => "500",
                "data" => null
            );
        }

        Flight::json($response, intval($response["statusCode"]));
    }

    public function TOTAL_TRABAJADORES()
    {
        $query = Flight::db()->prepare("CALL PROC_TOTAL_TRABAJADORES()");
        $query->execute();
        $result = $query->fetch(PDO::FETCH_ASSOC);

        Flight::json($result);
    }

    public function TRABAJADORES_POR_ROL()
    {
        $query = Flight::db()->prepare("CALL PROC_TRABAJADORES_POR_ROL()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        Flight::json($result);
    }

    public function LISTAR_MESEROS()
    {
        $query = Flight::db()->prepare("CALL PROC_MESERO_LIST()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        Flight::json($result);
    }
}
