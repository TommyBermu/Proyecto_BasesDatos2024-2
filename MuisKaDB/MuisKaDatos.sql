
-- drop table if exists Carpeta;
INSERT INTO Carpeta (Descripcion) VALUES
("Registro familiar para acceso a beneficios comunitarios"),
("Unidad familiar con historial de participación en la comunidad"),
("Familia beneficiaria de programas sociales"),
("Familia beneficiaria de canasta"),
("Registro familiar para acceso a beneficios comunitarios");

-- Usuarios --
-- drop table if exists Usuario;
INSERT INTO Usuario (Carpeta_idCarpeta, Nombre, Apellidos, Cargo, Email, nombrePadre, apellidosPadre, nombreMadre, apellidosMadre, fechaNacimiento, Profesion)
VALUES 
(1, 'Juan', 'Neuta', 'COMUNERO', 'juan.perez@email.com', 'Carlos', 'Pérez', 'María', 'Gómez', '1990-05-15', 'Estudiante'),
(1, 'Ana', 'Silva', 'COMUNERO', 'ana.garcia@email.com', 'Luis', 'García', 'Elena', 'Martínez', '1985-08-22', 'Abogada'),
(2, 'Pedro', 'Chiguasuque', 'COMUNERO', 'pedro.ramirez@email.com', 'Oscar', 'Ramírez', 'Lucía', 'Díaz', '1992-10-30', 'Docente'),
(2, 'María', 'Neuta', 'COMUNERO', 'maria.lopez@email.com', 'Jorge', 'López', 'Sofía', 'Fernández', '1995-06-12', 'Estudiante'),
(3, 'Luis', 'Neuta', 'COMUNERO', 'luis.hernandez@email.com', 'Fernando', 'Hernández', 'Carmen', 'Rojas', '1980-12-05', 'Empresario'),
(3, 'Sofía', 'Chiguasuque', 'COMUNERO', 'sofia.martinez@email.com', 'Raúl', 'Martínez', 'Isabel', 'Gutiérrez', '1987-03-18', 'Psicóloga'),
(4, 'Carlos', 'Cobos', 'COMUNERO', 'carlos.gomez@email.com', 'Manuel', 'Gómez', 'Patricia', 'Castro', '1993-07-09', 'Contador'),
(5, 'Paola', 'Neuta', 'COMUNERO', 'paola.neuta@gmail.com', 'Jairo', 'Neuta', 'Maria', 'Bernal', '1984-06-19', 'Contador'),
(5, 'Julian', 'Neuta', 'COMUNERO', 'julidavid.velandia@gmail.com', 'Andres', 'Neuta', 'Paola', 'Neuta', '2007-05-24', 'Estudiante'),
(1, 'Carlos', 'Rojas', 'COMUNERO', 'carlos.rojas@email.com', 'Manuel', 'Rojas', 'Patricia', 'Castro', '1992-02-10', 'Ingeniero'),
(2, 'Lucía', 'Fernández', 'COMUNERO', 'lucia.fernandez@email.com', 'Roberto', 'Fernández', 'Sofía', 'Neuta', '1987-11-25', 'Abogada'),
(3, 'Roberto', 'López', 'COMUNERO', 'roberto.lopez@email.com', 'Jorge', 'López', 'Elena', 'Chiguasuque', '1993-04-14', 'Profesor'),
(4, 'Carmen', 'Pérez', 'COMUNERO', 'carmen.perez@email.com', 'Luis', 'Pérez', 'Raquel', 'Díaz', '1985-09-20', 'Médico'),
(5, 'Rosa', 'Chiguasuque', 'COMUNERO', 'rosa.chiguasuque@email.com', 'Carlos', 'Chiguasuque', 'Isabel', 'Moreno', '1991-02-05', 'Psicóloga'),
(1, 'Juan', 'Cruz', 'PREFERENTE', 'juan.cruz@gmail.com', 'Carlos', 'Cruz', 'Marta', 'Neuta', '1985-06-15', 'Agricultor'),
(1, 'Sara', 'Cobos', 'LIBRERO', 'sara.cobos@gmail.com', 'Luis', 'Cobos', 'Elena', 'Chiguasuque', '1990-09-23', 'Docente'),
(3, 'Diego', 'Chiguasuque', 'GESTOR_REDES', 'diego.chiguasuque@gmail.com', 'Pedro', 'Chiguasuque', 'Rosa', 'Neuta', '1982-11-05', 'Deportista'),
(4, 'Elena', 'Cobos', 'GESTOR_GRUPO', 'elena.diaz@gmail.com', 'Rubén', 'Cobos', 'Angela', 'Moreno', '2002-11-25', 'Trabajadora Social'), 
(3, 'Luna', 'Neuta', 'GESTOR_GRUPO', 'luna.neuta@gmail.com', 'José', 'Neuta', 'Sofía', 'Cobos', '1978-04-30', 'Empresaria'),
(4, 'Santiago', 'Neuta', 'CREADOR_GRUPOS', 'santiago.neuta@gmail.com', 'Jorge', 'Neuta', 'Laura', 'Chiguasuque', '2005-12-12', NULL),
(2, 'David', 'Velandia', 'ADMIN', 'julian.neuta01@gmail.com', NULL, NULL, 'Mariana', 'Cobos', '1987-08-19', 'Lider Social');

