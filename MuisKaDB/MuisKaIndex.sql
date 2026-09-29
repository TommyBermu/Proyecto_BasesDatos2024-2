-- Creacion de las vistas

-- Índice pra el nombre de un libro: Útil por si se quiere hacer una busqueda por el nombre.
CREATE INDEX idx_libro_titulo ON Libro(Titulo);

-- Índice para el autor de un libro: Útil para filtracion de libros por un mismo autor. 
CREATE INDEX idx_libro_autor ON Libro(Autor);

-- Índice para el nombre de un grupo: Útil por si se quiere hacer una busqueda por el nombre
CREATE INDEX idx_grupo_nombre ON Grupo(Nombre);


-- Índice para la fecha de envio de una petición: Necesario para ordenar los fechas o para proyectar peticiones en un rango de
-- fechas específico. 
CREATE INDEX idx_peticion_fecha ON Peticion(FechaEnvio);


-- Índice para el estado de la petición: Apropiado para cuando se quiera filtrar por peticiones aceptadas, rechazadas o en espera.
CREATE INDEX idx_peticion_estado ON Peticion(Estado);


-- Índice para el nombre del usuario: Eficaz en caso de que sea necesario buscar la información de un usuario mediante su nombre. 
CREATE INDEX idx_usuario_nombre ON Usuario(nombre);



-- 