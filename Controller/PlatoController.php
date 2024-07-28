    <?php

    class PlatoController
    {
        public function LISTAR_PLATOS()
        {
            $query = Flight::db()->prepare("CALL PROC_PLATO_LIST()");
            $query->execute();
            $result = $query->fetchAll(PDO::FETCH_ASSOC);

            // Imprimimos en JSON
            Flight::json($result);
        }

        public function CREAR_PLATO()
        {
            $response = null;

            try {
                $data = Flight::request()->data;

                $query = Flight::db()->prepare("CALL PROC_PLATO_CREAR(:ID_CATEGORIA, :NOMBRE, :DESCRIPCION, :PRECIO)");
                $query->execute([
                    "ID_CATEGORIA" => $data->ID_CATEGORIA,
                    "NOMBRE" => $data->NOMBRE,
                    "DESCRIPCION" => $data->DESCRIPCION,
                    "PRECIO" => $data->PRECIO
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

        public function ACTUALIZAR_PLATO()
        {
            $response = null;

            try {
                $data = Flight::request()->data;

                $query = Flight::db()->prepare("CALL PROC_PLATO_ACTUALIZAR(:ID_PLATO, :ID_CATEGORIA, :NOMBRE, :DESCRIPCION, :PRECIO)");
                $query->execute([
                    "ID_PLATO" => $data->ID_PLATO,
                    "ID_CATEGORIA" => $data->ID_CATEGORIA,
                    "NOMBRE" => $data->NOMBRE,
                    "DESCRIPCION" => $data->DESCRIPCION,
                    "PRECIO" => $data->PRECIO
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

        public function ELIMINAR_PLATO()
        {
            $response = null;

            try {
                $data = Flight::request()->data;

                $query = Flight::db()->prepare("CALL PROC_PLATO_ELIMINAR(:ID_PLATO)");
                $query->execute([
                    "ID_PLATO" => $data->ID_PLATO
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
