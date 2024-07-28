<?php

class PrivilegioController
{
    public function LISTAR_PRIVILEGIOS()
    {
        $query = Flight::db()->prepare("CALL PROC_PRIVILEGIO_LIST()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    public function CREAR_PRIVILEGIO()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_PRIVILEGIO_CREAR(:NOM_PRIVILEGIO)");
            $query->execute([
                "NOM_PRIVILEGIO" => $data->NOM_PRIVILEGIO
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

    public function ACTUALIZAR_PRIVILEGIO()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_PRIVILEGIO_ACTUALIZAR(:ID_PRIVILEGIO, :NOM_PRIVILEGIO)");
            $query->execute([
                "ID_PRIVILEGIO" => $data->ID_PRIVILEGIO,
                "NOM_PRIVILEGIO" => $data->NOM_PRIVILEGIO
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

    public function ELIMINAR_PRIVILEGIO()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_PRIVILEGIO_ELIMINAR(:ID_PRIVILEGIO)");
            $query->execute([
                "ID_PRIVILEGIO" => $data->ID_PRIVILEGIO
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
