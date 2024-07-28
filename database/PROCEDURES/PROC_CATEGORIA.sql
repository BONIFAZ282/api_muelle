-- LISTAR
DELIMITER $$

CREATE PROCEDURE PROC_CATEGORIA_LIST()
BEGIN
    SELECT 
        ID_CATEGORIA,
        NOM_CATEGORIA
    FROM
        categoria
    ORDER BY
        ID_CATEGORIA ASC;
END $$

DELIMITER ;


--CREAR
DELIMITER $$

CREATE PROCEDURE PROC_CATEGORIA_CREAR(
    IN _NOM_CATEGORIA VARCHAR(255)
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

    -- Verificar si el nombre de la categoría ya está en uso
    SELECT COUNT(*) INTO contador FROM categoria WHERE NOM_CATEGORIA = _NOM_CATEGORIA;
    IF contador > 0 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre de la categoría ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Crear nueva categoría
        INSERT INTO categoria (NOM_CATEGORIA)
        VALUES (_NOM_CATEGORIA);

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Categoría creada exitosamente';
        SET __STATUS_CODE = '201';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


--ACTUALIZAR
DELIMITER $$

CREATE PROCEDURE PROC_CATEGORIA_ACTUALIZAR(
    IN _ID_CATEGORIA INT,
    IN _NOM_CATEGORIA VARCHAR(255)
)
BEGIN
    DECLARE contador INT;
    DECLARE __ICON VARCHAR(10);
    DECLARE __MESSAGE_TEXT VARCHAR(300);
    DECLARE __STATUS_CODE CHAR(3);
    DECLARE current_nombre VARCHAR(255);

    SET contador = 0;
    SET __ICON = 'error';
    SET __MESSAGE_TEXT = 'HA OCURRIDO UN ERROR';
    SET __STATUS_CODE = '501';

    -- Obtener el nombre actual de la categoría
    SELECT NOM_CATEGORIA INTO current_nombre
    FROM categoria
    WHERE ID_CATEGORIA = _ID_CATEGORIA;

    -- Verificar si el nombre es diferente y ya está en uso
    IF _NOM_CATEGORIA <> current_nombre THEN
        SELECT COUNT(*) INTO contador FROM categoria
        WHERE NOM_CATEGORIA = _NOM_CATEGORIA;
    END IF;

    IF contador > 0 THEN
        -- Nombre de la categoría ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre de la categoría ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar categoría existente
        UPDATE categoria
        SET NOM_CATEGORIA = _NOM_CATEGORIA
        WHERE ID_CATEGORIA = _ID_CATEGORIA;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Categoría actualizada correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


--ELIMINAR
DELIMITER $$

CREATE PROCEDURE PROC_CATEGORIA_ELIMINAR(
    IN _ID_CATEGORIA INT
)
BEGIN
    DECLARE __ICON VARCHAR(10) DEFAULT 'error';
    DECLARE __MESSAGE_TEXT VARCHAR(300) DEFAULT 'HA OCURRIDO UN ERROR';
    DECLARE __STATUS_CODE CHAR(3) DEFAULT '501';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET __ICON = 'error';
        SET __MESSAGE_TEXT = 'No se puede eliminar la categoría porque está relacionada con un plato';
        SET __STATUS_CODE = '400';
    END;

    START TRANSACTION;

    -- Verificar si la categoría existe
    IF EXISTS (SELECT 1 FROM categoria WHERE ID_CATEGORIA = _ID_CATEGORIA) THEN
        -- Eliminar la categoría
        DELETE FROM categoria WHERE ID_CATEGORIA = _ID_CATEGORIA;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Categoría eliminada permanentemente';
        SET __STATUS_CODE = '202';
    ELSE
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = 'La categoría no existe';
        SET __STATUS_CODE = '404';
    END IF;

    COMMIT;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;
