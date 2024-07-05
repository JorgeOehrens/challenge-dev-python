-- Seleccione el título y el nombre del autor de todos los libros de la categoría "Ficción".

SELECT l.titulo, aut.nombre AS nombre_autor
FROM Libros AS li
JOIN Autores AS aut ON li.autor_id = aut.id_autor
JOIN Categorias AS cat ON li.categoria_id = cat.id_categoria
WHERE cat.nombre = 'Ficción';

-- Calcule el precio promedio de todos los libros en la tabla Libros.

SELECT AVG(precio) AS precio_promedio
FROM Libros;

-- Actualice el precio de todos los libros escritos por el autor con id_autor = 5 en un 10% de descuento.

UPDATE Libros
SET precio = precio * 0.9
WHERE autor_id = 5;
