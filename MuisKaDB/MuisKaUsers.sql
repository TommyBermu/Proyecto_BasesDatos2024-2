use muiska;
/**************************************************************/
create user 'usuario'@'localhost' identified by 'usuario';

-- GRANT SELECT ON MuisKa.Usuario TO 'usuario'@'localhost';
GRANT SELECT ON MuisKa.Libro TO 'usuario'@'localhost';
GRANT SELECT ON MuisKa.Publicacion TO 'usuario'@'localhost';
GRANT SELECT ON MuisKa.Convocatoria TO 'usuario'@'localhost';
GRANT SELECT ON MuisKa.Anuncio TO 'usuario'@'localhost';
GRANT DELETE ON MuisKa.Grupo_has_Usuario TO 'usuario'@'localhost';

-- Permisos en vistas
GRANT SELECT, UPDATE, DELETE ON MuisKa.Vista_Peticion_Usuario_Ingreso TO 'usuario'@'localhost'; 
GRANT SELECT, UPDATE, DELETE ON MuisKa.Vista_Datos_Personales TO 'usuario'@'localhost'; 

/**************************************************************/
create user 'preferente'@'localhost' identified by 'preferente';

GRANT SELECT ON MuisKa.Usuario TO 'preferente'@'localhost';
GRANT SELECT ON MuisKa.Libro TO 'preferente'@'localhost';
GRANT SELECT ON MuisKa.Publicacion TO 'preferente'@'localhost';
GRANT SELECT ON MuisKa.Convocatoria TO 'preferente'@'localhost';
GRANT SELECT ON MuisKa.Anuncio TO 'preferente'@'localhost';
GRANT DELETE ON MuisKa.Grupo_has_Usuario TO 'preferente'@'localhost';

-- Permisos en vistas
GRANT SELECT ON MuisKa.Vista_Administrador_Preferente TO 'preferente'@'localhost';
GRANT SELECT, UPDATE, DELETE ON MuisKa.Vista_Datos_Personales TO 'preferente'@'localhost';

/**************************************************************/
create user 'librero'@'localhost' identified by 'librero';

GRANT SELECT, INSERT, UPDATE, DELETE ON MuisKa.Libro TO 'librero'@'localhost';
GRANT SELECT ON MuisKa.Usuario TO 'librero'@'localhost';
GRANT SELECT ON MuisKa.Publicacion TO 'librero'@'localhost';

-- Permisos en vistas
GRANT SELECT, UPDATE ON MuisKa.Vista_Peticion_Creacion_Libro TO 'librero'@'localhost';

/**************************************************************/
create user 'comunicador'@'localhost' identified by 'comunicador';

GRANT SELECT, INSERT, UPDATE, DELETE ON MuisKa.Publicacion TO 'comunicador'@'localhost';
GRANT SELECT ON MuisKa.Usuario TO 'comunicador'@'localhost';
GRANT SELECT ON MuisKa.Convocatoria TO 'comunicador'@'localhost';
GRANT SELECT ON MuisKa.Anuncio TO 'comunicador'@'localhost';

-- Permisos en vistas
GRANT SELECT, UPDATE ON MuisKa.Vista_Peticion_Ingreso_Convocatoria TO 'comunicador'@'localhost';

/**************************************************************/
create user 'gestorGrupo'@'localhost' identified by 'gestorGrupo';

GRANT SELECT, INSERT, UPDATE, DELETE ON MuisKa.Grupo TO 'gestorGrupo'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MuisKa.Peticion TO 'gestorGrupo'@'localhost';
GRANT SELECT, INSERT, DELETE ON MuisKa.Grupo_has_Usuario TO 'gestorGrupo'@'localhost';
GRANT SELECT ON MuisKa.Usuario TO 'gestorGrupo'@'localhost';

-- Permisos en vistas
GRANT SELECT, UPDATE ON MuisKa.Vista_Peticion_Ingreso_Grupo TO 'gestorGrupo'@'localhost';
GRANT SELECT ON MuisKa.Vista_Grupo_Gestor_De_Grupos TO 'gestorGrupo'@'localhost';

/**************************************************************/
create user 'creadorGrupos'@'localhost' identified by 'creadorGrupos';

GRANT SELECT, INSERT, UPDATE, DELETE ON MuisKa.Grupo TO 'creadorGrupos'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON MuisKa.Peticion TO 'creadorGrupos'@'localhost';
GRANT SELECT, INSERT, DELETE ON MuisKa.Grupo_has_Usuario TO 'creadorGrupos'@'localhost';
GRANT SELECT ON MuisKa.Usuario TO 'creadorGrupos'@'localhost';

-- Permisos en vistas
GRANT SELECT, UPDATE ON MuisKa.Vista_Peticion_Creacion_Grupo TO 'creadorGrupos'@'localhost';

/**************************************************************/
create user 'Admin'@'localhost' identified by 'Admin';
GRANT ALL PRIVILEGES ON MuisKa.* TO 'Admin'@'localhost';
