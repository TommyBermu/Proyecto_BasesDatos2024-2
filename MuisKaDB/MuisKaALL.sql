DROP DATABASE MuisKa;
CREATE DATABASE IF NOT EXISTS MuisKa;
USE MuisKa;

-- Tabla Carpeta
CREATE TABLE Carpeta (
    idCarpeta INT PRIMARY KEY AUTO_INCREMENT,
    Comuneros INT NOT NULL DEFAULT 0,
    Descripcion varchar(100),
    fechaCreacion datetime DEFAULT current_timestamp
);

-- Tabla Usuario
CREATE TABLE Usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    Carpeta_idCarpeta INT,
    Nombre VARCHAR(80) NOT NULL,
    Apellidos VARCHAR(80) NOT NULL,
    Cargo VARCHAR(80) NOT NULL,
    Email VARCHAR(80) NOT NULL,
    nombrePadre VARCHAR(80),
    apellidosPadre VARCHAR(80),
    nombreMadre VARCHAR(80),
    apellidosMadre VARCHAR(80),
    Inscripciones INT,
    Grupos INT,
    fechaNacimiento DATE,
    Profesion VARCHAR(80),
    FOREIGN KEY (Carpeta_idCarpeta) REFERENCES Carpeta(idCarpeta)
);

-- Tabla Administrador
CREATE TABLE Administrador (
    Usuario_idUsuario INT PRIMARY KEY,
    nivelPermiso INT NOT NULL, -- 1: Librero, 2: Gestor de grupo, 3: Creador de Grupo, 4: Comunicador, 5: Admin
    peticionesAceptadas INT DEFAULT 0,
    peticionesRechazadas INT DEFAULT 0,
    gruposGestionados INT DEFAULT 0,
    publicacionesCreadas INT DEFAULT 0,
    FOREIGN KEY (Usuario_idUsuario) REFERENCES Usuario(idUsuario)
);

-- Tabla Grupo
CREATE TABLE Grupo (
    idGrupo INT PRIMARY KEY AUTO_INCREMENT,
    Administrador_Usuario_idUsuario INT NOT NULL,
    Nombre VARCHAR(80) NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    Miembros INT NOT NULL DEFAULT 0,
    Acceso INT DEFAULT 0,
    linkPortada LONGBLOB NOT NULL,
    FOREIGN KEY (Administrador_Usuario_idUsuario) REFERENCES Administrador(Usuario_idUsuario)
);

-- Tabla Grupo_has_Usuario
CREATE TABLE Grupo_has_Usuario (
    Grupo_idGrupo INT,
    Usuario_idUsuario INT,
    PRIMARY KEY (Grupo_idGrupo, Usuario_idUsuario),
    FOREIGN KEY (Grupo_idGrupo) REFERENCES Grupo(idGrupo),
    FOREIGN KEY (Usuario_idUsuario) REFERENCES Usuario(idUsuario)
);

-- Tabla Publicación
CREATE TABLE Publicacion (
    idPublicacion INT PRIMARY KEY AUTO_INCREMENT,
    Administrador_Usuario_idUsuario INT NOT NULL,
    Titulo VARCHAR(80) NOT NULL,
    LinkImagen LONGBLOB NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    FechaPublicacion DATETIME NOT NULL DEFAULT current_timestamp,
    FechaFinalizacion DATE NOT NULL,
    Tipo TINYINT NOT NULL, -- 0: anuncio. 1: convocatoria
    FOREIGN KEY (Administrador_Usuario_idUsuario) REFERENCES Administrador(Usuario_idUsuario)
);

-- Tabla Convocatoria (Hereda de Publicación)
CREATE TABLE Convocatoria (
    Publicacion_idPublicacion INT PRIMARY KEY,
    Requisitos VARCHAR(80) NOT NULL,
    Estado TINYINT NOT NULL, -- 0: cerrado, 1:abierta
    Cupos INT NOT NULL,
    FOREIGN KEY (Publicacion_idPublicacion) REFERENCES Publicacion(idPublicacion)
);

-- Tabla Anuncio (Hereda de Publicación)
CREATE TABLE Anuncio (
    Publicacion_idPublicacion INT PRIMARY KEY,
    PublicoObjetivo VARCHAR(45),
    Categoria VARCHAR(80),
    FOREIGN KEY (Publicacion_idPublicacion) REFERENCES Publicacion(idPublicacion)
);

