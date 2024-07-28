<?php

class PedidoController
{
    public function CREAR_PEDIDO()
    {
        $response = null;

        try {
            $data = Flight::request()->data;
            $query = Flight::db()->prepare("CALL PROC_PEDIDO_CREAR(:ID_MESA, :ID_TRABAJADOR, :F_PEDIDO, :ESTADO, :DETALLES, @ID_PEDIDO, @ICON, @MESSAGE_TEXT, @STATUS_CODE)");
            $query->execute([
                "ID_MESA" => $data->ID_MESA,
                "ID_TRABAJADOR" => $data->ID_TRABAJADOR,
                "F_PEDIDO" => $data->F_PEDIDO,
                "ESTADO" => $data->ESTADO,
                "DETALLES" => json_encode($data->DETALLES)
            ]);

            $output = Flight::db()->query("SELECT @ID_PEDIDO AS ID_PEDIDO, @ICON AS ICON, @MESSAGE_TEXT AS MESSAGE_TEXT, @STATUS_CODE AS STATUS_CODE")->fetch(PDO::FETCH_ASSOC);

            $response = array(
                "ID_PEDIDO" => $output['ID_PEDIDO'],
                "icon" => $output['ICON'],
                "title" => "MENSAJE DEL SISTEMA",
                "text" => $output['MESSAGE_TEXT'],
                "statusCode" => $output['STATUS_CODE']
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

    public function LISTAR_PEDIDOS()
    {
        $query = Flight::db()->prepare("CALL PROC_PEDIDOS_LIST()");
        $query->execute();
        $result = $query->fetchAll(PDO::FETCH_ASSOC);

        // Imprimimos en JSON
        Flight::json($result);
    }

    public function VER_DETALLE_PEDIDO()
    {
        $response = null;

        try {
            $data = Flight::request()->data;
            $query = Flight::db()->prepare("CALL PROC_PEDIDO_DETALLE(:ID_PEDIDO)");
            $query->execute([
                "ID_PEDIDO" => $data->ID_PEDIDO
            ]);

            $result = $query->fetchAll(PDO::FETCH_ASSOC);

            $response = $result;
        } catch (Exception $err) {
            $response = array(
                "icon" => "error",
                "title" => "MENSAJE DEL SISTEMA",
                "text" => $err->getMessage(),
                "statusCode" => "500",
                "data" => null
            );
        }

        Flight::json($response);
    }

    public function CAMBIAR_ESTADO_PEDIDO()
    {
        $response = null;

        try {
            $data = Flight::request()->data;
            $query = Flight::db()->prepare("CALL PROC_CAMBIAR_ESTADO_PEDIDO(:ID_PEDIDO, :ESTADO)");
            $query->execute([
                "ID_PEDIDO" => $data->ID_PEDIDO,
                "ESTADO" => $data->ESTADO
            ]);

            $response = array(
                "icon" => "success",
                "title" => "MENSAJE DEL SISTEMA",
                "text" => "Estado del pedido actualizado",
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
}
