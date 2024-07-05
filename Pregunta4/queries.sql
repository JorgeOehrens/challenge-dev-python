
-- Listado de ventas del mes actual
SELECT
    s.nombre_sucursal,
    v.nombre_vendedor,
    pr.marca,
    pr.nombre_producto,
    ve.fecha_venta,
    ve.unidades_vendidas,
    pr.precio_unitario,
    ve.unidades_vendidas * pr.precio_unitario AS valor_venta
FROM
    venta AS ve
JOIN
    sucursal AS s ON ve.id_sucursal = s.id_sucursal
JOIN
    vendedor AS v ON ve.id_vendedor = v.id_vendedor
JOIN
    producto AS pr ON ve.id_producto = pr.id_producto
WHERE
    EXTRACT(MONTH FROM ve.fecha_venta) = EXTRACT(MONTH FROM CURRENT_DATE)
    AND EXTRACT(YEAR FROM ve.fecha_venta) = EXTRACT(YEAR FROM CURRENT_DATE);



-- Ventas totales por sucursal, vendedor y marca, incluyendo los vendedores que no tuvieron ventas


SELECT
    s.nombre_sucursal,
    COALESCE(v.nombre_vendedor, 'Sin Vendedor') AS nombre_vendedor,
    p.marca,
    COALESCE(SUM(ve.unidades_vendidas * p.precio_unitario), 0) AS total_venta
FROM
    sucursal s
CROSS JOIN
    vendedor v
CROSS JOIN
    producto p
LEFT JOIN
    venta ve ON s.id_sucursal = ve.id_sucursal
            AND v.id_vendedor = ve.id_vendedor
            AND p.id_producto = ve.id_producto
GROUP BY
    s.nombre_sucursal,
    v.nombre_vendedor,
    p.marca
ORDER BY
    s.nombre_sucursal,
    v.nombre_vendedor,
    p.marca;


-- Productos con más de 1000 unidades vendidas en los últimos 2 meses

SELECT
    p.nombre_producto,
    p.marca,
    SUM(ve.unidades_vendidas) AS unidades_vendidas
FROM
    producto p
JOIN
    venta ve ON p.id_producto = ve.id_producto
WHERE
    ve.fecha_venta >= CURRENT_DATE - INTERVAL '2 months'
GROUP BY
    p.nombre_producto,
    p.marca
HAVING
    SUM(ve.unidades_vendidas) > 1000
ORDER BY
    unidades_vendidas DESC;

-- Productos sin ventas en el presente año
SELECT
    p.nombre_producto,
    p.marca
FROM
    producto p
WHERE
    NOT EXISTS (
        SELECT 1
        FROM venta ve
        WHERE p.id_producto = ve.id_producto
          AND EXTRACT(YEAR FROM ve.fecha_venta) = EXTRACT(YEAR FROM CURRENT_DATE)
    );


WITH productos_sin_ventas AS (
    SELECT
        p.id_producto,
        p.nombre_producto,
        p.marca
    FROM
        producto p
    WHERE
        NOT EXISTS (
            SELECT 1
            FROM venta ve
            WHERE p.id_producto = ve.id_producto
              AND EXTRACT(YEAR FROM ve.fecha_venta) = EXTRACT(YEAR FROM CURRENT_DATE)
        )
)

-- De los productos sin ventas en el presente año, monto total de ventas en el año anterior
SELECT
    psv.nombre_producto,
    psv.marca,
    COALESCE(SUM(ve.total_venta), 0) AS total_venta_anterior
FROM
    productos_sin_ventas psv
LEFT JOIN
    venta ve ON psv.id_producto = ve.id_producto
          AND EXTRACT(YEAR FROM ve.fecha_venta) = EXTRACT(YEAR FROM CURRENT_DATE) - 1
GROUP BY
    psv.nombre_producto,
    psv.marca;
