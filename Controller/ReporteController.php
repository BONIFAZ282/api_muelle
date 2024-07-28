<?php

class ReporteController
{

    public function LISTAR_GANANCIAS_REPORTE()
    {
        try {
            $query = Flight::db()->prepare("CALL PROC_GANANCIAS_REPORTE()");
            $query->execute();
            $result = $query->fetchAll(PDO::FETCH_ASSOC);
            Flight::json($result);
        } catch (Exception $e) {
            Flight::json(array("message" => $e->getMessage()), 500);
        }
    }
    

}