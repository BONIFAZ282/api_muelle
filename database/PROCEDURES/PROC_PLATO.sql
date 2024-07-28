-- LISTAR
DELIMITER $$

CREATE PROCEDURE PROC_PLATO_LIST()
BEGIN
    SELECT 
        ID_PLATO,
        ID_CATEGORIA,
        NOMBRE,
        DESCRIPCION,
        PRECIO
    FROM
        plato
    ORDER BY
        ID_PLATO ASC;
END $$

DELIMITER ;


-- CREAR
DELIMITER $$

CREATE PROCEDURE PROC_PLATO_CREAR(
    IN _ID_CATEGORIA INT,
    IN _NOMBRE VARCHAR(100),
    IN _DESCRIPCION VARCHAR(255),
    IN _PRECIO DECIMAL(10,2)
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

    -- Verificar si el nombre del plato ya está en uso
    SELECT COUNT(*) INTO contador FROM plato WHERE NOMBRE = _NOMBRE;
    IF contador > 0 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre del plato ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Crear nuevo plato
        INSERT INTO plato (ID_CATEGORIA, NOMBRE, DESCRIPCION, PRECIO)
        VALUES (_ID_CATEGORIA, _NOMBRE, _DESCRIPCION, _PRECIO);

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Plato creado exitosamente';
        SET __STATUS_CODE = '201';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


-- ACTUALIZAR
DELIMITER $$

CREATE PROCEDURE PROC_PLATO_ACTUALIZAR(
    IN _ID_PLATO INT,
    IN _ID_CATEGORIA INT,
    IN _NOMBRE VARCHAR(100),
    IN _DESCRIPCION VARCHAR(255),
    IN _PRECIO DECIMAL(10,2)
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

    -- Obtener el nombre actual del plato
    SELECT NOMBRE INTO current_nombre
    FROM plato
    WHERE ID_PLATO = _ID_PLATO;

    -- Verificar si el nombre es diferente y ya está en uso
    IF _NOMBRE <> current_nombre THEN
        SELECT COUNT(*) INTO contador FROM plato
        WHERE NOMBRE = _NOMBRE;
    END IF;

    IF contador > 0 THEN
        -- Nombre del plato ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre del plato ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar plato existente
        UPDATE plato
        SET
            ID_CATEGORIA = _ID_CATEGORIA,
            NOMBRE = _NOMBRE,
            DESCRIPCION = _DESCRIPCION,
            PRECIO = _PRECIO
        WHERE ID_PLATO = _ID_PLATO;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Plato actualizado correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


-- ELIMINAR
DELIMITER $$

CREATE PROCEDURE PROC_PLATO_ELIMINAR(
    IN _ID_PLATO INT
)
BEGIN
    DECLARE __ICON VARCHAR(10) DEFAULT 'error';
    DECLARE __MESSAGE_TEXT VARCHAR(300) DEFAULT 'HA OCURRIDO UN ERROR';
    DECLARE __STATUS_CODE CHAR(3) DEFAULT '501';

    -- Verificar si el plato existe
    IF EXISTS (SELECT 1 FROM plato WHERE ID_PLATO = _ID_PLATO) THEN
        -- Eliminar el plato
        DELETE FROM plato WHERE ID_PLATO = _ID_PLATO;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Plato eliminado permanentemente';
        SET __STATUS_CODE = '202';
    ELSE
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = 'El plato no existe';
        SET __STATUS_CODE = '404';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;
