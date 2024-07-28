DELIMITER $$

CREATE PROCEDURE PROC_GANANCIAS_REPORTE ()
BEGIN
    SELECT 
        p.ID_PEDIDO,
        p.F_PEDIDO
        p.ESTADO,
        p.TOTAL,
        m.NUMERO AS NUMERO_MESA,
        per.NOMBRES AS NOMBRE_TRABAJADOR,
        SUM(dp.CANTIDAD * dp.PRECIO) AS GANANCIA_TOTAL
    FROM 
        pedido p
    JOIN 
        mesa m ON p.ID_MESA = m.ID_MESA
    JOIN 
        trabajador t ON p.ID_TRABAJADOR = t.ID_TRABAJADOR
    JOIN 
        persona per ON t.ID_PERSONA = per.ID_PERSONA
    JOIN 
        detalle_pedido dp ON p.ID_PEDIDO = dp.ID_PEDIDO
    GROUP BY 
        p.ID_PEDIDO, p.F_PEDIDO, p.TOTAL, m.NUMERO, per.NOMBRES
    ORDER BY 
        p.F_PEDIDO DESC;
END $$

DELIMITER ;