-- Tabla Convocatoria_has_Usuario
CREATE TABLE Convocatoria_has_Usuario (
    Convocatoria_Publicacion_idPublicacion INT,
    Usuario_idUsuario INT,
    PRIMARY KEY (Convocatoria_Publicacion_idPublicacion, Usuario_idUsuario),
    FOREIGN KEY (Convocatoria_Publicacion_idPublicacion) REFERENCES Convocatoria(Publicacion_idPublicacion),
    FOREIGN KEY (Usuario_idUsuario) REFERENCES Usuario(idUsuario)
);

-- Tabla Petición
CREATE TABLE Peticion (
    idPeticion INT PRIMARY KEY AUTO_INCREMENT,
    Administrador_Usuario_idUsuario INT,
    Usuario_idUsuario INT NOT NULL,
    FechaEnvio DATETIME NOT NULL DEFAULT current_timestamp,
    FechaRevision DATETIME,
    Estado TINYINT,
    Tipo INT NOT NULL, -- 0: ingreso, 1: cambio de carpeta, 2: creacion
    FOREIGN KEY (Administrador_Usuario_idUsuario) REFERENCES Administrador(Usuario_idUsuario),
    FOREIGN KEY (Usuario_idUsuario) REFERENCES Usuario(idUsuario)
);

-- Tabla Creacion (Hereda de Petición)
CREATE TABLE Creacion (
    Peticion_idPeticion INT PRIMARY KEY,
    TipoCreacion TINYINT NOT NULL, -- 0: libro, 1:grupo
    NombreGrupo VARCHAR(20),
    TituloLibro VARCHAR(80),
    DescripcionSolicitud VARCHAR(500) NOT NULL,
    FOREIGN KEY (Peticion_idPeticion) REFERENCES Peticion(idPeticion)
);

-- Tabla Ingreso (Hereda de Petición)
CREATE TABLE Ingreso (
    Peticion_idPeticion INT PRIMARY KEY,
    CartaMotivacion VARCHAR(400) NOT NULL,
    TipoIngreso TINYINT NOT NULL, -- 0: convocatoria, 1: grupo
    Convocatoria_Publicacion_idPublicacion INT,
    Grupo_idGrupo INT,
    FOREIGN KEY (Peticion_idPeticion) REFERENCES Peticion(idPeticion),
    FOREIGN KEY (Convocatoria_Publicacion_idPublicacion) REFERENCES Convocatoria(Publicacion_idPublicacion),
    FOREIGN KEY (Grupo_idGrupo) REFERENCES Grupo(idGrupo)
);

-- Tabla Cambio de Carpeta (Hereda de Petición)
CREATE TABLE Cambio_de_Carpeta (
    Peticion_idPeticion INT PRIMARY KEY,
    Documento VARCHAR(200) NOT NULL,
    Carpeta_idCarpeta INT NOT NULL,
    FOREIGN KEY (Peticion_idPeticion) REFERENCES Peticion(idPeticion),
    FOREIGN KEY (Carpeta_idCarpeta) REFERENCES Carpeta(idCarpeta)
);

-- Tabla Libro
CREATE TABLE Libro (
    idLibro INT PRIMARY KEY AUTO_INCREMENT,
    Administrador_Usuario_idUsuario INT NOT NULL,
    Titulo VARCHAR(80) NOT NULL,
    linkDescarga VARCHAR(200) NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    Acceso INT DEFAULT 0,
    Autor VARCHAR(200),
    FOREIGN KEY (Administrador_Usuario_idUsuario) REFERENCES Administrador(Usuario_idUsuario)
);

/******************************************************************/
/*************************** Procedures ***************************/
/******************************************************************/
delimiter $$

-- Convocatorias

create procedure subirConvocatoria (in AdminId int, in titulo VARCHAR(80), in link LONGBLOB, in descripcion VARCHAR(200), in fechaFin date, in requisitos VARCHAR(80), in cupos int)
begin
	declare idPub int;
	insert into Publicacion (Administrador_Usuario_idUsuario, Titulo, LinkImagen, Descripcion, FechaFinalizacion, Tipo) values(AdminId, titulo, link, descripcion, fechaFin, 1); -- 1 porque es convocatoria
    set idPub = (select idPublicacion from Publicacion order by FechaPublicacion desc limit 1);
    insert into Convocatoria (Publicacion_idPublicacion, Requisitos, Estado, Cupos) values (idPub, requisitos, 1, cupos);