-- Administrador --
-- drop table if exists Administrador;
INSERT INTO Administrador (Usuario_idUsuario, nivelPermiso) VALUES 
(10, 2),
(11, 3),
(12, 4),
(13, 5),
(14, 5),
(15, 6),
(16, 7),
(17, 2), 
(18, 2), 
(19, 2),
(20, 2), 
(21, 2); 

-- Grupo --
-- drop table if exists Grupo;
INSERT INTO Grupo (Administrador_Usuario_idUsuario, Nombre, Descripcion, Miembros, Acceso, linkPortada) VALUES
(13, 'Consejo de Jóvenes', 'Espacio de participación y liderazgo juvenil para fortalecer la identidad cultural y la autodeterminación del pueblo Muisca de Bosa.', 0, 1, 'portada_consejo_jovenes'),
(14, 'Consejo de Mujeres', 'Foro de encuentro y empoderamiento para las mujeres Muiscas, donde se promueve el conocimiento ancestral, el liderazgo y la equidad.', 0, 2, 'portada_consejo_mujeres'),
(13, 'Consejo de Niños y Niñas', 'Un espacio de aprendizaje y crecimiento donde los niños y niñas de la comunidad Muisca exploran sus raíces, valores y derechos.', 0, 1, 'portada_consejo_ninos'),
(14, 'Estantillo de Gobierno y Justicia Propia', 'Órgano de gobernanza tradicional que vela por la armonía, la justicia propia y la autonomía del pueblo Muisca de Bosa.', 0, 1, 'portada_estantillo_gobierno');
/* (15, 'Consejo de Niños y Niñas', 'Un espacio de aprendizaje y crecimiento donde los niños y niñas de la comunidad Muisca exploran sus raíces, valores y derechos.', 0, 1, 'portada_consejo_ninos'),,
(100, 'Estantillo de Gobierno y Justicia Propia', 'Órgano de gobernanza tradicional que vela por la armonía, la justicia propia y la autonomía del pueblo Muisca de Bosa.', 0, 1, 'portada_estantillo_gobierno'),
(100, 'Consejo de Territorio', 'Instancia dedicada a la protección y gestión del territorio Muisca, asegurando la defensa de la tierra y la preservación del medio ambiente.', 0, 1, 'portada_consejo_territorio'),
(100, 'Consejo de Educación Propia', 'Espacio que fomenta la educación con enfoque propio, rescatando la lengua, la historia y el conocimiento ancestral de la comunidad.', 0, 1, 'portada_consejo_educacion'),
(100, 'Consejo de Medicina Tradicional', 'Grupo de sabedores y aprendices que trabajan en la preservación y práctica de la medicina tradicional Muisca, conectando el cuerpo, el espíritu y la naturaleza.', 0, 1, 'portada_consejo_medicina'),
(100, 'Consejo de Comunicaciones', 'Espacio de difusión y preservación de la memoria colectiva Muisca a través de medios tradicionales y digitales, fortaleciendo la identidad cultural.', 0, 1, 'portada_consejo_comunicaciones'); */

