<?php

class MesaController
{
    public function LISTAR_MESAS()
    {
        $query = Flight::db()->prepare("CALL PROC_MESA_LIST()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    public function CREAR_MESA()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_MESA_CREAR(:NUMERO, :CAPACIDAD)");
            $query->execute([
                "NUMERO" => $data->NUMERO,
                "CAPACIDAD" => $data->CAPACIDAD
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

    public function ACTUALIZAR_MESA()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_MESA_ACTUALIZAR(:ID_MESA, :NUMERO, :CAPACIDAD)");
            $query->execute([
                "ID_MESA" => $data->ID_MESA,
                "NUMERO" => $data->NUMERO,
                "CAPACIDAD" => $data->CAPACIDAD
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

    public function ELIMINAR_MESA()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_MESA_ELIMINAR(:ID_MESA)");
            $query->execute([
                "ID_MESA" => $data->ID_MESA
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
}
