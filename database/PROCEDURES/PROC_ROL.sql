-- LISTAR
DELIMITER $$

CREATE PROCEDURE PROC_ROL_LIST()
BEGIN
    SELECT 
        ID_ROL,
        NOM_ROL
    FROM
        rol
    ORDER BY
        ID_ROL ASC;
END $$

DELIMITER ;



-- CREAR
DELIMITER $$

CREATE PROCEDURE PROC_ROL_CREAR(
    IN _NOM_ROL VARCHAR(100)
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

    -- Verificar si el nombre del rol ya está en uso
    SELECT COUNT(*) INTO contador FROM rol WHERE NOM_ROL = _NOM_ROL;
    IF contador > 0 THEN
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre del rol ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Crear nuevo rol
        INSERT INTO rol (NOM_ROL)
        VALUES (_NOM_ROL);

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Rol creado exitosamente';
        SET __STATUS_CODE = '201';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


-- ACTUALIZAR
DELIMITER $$

CREATE PROCEDURE PROC_ROL_ACTUALIZAR(
    IN _ID_ROL INT,
    IN _NOM_ROL VARCHAR(100)
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

    -- Obtener el nombre actual del rol
    SELECT NOM_ROL INTO current_nombre
    FROM rol
    WHERE ID_ROL = _ID_ROL;

    -- Verificar si el nombre es diferente y ya está en uso
    IF _NOM_ROL <> current_nombre THEN
        SELECT COUNT(*) INTO contador FROM rol
        WHERE NOM_ROL = _NOM_ROL;
    END IF;

    IF contador > 0 THEN
        -- Nombre del rol ya en uso
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = '¡El nombre del rol ya está en uso!';
        SET __STATUS_CODE = '200';
    ELSE
        -- Actualizar rol existente
        UPDATE rol
        SET NOM_ROL = _NOM_ROL
        WHERE ID_ROL = _ID_ROL;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Rol actualizado correctamente';
        SET __STATUS_CODE = '202';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;


-- ELIMINAR
DELIMITER $$

CREATE PROCEDURE PROC_ROL_ELIMINAR(
    IN _ID_ROL INT
)
BEGIN
    DECLARE __ICON VARCHAR(10) DEFAULT 'error';
    DECLARE __MESSAGE_TEXT VARCHAR(300) DEFAULT 'HA OCURRIDO UN ERROR';
    DECLARE __STATUS_CODE CHAR(3) DEFAULT '501';

    -- Verificar si el rol existe
    IF EXISTS (SELECT 1 FROM rol WHERE ID_ROL = _ID_ROL) THEN
        -- Eliminar el rol
        DELETE FROM rol WHERE ID_ROL = _ID_ROL;

        SET __ICON = 'success';
        SET __MESSAGE_TEXT = 'Rol eliminado permanentemente';
        SET __STATUS_CODE = '202';
    ELSE
        SET __ICON = 'warning';
        SET __MESSAGE_TEXT = 'El rol no existe';
        SET __STATUS_CODE = '404';
    END IF;

    SELECT __ICON AS 'ICON', __MESSAGE_TEXT AS 'MESSAGE_TEXT', __STATUS_CODE AS 'STATUS_CODE';
END $$

DELIMITER ;
