use muiska;
-- Creación de las vistas
DROP VIEW IF EXISTS Vista_Peticion_Ingreso_Grupo;
CREATE VIEW Vista_Peticion_Ingreso_Grupo AS
SELECT 
    i.Peticion_idPeticion AS id_peticion,
    p.Administrador_Usuario_idUsuario AS id_administrador_peticion, 
    p.Usuario_idUsuario AS id_usuario, 
    p.FechaEnvio AS fecha_envio, 
    p.Estado AS estado, 
    p.Tipo AS tipo, 
    -- i.CartaMotivacion AS carta_motivacion, 
    i.Grupo_idGrupo AS id_grupo
FROM Ingreso i
JOIN Peticion p ON i.Peticion_idPeticion = p.idPeticion
WHERE i.Grupo_idGrupo IS NOT NULL;

DROP VIEW IF EXISTS Vista_Peticion_Ingreso_Convocatoria;
CREATE VIEW Vista_Peticion_Ingreso_Convocatoria AS
SELECT 
    i.Peticion_idPeticion AS id_peticion,
    p.Administrador_Usuario_idUsuario AS id_administrador_peticion, 
    p.Usuario_idUsuario AS id_usuario, 
    p.FechaEnvio, 
    p.Estado,
    p.Tipo,
    -- i.CartaMotivacion, 
    i.Convocatoria_Publicacion_idPublicacion
FROM Ingreso i
JOIN Peticion p ON i.Peticion_idPeticion = p.idPeticion
WHERE i.Convocatoria_Publicacion_idPublicacion IS NOT NULL;

DROP VIEW IF EXISTS Vista_Peticion_Creacion_Libro;
CREATE VIEW Vista_Peticion_Creacion_Libro AS
SELECT 
    c.Peticion_idPeticion AS id_peticion,
    p.Administrador_Usuario_idUsuario AS id_admin, 
    p.Usuario_idUsuario AS id_usuario, 
    p.FechaEnvio,
    p.Estado,
    c.TituloLibro, 
    c.DescripcionSolicitud
FROM Creacion c
JOIN Peticion p ON c.Peticion_idPeticion = p.idPeticion
WHERE c.Titulolibro is not null;

DROP VIEW IF EXISTS Vista_Peticion_Creacion_Grupo;
CREATE VIEW Vista_Peticion_Creacion_Grupo AS
SELECT 
    c.Peticion_idPeticion AS id_peticion,
    p.Administrador_Usuario_idUsuario AS id_admin, 
    p.Usuario_idUsuario AS id_usuario, 
    p.FechaEnvio,
    p.Estado,
    c.NombreGrupo, 
    c.DescripcionSolicitud
FROM Creacion c
JOIN Peticion p ON c.Peticion_idPeticion = p.idPeticion
WHERE c.NombreGrupo is not null;

DROP VIEW IF EXISTS Vista_Administrador_Preferente;
CREATE VIEW Vista_Administrador_Preferente AS SELECT  Usuario_idUsuario AS id_administrador, nivelPermiso, peticionesAceptadas,  peticionesRechazadas, 
gruposGestionados, publicacionesCreadas FROM Administrador WHERE Usuario_idUsuario = CURRENT_USER();

DROP VIEW IF EXISTS Vista_Grupo_Gestor_De_Grupos;
CREATE VIEW Vista_Grupo_Gestor_De_Grupos AS SELECT idGrupo,Nombre,Descripcion,Miembros,Acceso,linkPortada, Administrador_Usuario_idUsuario AS id_gestor
FROM Grupo WHERE Administrador_Usuario_idUsuario = CURRENT_USER();

DROP VIEW IF EXISTS Vista_Peticion_Usuario_Ingreso;
CREATE VIEW Vista_Peticion_Usuario_Ingreso AS
SELECT 
    i.Peticion_idPeticion AS id_peticion, p.Administrador_Usuario_idUsuario AS id_admin, p.Usuario_idUsuario AS id_usuario, p.FechaEnvio, p.Estado,
    p.Tipo AS tipo, i.Grupo_idGrupo, i.Convocatoria_Publicacion_idPublicacion AS id_convocatoria
FROM Ingreso i JOIN Peticion p ON i.Peticion_idPeticion = p.idPeticion WHERE p.Usuario_idUsuario = CURRENT_USER();

DROP VIEW IF EXISTS creación_preferente;
CREATE VIEW creación_preferente AS SELECT c.Peticion_idPeticion AS id_peticion, p.Administrador_Usuario_idUsuario AS id_admin, p.Usuario_idUsuario AS id_usuario, 
p.FechaEnvio, p.Estado, p.Tipo,
c.TituloLibro, c.NombreGrupo, c.DescripcionSolicitud FROM Creacion c JOIN Peticion p ON c.Peticion_idPeticion = p.idPeticion
WHERE p.Usuario_idUsuario = CURRENT_USER();

DROP VIEW IF EXISTS Vista_Datos_Personales;
CREATE VIEW Vista_Datos_Personales AS SELECT idUsuario,Nombre,Apellidos,Cargo,Email,nombrePadre,apellidosPadre,nombreMadre,apellidosMadre,Grupos,
fechaNacimiento,Profesion FROM Usuario WHERE idUsuario = CURRENT_USER();
