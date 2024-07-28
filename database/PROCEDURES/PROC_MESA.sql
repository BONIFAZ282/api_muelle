-- LISTAR
DELIMITER $$

CREATE PROCEDURE PROC_MESA_LIST()
BEGIN
    SELECT 
        ID_MESA,
        NUMERO,
        CAPACIDAD
    FROM
        mesa
    ORDER BY
        ID_MESA ASC;
END $$

DELIMITER ;


-- CREAR
DELIMITER $$

CREATE PROCEDURE PROC_MESA_CREAR(
    IN _NUMERO INT,
    IN _CAPACIDAD INT
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

    -- Verificar si el número de la mesa ya está en uso
    SELECT COUNT(*) INTO contador FROM mesa WHERE NUMERO = _NUMERO;
    IF contador > 0 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El número de la mesa ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSEIF _CAPACIDAD > 12 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡La capacidad no puede ser mayor a 12!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Crear nueva mesa
        INSERT INTO mesa (NUMERO, CAPACIDAD)
        VALUES (_NUMERO, _CAPACIDAD);

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Mesa creada exitosamente';
        SET __STATUS_CODE = '201';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


-- ACTUALIZAR
DELIMITER $$

CREATE PROCEDURE PROC_MESA_ACTUALIZAR(
    IN _ID_MESA INT,
    IN _NUMERO INT,
    IN _CAPACIDAD INT
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);
    DECLARE current_numero INT;

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Obtener el número actual de la mesa
    SELECT NUMERO INTO current_numero
    FROM mesa
    WHERE ID_MESA = _ID_MESA;

    -- Verificar si el número es diferente y ya está en uso
    IF _NUMERO <> current_numero THEN
        SELECT COUNT(*) INTO contador FROM mesa
        WHERE NUMERO = _NUMERO;
    END IF;

    IF contador > 0 THEN
        -- Número de la mesa ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El número de la mesa ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSEIF _CAPACIDAD > 12 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡La capacidad no puede ser mayor a 12!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar mesa existente
        UPDATE mesa
        SET
            NUMERO = _NUMERO,
            CAPACIDAD = _CAPACIDAD
        WHERE ID_MESA = _ID_MESA;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Mesa actualizada correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


--ELIMINAR

DELIMITER $$

CREATE PROCEDURE PROC_MESA_ELIMINAR(
    IN _ID_MESA INT
)
BEGIN
    DECLARE __ICON VARCHAR(10) DEFAULT 'error';
    DECLARE __MESSAGE_TEXT VARCHAR(300) DEFAULT 'HA OCURRIDO UN ERROR';
    DECLARE __STATUS_CODE CHAR(3) DEFAULT '501';

    -- Verificar si la mesa existe
    IF EXISTS (SELECT 1 FROM mesa WHERE ID_MESA = _ID_MESA) THEN
        -- Eliminar la mesa
        DELETE FROM mesa WHERE ID_MESA = _ID_MESA;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Mesa eliminada permanentemente';
        SET __STATUS_CODE = '202';
    ELSE
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = 'La mesa no existe';
        SET __STATUS_CODE = '404';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;
