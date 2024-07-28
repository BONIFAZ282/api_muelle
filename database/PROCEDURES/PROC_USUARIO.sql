DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_LOGIN (
    IN _DOCUMENTO CHAR(8),
    IN _CONTRASENIA VARCHAR(64)
)
BEGIN
    SELECT 
        p.DOCUMENTO,
        p.NOMBRES,
        p.APPATERNO,
        p.APMATERNO,
        u.PASSWORD,
        r.NOM_ROL AS 'NOMBRE_ROL'
    FROM
        persona p
    INNER JOIN
        usuario u ON p.ID_PERSONA = u.ID_PERSONA
    INNER JOIN
        trabajador t ON p.ID_PERSONA = t.ID_PERSONA
    INNER JOIN
        rol r ON t.ID_ROL = r.ID_ROL
    WHERE
        p.DOCUMENTO = _DOCUMENTO
        AND u.PASSWORD = SHA2(_CONTRASENIA, 256);
END $$

DELIMITER ;




--Listar Usuarios Disponibles


DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_LIST () 
BEGIN
  SELECT 
    US.ID_USUARIO,
    US.ID_PERSONA,
    PE.NOMBRES,
    PE.APPATERNO,
    PE.APMATERNO,
    PE.DOCUMENTO,
    PE.CORREO,
    PE.TELEFONO,
    US.ID_PRIVILEGIO,
    PR.NOM_PRIVILEGIO AS NOMBRE_PRIVILEGIO,
    US.PASSWORD AS CONTRASENIA
  FROM
    usuario US 
    INNER JOIN persona PE 
      ON PE.ID_PERSONA = US.ID_PERSONA 
    INNER JOIN privilegio PR 
      ON PR.ID_PRIVILEGIO = US.ID_PRIVILEGIO
  ORDER BY
    US.ID_USUARIO ASC;
END $$

DELIMITER ;


-- Eliminar Usuario
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_ELIMINAR_DEFINITIVO(
    IN _ID_USUARIO INT
)
BEGIN
    DECLARE _ID_PERSONA INT;

    SELECT ID_PERSONA INTO _ID_PERSONA FROM usuario WHERE ID_USUARIO = _ID_USUARIO;

    DELETE FROM usuario WHERE ID_USUARIO = _ID_USUARIO;
    DELETE FROM persona WHERE ID_PERSONA = _ID_PERSONA;
END$$

DELIMITER ;


-- CREAR USUARIO
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_CREAR(
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CORREO VARCHAR(255),
    IN _TELEFONO CHAR(9),
    IN _ID_PRIVILEGIO INT,
    IN _CONTRASENIA VARCHAR(64)
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Verificar si el documento ya está en uso
    SELECT COUNT(*) INTO contador FROM persona WHERE DOCUMENTO = _DOCUMENTO;
    IF contador > 0 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El documento ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Verificar si el correo ya está en uso
        SELECT COUNT(*) INTO contador FROM persona WHERE CORREO = _CORREO;
        IF contador > 0 THEN
            SET __ICON = 'warning';
            SET __MESSAGE_TEXT = '¡El correo ya está en uso!';
            SET __STATUS_CODE = '200';
        ELSE
            -- Verificar si el teléfono ya está en uso
            SELECT COUNT(*) INTO contador FROM persona WHERE TELEFONO = _TELEFONO;
            IF contador > 0 THEN
                SET __ICON = 'warning';
                SET __MESSAGE_TEXT = '¡El teléfono ya está en uso!';
                SET __STATUS_CODE = '200';
            ELSE
                -- Crear persona
                INSERT INTO persona (NOMBRES, APPATERNO, APMATERNO, DOCUMENTO, CORREO, TELEFONO)
                VALUES (_NOMBRES, _APPATERNO, _APMATERNO, _DOCUMENTO, _CORREO, _TELEFONO);

                SET @last_persona_id = LAST_INSERT_ID();

                -- Crear usuario
                INSERT INTO usuario (ID_PERSONA, ID_PRIVILEGIO, PASSWORD)
                VALUES (@last_persona_id, _ID_PRIVILEGIO, SHA2(_CONTRASENIA, 256));

                SET __ICON = 'success';
                SET __MESSAGE_TEXT = 'Registro exitoso';
                SET __STATUS_CODE = '201';
            END IF;
        END IF;
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;



-- ACTUALIZAR USUARIO
DELIMITER $$

CREATE PROCEDURE PROC_USUARIO_ACTUALIZAR(
    IN _ID_USUARIO INT,
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CORREO VARCHAR(255),
    IN _TELEFONO CHAR(9),
    IN _ID_PRIVILEGIO INT,
    IN _CONTRASENIA VARCHAR(64)
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);
    DECLARE current_documento CHAR(8);
    DECLARE current_correo VARCHAR(255);
    DECLARE current_telefono CHAR(9);
    DECLARE _ID_PERSONA INT;

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Obtener el ID de persona asociado al usuario
    SELECT ID_PERSONA INTO _ID_PERSONA
    FROM usuario
    WHERE ID_USUARIO = _ID_USUARIO;

    -- Obtener el documento, correo y teléfono actuales del usuario
    SELECT DOCUMENTO, CORREO, TELEFONO INTO current_documento, current_correo, current_telefono
    FROM persona
    WHERE ID_PERSONA = _ID_PERSONA;

    -- Verificar si el documento es diferente y ya está en uso
    IF _DOCUMENTO <> current_documento THEN
        SELECT COUNT(*) INTO contador FROM persona
        WHERE DOCUMENTO = _DOCUMENTO;
    END IF;

    IF contador = 0 AND _CORREO <> current_correo THEN
        -- Verificar si el correo es diferente y ya está en uso
        SELECT COUNT(*) INTO contador FROM persona
        WHERE CORREO = _CORREO;
    END IF;

    IF contador = 0 AND _TELEFONO <> current_telefono THEN
        -- Verificar si el teléfono es diferente y ya está en uso
        SELECT COUNT(*) INTO contador FROM persona
        WHERE TELEFONO = _TELEFONO;
    END IF;

    IF contador > 0 THEN
        -- Documento, correo o teléfono ya en uso
        SET __ICON = 'warning';
        IF _DOCUMENTO <> current_documento THEN
            SET __MESSAGE_TEXT = '¡El documento ya está en uso!';
        ELSEIF _CORREO <> current_correo THEN
            SET __MESSAGE_TEXT = '¡El correo ya está en uso!';
        ELSE
            SET __MESSAGE_TEXT = '¡El teléfono ya está en uso!';
        END IF;
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar persona
        UPDATE persona
        SET
            NOMBRES = _NOMBRES,
            APPATERNO = _APPATERNO,
            APMATERNO = _APMATERNO,
            DOCUMENTO = _DOCUMENTO,
            CORREO = _CORREO,
            TELEFONO = _TELEFONO
        WHERE ID_PERSONA = _ID_PERSONA;

        -- Actualizar usuario
        UPDATE usuario
        SET
            ID_PRIVILEGIO = _ID_PRIVILEGIO,
            PASSWORD = SHA2(_CONTRASENIA, 256)
        WHERE ID_USUARIO = _ID_USUARIO;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Usuario actualizado correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;
