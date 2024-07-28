--LISTAR
DELIMITER $$

CREATE PROCEDURE PROC_PRIVILEGIO_LIST()
BEGIN
    SELECT 
        ID_PRIVILEGIO,
        NOM_PRIVILEGIO
    FROM
        privilegio
    ORDER BY
        ID_PRIVILEGIO ASC;
END $$

DELIMITER ;


--CREAR
DELIMITER $$

CREATE PROCEDURE PROC_PRIVILEGIO_CREAR(
    IN _NOM_PRIVILEGIO VARCHAR(100)
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

    -- Verificar si el nombre del privilegio ya está en uso
    SELECT COUNT(*) INTO contador FROM privilegio WHERE NOM_PRIVILEGIO = _NOM_PRIVILEGIO;
    IF contador > 0 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre del privilegio ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Crear nuevo privilegio
        INSERT INTO privilegio (NOM_PRIVILEGIO)
        VALUES (_NOM_PRIVILEGIO);

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Privilegio creado exitosamente';
        SET __STATUS_CODE = '201';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


--ACTUALIZAR
DELIMITER $$

CREATE PROCEDURE PROC_PRIVILEGIO_ACTUALIZAR(
    IN _ID_PRIVILEGIO INT,
    IN _NOM_PRIVILEGIO VARCHAR(100)
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);
    DECLARE current_nombre VARCHAR(100);

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Obtener el nombre actual del privilegio
    SELECT NOM_PRIVILEGIO INTO current_nombre
    FROM privilegio
    WHERE ID_PRIVILEGIO = _ID_PRIVILEGIO;

    -- Verificar si el nombre es diferente y ya está en uso
    IF _NOM_PRIVILEGIO <> current_nombre THEN
        SELECT COUNT(*) INTO contador FROM privilegio
        WHERE NOM_PRIVILEGIO = _NOM_PRIVILEGIO;
    END IF;

    IF contador > 0 THEN
        -- Nombre del privilegio ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre del privilegio ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar privilegio existente
        UPDATE privilegio
        SET NOM_PRIVILEGIO = _NOM_PRIVILEGIO
        WHERE ID_PRIVILEGIO = _ID_PRIVILEGIO;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Privilegio actualizado correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


--DELETE
DELIMITER $$

CREATE PROCEDURE PROC_PRIVILEGIO_ELIMINAR(
    IN _ID_PRIVILEGIO INT
)
BEGIN
    DECLARE __ICON VARCHAR(10) DEFAULT 'error';
    DECLARE __MESSAGE_TEXT VARCHAR(300) DEFAULT 'HA OCURRIDO UN ERROR';
    DECLARE __STATUS_CODE CHAR(3) DEFAULT '501';

    -- Verificar si el privilegio existe
    IF EXISTS (SELECT 1 FROM privilegio WHERE ID_PRIVILEGIO = _ID_PRIVILEGIO) THEN
        -- Eliminar el privilegio
        DELETE FROM privilegio WHERE ID_PRIVILEGIO = _ID_PRIVILEGIO;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Privilegio eliminado permanentemente';
        SET __STATUS_CODE = '202';
    ELSE
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = 'El privilegio no existe';
        SET __STATUS_CODE = '404';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;
