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

create procedure aceptarEnConvocatoria(in idAdmin int, in idUsuario int, in idPublicacion int, in idPet int, in acc boolean)
begin
	update Peticion set Administrador_Usuario_idUsuario = idAdmin, Estado = acc where idPeticion = idPet;
    if (acc) then
		insert into Convocatoria_has_Usuario values (idPublicacion, idUsuario);
	end if;
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

-- cuando una peticion sea acepatada o rechazada, setear la fecha de revision 
CREATE TRIGGER revision_fecha_peti AFTER UPDATE ON Peticion FOR EACH ROW
BEGIN
	IF NEW.Estado = 1 OR NEW.Estado= 0 THEN
		UPDATE Peticion SET FechaRevision = current_timestamp WHERE idPeticion = NEW.idPeticion;
	END IF;
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