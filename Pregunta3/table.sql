-- Creación de tabla Usuarios
CREATE TABLE IF NOT EXISTS Usuarios (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

-- Creación de tabla Publicaciones
CREATE TABLE IF NOT EXISTS Publicaciones (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Usuarios(id),
    title VARCHAR(100),
    body TEXT
);