-- Publicaciones --
-- drop table if exists Publicacion;
INSERT INTO Publicacion (Administrador_Usuario_idUsuario, Titulo, LinkImagen, Descripcion, FechaFinalizacion, Tipo) VALUES
(12, 'Convocatoria de Artesanía Muisca', 'artesania.jpg', 'Abierta convocatoria para exposición de artesanías muiscas en la comunidad.', '2025-03-15', 1),
(12, 'Reunión Consejo de Territorio', 'consejo_territorio.jpg', 'Importante reunión para discutir la preservación del territorio ancestral.', '2025-02-28', 0),
(12, 'Taller de Medicina Tradicional', 'medicina_tradicional.jpg', 'Se abre inscripción para taller de plantas medicinales y saberes ancestrales.', '2025-04-10', 1),
(12, 'Asamblea General de la Comunidad', 'asamblea_general.jpg', 'Espacio de diálogo para tomar decisiones sobre el futuro de la comunidad.', '2025-03-01', 0),
(12, 'Festival de Sabores Ancestrales', 'sabores_ancestrales.jpg', 'Evento cultural con gastronomía tradicional muisca.', '2025-05-05', 0);

-- Convocatorias --
INSERT INTO Convocatoria (Publicacion_idPublicacion, Requisitos, Estado, Cupos) VALUES
(1, 'Ser artesano muisca', 1, 20),
(3, 'Mayor de 18 años, residente en la comunidad', 1, 30);

-- Anuncios --
INSERT INTO Anuncio (Publicacion_idPublicacion, PublicoObjetivo, Categoria) VALUES
(2, 'Líderes comunitarios', 'Reuniones y Asambleas'),
(5, 'Toda la comunidad', 'Festivales'),
(4, 'Toda la comunidad', 'Reuniones y Asambleas');
/* (6, 'Líderes comunitarios', 'Avisos Importantes'),
(7, 'Mujeres y familias', 'Programas Sociales'),
(8, 'Niños y adolescentes', 'Educación y Talleres'); */

-- Libros --
INSERT INTO Libro (Administrador_Usuario_idUsuario, Titulo, linkDescarga, Descripcion, Acceso, Autor) VALUES
(11, 'Antropología en el Siglo XXI', 'https://example.com/libro1.pdf', 'Libro sobre los avances en antropología moderna.', 0, 'Carlos Pérez'),
(11, 'Historia Colonial en América', 'https://example.com/libro2.pdf', 'Estudio profundo sobre la época colonial.', 0, 'Ana Gómez');

-- Peticiones --
INSERT INTO Peticion (Administrador_Usuario_idUsuario, Usuario_idUsuario, FechaEnvio, Tipo)
VALUES
(12, 10, NOW(), 1),  -- Petición de ingreso a convocatoria
(13, 8, NOW(),  1),   -- Petición de ingreso a grupo
(11, 17, NOW(), 2),  -- Petición de creación de libro
(15, 18, NOW(), 2),  -- Petición de creación de grupo
(16, 9, NOW(), 3),   -- Petición de cambio de carpeta
(12, 7, NOW(), 1),   -- Petición de ingreso a convocatoria
(11, 12, NOW(), 2);  -- Petición de creación de libro


INSERT INTO Ingreso (Peticion_idPeticion, CartaMotivacion, TipoIngreso, Convocatoria_Publicacion_idPublicacion, Grupo_idGrupo)
VALUES
(1, 'Motivación para unirme a la convocatoria de artesanía muisca.', 1, 1, NULL),
(2,"Pertenecer al consejo de jovenes para fortalecer la identidad cultural",0,null,1),
(6,"Motivación para pertenece al taller de medicina tradicional",1,3,null);


INSERT INTO Creacion (Peticion_idPeticion, TipoCreacion, NombreGrupo, TituloLibro, DescripcionSolicitud)
VALUES 
(3, 0, NULL, 'Historia dle conflicto armado', 'Solicitud para crear el libro sobre el conflicto armado Colombiano.'),
(4,1,"Desarrollo ambiental",null,"Grupo que busca enseñar a los jovenes la importancia de un desarrollo sostenible"),
(7,0,null,"El terriorio indigena", "Solicitud para crear el libro El territorio indigena" );
