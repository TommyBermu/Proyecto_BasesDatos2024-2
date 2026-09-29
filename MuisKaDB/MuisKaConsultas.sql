--  Consultas
-- Ver publicaciones:
SELECT titulo, FechaFinalizacion, Imagen from Publicacion ORDER BY FechaFinalizacion ASC;

-- Ver anuncios: 
SELECT Imagen, FechaFinalizacion, titulo FROM Anuncio JOIN Publicacion ON (Publicacion_idPublicacion = idPublicacion) ORDER BY FechaFinalizacion ASC;

-- Ver convocatorias: 
SELECT Imagen, FechaFinalizacion, Titulo FROM Convocatoria JOIN Publicacion ON Publicacion_idPublicacion = idPublicacion ORDER BY FechaFinalizacion ASC;

-- Ver libros:
SELECT Titulo, linkDescarga, Descripcion, Autor FROM Libro;

-- Ver libros filtrando por nombre:
SELECT Titulo, linkDescarga, Descripcion, Autor FROM Libro where Titulo like '%Titulo%';

-- Ver todos los grupos: 
SELECT Nombre AS gru_nombre, Descripcion, Miembros, Acceso, linkPortada FROM Grupo;

-- Ver grupos filtrando por nombre:
SELECT Nombre,  Descripcion, Miembros, Acceso, linkPortada FROM Grupo WHERE Nombre like '%OOP%';


-- Ver los datos personales: 
SELECT * FROM usuario_datos_personales;
-- Insertar un registro en usuario:

-- Ver todas las peticiones de creación de libros: 
SELECT * FROM peticion_creacion_libro;

-- Ver todas las peticiones de creación de grupos:
select * from peticion_creacion_grupo;