end $$

create procedure peticionIngresoConvocatoria(in idUsuario int, in carta varchar(500), in pubId int)
begin
	declare idPeti int;
	insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 0); -- 0 porque es peticion de ingreso
    set idPeti = (select idPeticion from Peticion where Tipo = 0 order by FechaEnvio desc limit 1);
    insert into Ingreso (Peticion_idPeticion, CartaMotivacion, TipoIngreso, Convocatoria_Publicacion_idPublicacion) values (idPeti, carta, 0, pubId); -- tipo de ingreso: 0, osea a convocatoria
end $$

create procedure aceptarEnConvocatoria(in acc boolean, in idAdmin int, in idUsuario int, in idPublicacion int, in idPet int)
begin
	update Peticion set Administrador_Usuario_idUsuario = idAdmin, Estado = acc, FechaRevision = now() where idPeticion = idPet;
    if (acc) then
		insert into Convocatoria_has_Usuario values (idPublicacion, idUsuario);
	end if;
    delete from Ingreso where Peticion_idPeticion = idPet;
end $$

-- Grupos

create procedure peticionIngresoGrupo(in idUsuario int, in carta varchar(500), in pubId int)
begin
	declare idPeti int;
	insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 0); -- 0 porque es peticion de ingreso
    set idPeti = (select idPeticion from Peticion where Tipo = 0 order by FechaEnvio desc limit 1);
    insert into Ingreso (Peticion_idPeticion, CartaMotivacion, TipoIngreso, Convocatoria_Publicacion_idPublicacion) values (idPeti, carta, 1, pubId); -- tipo de ingreso: 1, osea a grupo
end $$

create procedure aceptarEnGrupo(in idUsuario int, in carta varchar(500), in pubId int)
begin
	declare idPeti int;
	insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 0); -- 0 porque es peticion de ingreso
    set idPeti = (select idPeticion from Peticion where Tipo = 0 order by FechaEnvio desc limit 1);
    insert into Ingreso (Peticion_idPeticion, CartaMotivacion, TipoIngreso, Convocatoria_Publicacion_idPublicacion) values (idPeti, carta, 1, pubId); -- tipo de ingreso: 1, osea a grupo
end $$

create procedure peticionCreacionGrupo(in idUsuario int, in nombreGrupo varchar(50), in descripcion varchar(500))
begin
	declare idPeti int;
    insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 2);
    set idPeti = (select idPeticion from Peticion where Tipo = 2 order by FechaEnvio desc limit 1);
    insert into Creacion (Peticion_idPeticion, TipoCreacion, NombreGrupo, DescripcionSolicitud) values (idPeti, 1, nombreGrupo, descripcion);
end $$

create procedure aceptarCreacionDeGrupo(in idUsuario int, in nombreGrupo varchar(50), in descripcion varchar(500))
begin
	declare idPeti int;
    insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 2);
    set idPeti = (select idPeticion from Peticion where Tipo = 2 order by FechaEnvio desc limit 1);
    insert into Creacion (Peticion_idPeticion, TipoCreacion, NombreGrupo, DescripcionSolicitud) values (idPeti, 1, nombreGrupo, descripcion);
end $$

-- Libro

create procedure peticionSubirLibro(in idUsuario int, in tituloLibro varchar(70), in descripcion varchar(500))
begin
	declare idPeti int;
	insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 2);
    set idPeti = (select idPeticion from Peticion where Tipo = 2 order by FechaEnvio desc limit 1);
    insert into Creacion (Peticion_idPeticion, TipoCreacion, TituloLibro, DescripcionSolicitud) values (idPeti, 1, tituloLibro, descripcion);
end $$

create procedure aceptarSubidaDeLibro(in idUsuario int, in tituloLibro varchar(70), in descripcion varchar(500))
begin
	declare idPeti int;
	insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 2);
    set idPeti = (select idPeticion from Peticion where Tipo = 2 order by FechaEnvio desc limit 1);
    insert into Creacion (Peticion_idPeticion, TipoCreacion, TituloLibro, DescripcionSolicitud) values (idPeti, 1, tituloLibro, descripcion);
