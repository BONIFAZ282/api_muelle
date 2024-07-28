<?php

class UsuarioController
{
  public function LISTAR_USUARIOS()
  {
    $query = Flight::db()->prepare("CALL PROC_USUARIO_LIST()");
    $query->execute();
    $result = $query->fetchAll(PDO::FETCH_ASSOC);

    // Imprimimos en JSON
    Flight::json($result);
  }

  public function LOGIN_USUARIO()
  {
    $data = Flight::request()->data;

    try {
      $query = Flight::db()->prepare("CALL PROC_USUARIO_LOGIN(:DOCUMENTO, :CONTRASENIA)");
      $query->execute([
        "DOCUMENTO" => $data->DOCUMENTO,
        "CONTRASENIA" => $data->CONTRASENIA
      ]);

      $result = $query->fetchAll(PDO::FETCH_ASSOC);

      if (count($result) > 0) {
        $tk = new Token();
        $jwt = $tk->generarToken(sha1($result[0]["NOMBRES"]), 1);

        // Añadir el token al resultado
        $result[0]["token"] = $jwt;
      } else {
        $result = [
          "message" => "Usuario o contraseña incorrectos",
          "statusCode" => "401"
        ];
      }

      Flight::json($result);
    } catch (Exception $e) {
      Flight::json(array("message" => $e->getMessage()), 500);
    }
  }

  public function CREAR_USUARIO()
  {
    $response = null;

    try {
      $data = Flight::request()->data;

      $query = Flight::db()->prepare("CALL PROC_USUARIO_CREAR(:NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CORREO, :TELEFONO, :ID_PRIVILEGIO, :CONTRASENIA)");
      $query->execute([
        "NOMBRES" => $data->NOMBRES,
        "APPATERNO" => $data->APPATERNO,
        "APMATERNO" => $data->APMATERNO,
        "DOCUMENTO" => $data->DOCUMENTO,
        "CORREO" => $data->CORREO,
        "TELEFONO" => $data->TELEFONO,
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

  public function ACTUALIZAR_USUARIO()
  {
    $response = null;

    try {
      $data = Flight::request()->data;

      $query = Flight::db()->prepare("CALL PROC_USUARIO_ACTUALIZAR(:ID_USUARIO, :NOMBRES, :APPATERNO, :APMATERNO, :DOCUMENTO, :CORREO, :TELEFONO, :ID_PRIVILEGIO, :CONTRASENIA)");
      $query->execute([
        "ID_USUARIO" => $data->ID_USUARIO,
        "NOMBRES" => $data->NOMBRES,
        "APPATERNO" => $data->APPATERNO,
        "APMATERNO" => $data->APMATERNO,
        "DOCUMENTO" => $data->DOCUMENTO,
        "CORREO" => $data->CORREO,
        "TELEFONO" => $data->TELEFONO,
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

  public function ELIMINAR_USUARIO_DEFINITIVO()
  {
    $response = null;

    try {
      $data = Flight::request()->data;

      $query = Flight::db()->prepare("CALL PROC_USUARIO_ELIMINAR_DEFINITIVO(:ID_USUARIO)");
      $query->execute(["ID_USUARIO" => $data->ID_USUARIO]);

      $response = array(
        "icon" => "success",
        "title" => "MENSAJE DEL SISTEMA",
        "text" => "Usuario eliminado definitivamente",
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
