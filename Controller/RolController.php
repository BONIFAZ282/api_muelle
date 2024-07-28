<?php

class RolController
{
    public function LISTAR_ROLES()
    {
        $query = Flight::db()->prepare("CALL PROC_ROL_LIST()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    public function CREAR_ROL()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_ROL_CREAR(:NOM_ROL)");
            $query->execute([
                "NOM_ROL" => $data->NOM_ROL
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

    public function ACTUALIZAR_ROL()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_ROL_ACTUALIZAR(:ID_ROL, :NOM_ROL)");
            $query->execute([
                "ID_ROL" => $data->ID_ROL,
                "NOM_ROL" => $data->NOM_ROL
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

    public function ELIMINAR_ROL()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_ROL_ELIMINAR(:ID_ROL)");
            $query->execute([
                "ID_ROL" => $data->ID_ROL
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