end $$

-- Carpeta

create procedure PeticionCambioCarpeta(in idUsuario int, in documento varchar(500))
begin
	declare idPeti int;
    insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 1);
    set idPeti = (select idPeticion from Peticion where Tipo = 1 order by FechaEnvio desc limit 1);
    insert into Cambio_de_Carpeta (Peticion_idPeticion, Documento) values (idPeti, documento);
end $$

create procedure aceptarCambioDeCarpeta(in idUsuario int, in documento varchar(500))
begin
	declare idPeti int;
    insert into Peticion (Usuario_idUsuario, Tipo) values(idUsuario, 1);
    set idPeti = (select idPeticion from Peticion where Tipo = 1 order by FechaEnvio desc limit 1);
    insert into Cambio_de_Carpeta (Peticion_idPeticion, Documento) values (idPeti, documento);
end $$

CREATE PROCEDURE crear_asignarCarpeta(in idusuario int)
BEGIN
    DECLARE idCarp INT;
    INSERT INTO Carpeta (Descripcion) VALUES ('Nueva Carpeta');
    SET idCarp = (SELECT idCarpeta FROM Carpeta ORDER BY idCarpeta DESC LIMIT 1);
    UPDATE Usuario SET Carpeta_idCarpeta = idCarp WHERE idUsuario = idusuario;
END $$

-- Anuncio

create procedure subirAnuncio (in AdminId int, in titulo VARCHAR(80), in link LONGBLOB, in descripcion VARCHAR(200), in fechaFin date, in publicoObjetivo varchar(45), in categoria varchar(80))
begin
	declare idPub int;
	insert into Publicacion (Administrador_Usuario_idUsuario, Titulo, LinkImagen, Descripcion, FechaFinalizacion, Tipo) values(AdminId, titulo, link, descripcion, fechaFin, 0); -- 0 porque es anuncio
    set idPub = (select idPublicacion from Publicacion order by FechaPublicacion desc limit 1);
	insert into Anuncio (Publicacion_idPublicacion, PublicoObjetivo, Categoria) values (idPub, publicoObjetivo, categoria);
end$$

/*****************************************************************/
/*************************** Functions ***************************/
/*****************************************************************/

/******************************************************************/
/**************************** Triggers ****************************/
/******************************************************************/

-- Triggers para Carpeta
CREATE TRIGGER contar_usuarios_nuevo AFTER INSERT ON Usuario FOR EACH ROW
BEGIN
	UPDATE Carpeta 
    SET Comuneros = Comuneros + 1
    WHERE idCarpeta = NEW.Carpeta_idCarpeta;
END $$

CREATE TRIGGER contar_usuarios_eliminando AFTER DELETE ON Usuario FOR EACH ROW
BEGIN
	UPDATE Carpeta 
    SET Comuneros = Comuneros - 1
    WHERE idCarpeta = OLD.Carpeta_idCarpeta;
END $$

-- cuando se acepta una peticion en ingreso convocatoria, que se reste 1 a los cupos en la convocatoria
CREATE TRIGGER cupos_conv AFTER UPDATE ON Peticion FOR EACH ROW
BEGIN
    IF NEW.Estado = 1 THEN
		UPDATE Convocatoria
        SET Cupos = Cupos - 1
		WHERE Publicacion_idPublicacion = (SELECT Publicacion_idPublicacion FROM Ingreso WHERE Peticion_idPeticion = NEW.idPeticion);
	END IF;
END $$

-- contar cantidad de convocatorias en las que está un usuario
CREATE TRIGGER contar_convo_userN AFTER INSERT ON Convocatoria_has_Usuario FOR EACH ROW
BEGIN
    UPDATE Usuario
    SET Inscripciones = (SELECT COUNT(*) FROM Convocatoria_has_Usuario WHERE Usuario_idUsuario = NEW.Usuario_idUsuario)
    WHERE idUsuario = NEW.Usuario_idUsuario;
END $$

CREATE TRIGGER contar_convo_userE AFTER DELETE ON Convocatoria_has_Usuario FOR EACH ROW
BEGIN
	UPDATE Usuario
    SET Inscripciones = (SELECT COUNT(*) FROM Convocatoria_has_Usuario WHERE Usuario_idUsuario = OLD.Usuario_idUsuario)
    WHERE idUsuario = OLD.Usuario_idUsuario;
