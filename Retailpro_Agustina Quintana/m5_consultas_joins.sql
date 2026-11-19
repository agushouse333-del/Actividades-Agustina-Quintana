USE [Ventas_Tech_DB];
GO

-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: reunir las ventas con los datos de clientes, productos y categorías para Power BI.
SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email AS email_cliente,
    c.ciudad AS ciudad_cliente,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria_producto,
    v.cantidad,
    v.precio_unitario,
    CAST(v.cantidad * v.precio_unitario AS DECIMAL(18,2)) AS total_venta
FROM dbo.ventas AS v
INNER JOIN dbo.clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN dbo.productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN dbo.categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;

-- Hallazgo: Las 10 ventas suman 6444.00; la categoría Computación concentra
-- 4950.00 (76.82% del total), por lo que lidera la facturación.

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: detectar clientes sin compras para que CRM evalúe acciones de captación.
SELECT
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM dbo.clientes AS c
LEFT JOIN dbo.ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro, c.id_cliente;

-- Hallazgo: 0 de los 5 clientes registrados están sin compras; CRM no tiene
-- clientes pendientes de primera compra en los datos actuales.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: detectar productos sin ventas para revisar su movimiento comercial.
SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria_producto,
    p.precio
FROM dbo.productos AS p
INNER JOIN dbo.categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN dbo.ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY cat.nombre_categoria, p.nombre_producto;

-- Hallazgo: 0 de los 6 productos están sin ventas; el área de Producto
-- no encuentra artículos sin movimiento en el catálogo actual.

-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: comparar dos períodos con etiquetas de canal creadas en cada SELECT.
SELECT
    consolidado.canal,
    CAST(SUM(consolidado.total) AS DECIMAL(18,2)) AS total_canal,
    COUNT(*) AS cantidad_ventas
FROM (
    SELECT
        v.fecha_venta,
        CAST(v.cantidad * v.precio_unitario AS DECIMAL(18,2)) AS total,
        CAST('Periodo 1' AS VARCHAR(20)) AS canal
    FROM dbo.ventas AS v
    WHERE v.fecha_venta >= '2024-03-01'
      AND v.fecha_venta <  '2024-03-11'

    UNION ALL

    SELECT
        v.fecha_venta,
        CAST(v.cantidad * v.precio_unitario AS DECIMAL(18,2)) AS total,
        CAST('Periodo 2' AS VARCHAR(20)) AS canal
    FROM dbo.ventas AS v
    WHERE v.fecha_venta >= '2024-03-11'
      AND v.fecha_venta <  '2024-04-01'
) AS consolidado
GROUP BY consolidado.canal
ORDER BY total_canal DESC;

-- Hallazgo: El Período 1 facturó 3620.00 y el Período 2, 2824.00;
-- el primer período generó 796.00 más en ventas.
