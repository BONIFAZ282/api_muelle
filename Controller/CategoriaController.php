<?php

class CategoriaController
{
    public function LISTAR_CATEGORIAS()
    {
        $query = Flight::db()->prepare("CALL PROC_CATEGORIA_LIST()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    public function CREAR_CATEGORIA()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_CATEGORIA_CREAR(:NOM_CATEGORIA)");
            $query->execute([
                "NOM_CATEGORIA" => $data->NOM_CATEGORIA
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

    public function ACTUALIZAR_CATEGORIA()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_CATEGORIA_ACTUALIZAR(:ID_CATEGORIA, :NOM_CATEGORIA)");
            $query->execute([
                "ID_CATEGORIA" => $data->ID_CATEGORIA,
                "NOM_CATEGORIA" => $data->NOM_CATEGORIA
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

    public function ELIMINAR_CATEGORIA()
    {
        $response = null;

        try {
            $data = Flight::request()->data;

            $query = Flight::db()->prepare("CALL PROC_CATEGORIA_ELIMINAR(:ID_CATEGORIA)");
            $query->execute([
                "ID_CATEGORIA" => $data->ID_CATEGORIA
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
