-- DROP DATABASE MuisKa;
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
    nivelPermiso INT NOT NULL,
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