END $$

-- contar cantidad de grupos en los que está un usuario
CREATE TRIGGER contar_grupos_userN AFTER INSERT ON Grupo_has_Usuario FOR EACH ROW
BEGIN
    UPDATE Usuario
    SET Grupos = (SELECT COUNT(*) FROM Grupo_has_Usuario WHERE Usuario_idUsuario = NEW.Usuario_idUsuario)
    WHERE idUsuario = NEW.Usuario_idUsuario;
END $$
CREATE TRIGGER contar_grupos_userE AFTER DELETE ON Grupo_has_Usuario FOR EACH ROW
BEGIN
	UPDATE Usuario
    SET Grupos = (SELECT COUNT(*) FROM Grupo_has_Usuario WHERE Usuario_idUsuario = OLD.Usuario_idUsuario)
    WHERE idUsuario = OLD.Usuario_idUsuario;
END $$

-- contar cantidad usuarios en un grupo
CREATE TRIGGER contar_usuarios_grupoN AFTER INSERT ON Grupo_has_Usuario FOR EACH ROW
BEGIN
	UPDATE Grupo
    SET Miembros = (select count(idUsuario) from Usuario JOIN Grupo_has_Usuario JOIN grupo where idGrupo = NEW.Grupo_idGrupo)
    WHERE idGrupo = NEW.Grupo_idGrupo;
END $$
CREATE TRIGGER contar_usuarios_grupoE AFTER DELETE ON Grupo_has_Usuario FOR EACH ROW
BEGIN
	UPDATE Grupo
    SET Miembros = (select count(idUsuario) from Usuario JOIN Grupo_has_Usuario JOIN grupo where idGrupo = OLD.Grupo_idGrupo)
    WHERE idGrupo = OLD.Grupo_idGrupo;
END $$

-- cuando una peticion cambio de carpeta sea aceptado, crear una carpeta nueva y añadir al usuario
CREATE TRIGGER cambio_carpeta_aceptado AFTER UPDATE ON Peticion FOR EACH ROW
BEGIN
	IF NEW.Estado = 1 AND OLD.Estado =! 1 AND NEW.Tipo = 3 THEN
		call crear_asignarCarpeta(NEW.Usuario_idUsuario);
	END IF;
END $$

-- cambiar nombre del admin de la peticion cuando sea revisada
/*CREATE TRIGGER nombre_admin_peti AFTER UPDATE ON Peticion FOR EACH ROW
BEGIN 
	IF NEW.Estado = 1 THEN
		SET NEW.Administrador_Usuario_idUsuario = (SELECT idUsuario FROM Usuario WHERE nombreUsuario = USER())
	END IF;
END $$*/

-- contar cantidad de peticiones aceptadas de un admin

-- contar cantidad de peticiones rechazadas de un admin

-- contar cantidad publicaciones creadas por un admin
delimiter ;


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
(2, 'David', 'Velandia', 'ADMIN', 'julian.neuta01@gmail.com', NULL, NULL, 'Mariana', 'Cobos', '1987-08-19', 'Lider Social'),
(1, 'Tomas', 'Bermudez', 'ADMIN', 'bermudeztomas06@gmail.com', 'Jair', 'Bermudez', 'Deysi', 'Giovanna', '2006-01-05', 'Estudiante');

-- Administrador --
-- drop table if exists Administrador;
INSERT INTO Administrador (Usuario_idUsuario, nivelPermiso) VALUES 
(10, 2),
(11, 3),
(12, 4),
(13, 5),
(14, 5),
(15, 6),
(16, 1),
(17, 2),
(18, 2), 
(19, 2),
(20, 2), 
(21, 2),
(22, 6); 

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
INSERT INTO Peticion (Usuario_idUsuario, FechaEnvio, Tipo)
VALUES
(10, NOW(), 1),  -- Petición de ingreso a convocatoria
(8, NOW(),  1),   -- Petición de ingreso a grupo
(17, NOW(), 2),  -- Petición de creación de libro
(18, NOW(), 2),  -- Petición de creación de grupo
(9, NOW(), 3),   -- Petición de cambio de carpeta
(7, NOW(), 1),   -- Petición de ingreso a convocatoria
(12, NOW(), 2);  -- Petición de creación de libro


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