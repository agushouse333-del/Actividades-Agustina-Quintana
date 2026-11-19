USE [Ventas_Tech_DB];
GO

-- Consulta 1: Resumen ejecutivo mensual
SELECT
    MONTH(fecha_venta) AS mes,
    CAST(SUM(cantidad * precio_unitario) AS DECIMAL(18,2)) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    CAST(AVG(CAST(cantidad * precio_unitario AS DECIMAL(18,2))) AS DECIMAL(18,2)) AS ticket_promedio
FROM dbo.ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- Consulta 2: Ranking de productos
SELECT TOP (5)
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    CAST(SUM(cantidad * precio_unitario) AS DECIMAL(18,2)) AS total_facturado
FROM dbo.ventas
GROUP BY id_producto
ORDER BY total_facturado DESC, id_producto ASC;

-- Consulta 3: Clientes recurrentes
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    CAST(SUM(cantidad * precio_unitario) AS DECIMAL(18,2)) AS total_gastado
FROM dbo.ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- Consulta 4: Productos por encima o por debajo del promedio
;WITH FacturacionPorProducto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM dbo.ventas
    GROUP BY id_producto
)
SELECT
    fp.id_producto,
    CAST(fp.total_facturado AS DECIMAL(18,2)) AS total_facturado,
    CASE
        WHEN fp.total_facturado > (
            SELECT AVG(CAST(fpp.total_facturado AS DECIMAL(18,2)))
            FROM FacturacionPorProducto AS fpp
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM FacturacionPorProducto AS fp
ORDER BY fp.total_facturado DESC, fp.id_producto ASC;

-- Hallazgo 1: En marzo de 2024 se facturaron 6444.00 en 10 pedidos, con un ticket
-- promedio de 644.40. Comparar estos resultados con futuros meses para medir cambios.
-- Hallazgo 2: Los productos 1 y 3 generaron 4950.00, el 76.82% de la facturacion.
-- Priorizar su disponibilidad y revisar oportunidades para impulsar los demas.
-- Hallazgo 3: Los cinco clientes realizaron dos pedidos cada uno. Los clientes 1 y 5
-- sumaron 4740.00 (73.56% de la facturacion). Priorizar acciones de fidelizacion.
