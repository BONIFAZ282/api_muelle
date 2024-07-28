-- Listar Trabajadores
DELIMITER $$

CREATE PROCEDURE PROC_TRABAJADOR_LIST () 
BEGIN
  SELECT 
    TR.ID_TRABAJADOR,
    TR.ID_ROL,
    R.NOM_ROL AS ROL,
    TR.ID_PERSONA,
    P.NOMBRES,
    P.APPATERNO,
    P.APMATERNO,
    P.DOCUMENTO,
    P.CORREO,
    P.TELEFONO,
    U.ID_USUARIO,
    U.ID_PRIVILEGIO,
    PR.NOM_PRIVILEGIO AS PRIVILEGIO
  FROM
    trabajador TR 
    INNER JOIN persona P ON P.ID_PERSONA = TR.ID_PERSONA
    INNER JOIN rol R ON R.ID_ROL = TR.ID_ROL
    INNER JOIN usuario U ON U.ID_PERSONA = P.ID_PERSONA
    INNER JOIN privilegio PR ON PR.ID_PRIVILEGIO = U.ID_PRIVILEGIO
  ORDER BY TR.ID_TRABAJADOR ASC;
END $$

DELIMITER ;

-- Crear Trabajador
DELIMITER $$

CREATE PROCEDURE PROC_TRABAJADOR_CREAR(
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CORREO VARCHAR(255),
    IN _TELEFONO CHAR(9),
    IN _ID_ROL INT,
    IN _CONTRASENIA VARCHAR(64)
)
BEGIN
    DECLARE _ID_PERSONA INT;
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);
    DECLARE _ID_PRIVILEGIO INT DEFAULT 1; -- Asignar ID_PRIVILEGIO = 1 por defecto

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

                SET _ID_PERSONA = LAST_INSERT_ID();

                -- Crear usuario con ID_PRIVILEGIO = 1
                INSERT INTO usuario (ID_PERSONA, ID_PRIVILEGIO, PASSWORD)
                VALUES (_ID_PERSONA, _ID_PRIVILEGIO, SHA2(_CONTRASENIA, 256));

                -- Crear trabajador
                INSERT INTO trabajador (ID_PERSONA, ID_ROL)
                VALUES (_ID_PERSONA, _ID_ROL);

                SET __ICON = 'success';
                SET __MESSAGE_TEXT = 'Registro exitoso';
                SET __STATUS_CODE = '201';
            END IF;
        END IF;
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;

-- Actualizar Trabajador
DELIMITER $$

CREATE PROCEDURE PROC_TRABAJADOR_ACTUALIZAR(
    IN _ID_TRABAJADOR INT,
    IN _NOMBRES VARCHAR(100),
    IN _APPATERNO VARCHAR(100),
    IN _APMATERNO VARCHAR(100),
    IN _DOCUMENTO CHAR(8),
    IN _CORREO VARCHAR(255),
    IN _TELEFONO CHAR(9),
    IN _ID_ROL INT,
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

    -- Obtener el ID de persona asociado al trabajador
    SELECT ID_PERSONA INTO _ID_PERSONA
    FROM trabajador
    WHERE ID_TRABAJADOR = _ID_TRABAJADOR;

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
        WHERE ID_PERSONA = _ID_PERSONA;

        -- Actualizar trabajador
        UPDATE trabajador
        SET
            ID_ROL = _ID_ROL
        WHERE ID_TRABAJADOR = _ID_TRABAJADOR;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Usuario actualizado correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


--Eliminar
DELIMITER $$

CREATE PROCEDURE PROC_TRABAJADOR_ELIMINAR_DEFINITIVO(
    IN _ID_TRABAJADOR INT
)
BEGIN
    DECLARE _ID_PERSONA INT;

    -- Obtener el ID_PERSONA asociado al ID_TRABAJADOR
    SELECT ID_PERSONA INTO _ID_PERSONA FROM trabajador WHERE ID_TRABAJADOR = _ID_TRABAJADOR;

    -- Eliminar el trabajador
    DELETE FROM trabajador WHERE ID_TRABAJADOR = _ID_TRABAJADOR;

    -- Eliminar el usuario
    DELETE FROM usuario WHERE ID_PERSONA = _ID_PERSONA;

    -- Eliminar la persona
    DELETE FROM persona WHERE ID_PERSONA = _ID_PERSONA;
END $$

DELIMITER ;




-- Total Trabajadores
DELIMITER $$

CREATE PROCEDURE PROC_TOTAL_TRABAJADORES()
BEGIN
    SELECT COUNT(*) AS TOTAL_TRABAJADORES FROM trabajador;
END $$

DELIMITER ;

-- Trabajadores por Rol
DELIMITER $$

CREATE PROCEDURE PROC_TRABAJADORES_POR_ROL()
BEGIN
    SELECT 
        r.NOM_ROL, 
        COUNT(t.ID_TRABAJADOR) AS CANTIDAD
    FROM 
        trabajador t
    JOIN 
        rol r ON t.ID_ROL = r.ID_ROL
    GROUP BY 
        r.NOM_ROL;
END $$

DELIMITER ;


-- SOLO LISTAR A LOS MESEROS
DELIMITER $$

CREATE PROCEDURE PROC_MESERO_LIST()
BEGIN
    SELECT 
        TR.ID_TRABAJADOR,
        TR.ID_ROL,
        R.NOM_ROL AS ROL,
        TR.ID_PERSONA,
        P.NOMBRES,
        P.APPATERNO,
        P.APMATERNO,
        P.DOCUMENTO,
        P.CORREO,
        P.TELEFONO,
        U.ID_USUARIO,
        U.ID_PRIVILEGIO,
        PR.NOM_PRIVILEGIO AS PRIVILEGIO
    FROM
        trabajador TR 
        INNER JOIN persona P ON P.ID_PERSONA = TR.ID_PERSONA
        INNER JOIN rol R ON R.ID_ROL = TR.ID_ROL
        INNER JOIN usuario U ON U.ID_PERSONA = P.ID_PERSONA
        INNER JOIN privilegio PR ON PR.ID_PRIVILEGIO = U.ID_PRIVILEGIO
    WHERE
        R.NOM_ROL = 'MESERO'
    ORDER BY TR.ID_TRABAJADOR ASC;
END $$

DELIMITER ;
