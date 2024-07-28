-- OBTNER MESAS
DELIMITER //
CREATE PROCEDURE ObtenerMesas()
BEGIN
    SELECT * FROM mesa;
END //
DELIMITER ;


--OBTENER TRABAJADORES
DELIMITER //
CREATE PROCEDURE ObtenerTrabajadores()
BEGIN
    SELECT t.ID_TRABAJADOR, p.NOMBRES 
    FROM trabajador t 
    JOIN persona p ON t.ID_PERSONA = p.ID_PERSONA;
END //
DELIMITER ;
