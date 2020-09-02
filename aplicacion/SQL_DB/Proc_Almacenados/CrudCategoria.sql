/*
 * Script de la tabla Categoria 
 * stp de insertar  	        -> stp_insertarCategoria
 * stp de modificar 	        -> stp_modificarCategoria
 * stp de cambiar estado        -> stp_cambiarEstadoCategoria
 * stp de mostrar una categoria -> stp_stp_mostrarCategoria
 */
 
-- stp insertar
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertarCategoria`(
IN  $nombreCate VARCHAR(45),
IN  $descrip    TEXT,
IN  $estado     VARCHAR(10)
-- OUT $mensaje    VARCHAR(50),
-- OUT $insertado  BOOLEAN
)
BEGIN
	
    IF NOT EXISTS (SELECT nombreCate FROM Categoria WHERE nombreCate = $nombreCate) THEN
       
        INSERT INTO Categoria (nombreCate,descripcion,estado) 
			VALUES ($nombreCate, $descrip,$estado);
-- 		SET $insertado = 1;
-- 		SET $mensaje = 'Categoria registrada.';
-- 	ELSE
-- 		SET $insertado = 0;
--      SET $mensaje = 'Ya existe una categoría con este nombre.';
    END IF;
END //
DELIMITER ;

-- stp de modificar 
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_modificarCategoria`(
IN  $idCate 	INT,
IN  $nomCate 	VARCHAR(45),
IN  $descrip 	TEXT,
IN  $estado 	VARCHAR(10)
-- OUT $modificado BOOLEAN,
-- OUT $mensaje    VARCHAR(50)
)
BEGIN
	IF EXISTS (SELECT idCategoria FROM Categoria WHERE idCategoria = $idCate) THEN
        
		UPDATE Categoria SET
				nombreCate    = $nomCate,
                descripcion   = $descrip,
                estado 	      = $estado
			WHERE idCategoria = $idCate;
		
-- 		SET $modificado     = 1;
--      SET $mensaje 		= 'Categoría modificada';
--    ELSE
--        SET $mensaje 		= 'Error. Categoría no encontrada.';
--        SET $modificado 	= 0;
    END IF;
END //
DELIMITER ;

-- stp de modificar estado 
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadoCategoria`(
IN  $idCate     INT
-- OUT $mensaje 	VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el usuario existe y si existe obtenemos su estado
		IF EXISTS (SELECT idCategoria FROM Categoria WHERE idCategoria = $idCate) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM Categoria WHERE idCategoria = $idCate);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'Categoría desactivada.';
                
            ELSE
            
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'Categoría activada.';
                
            END IF;
			
            UPDATE Categoria SET estado = estadoActual WHERE idCategoria = $idCate;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. Categoría no encontrada.';
-- 			SET $encontrado = 0;
		END IF;
END //
DELIMITER ;

-- stp mostrar Categoria
DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_mostrarCategoria`(
 IN  $idCate   	 INT
-- OUT $mensaje    VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
	IF ((SELECT COUNT(idCategoria) FROM Categoria
			WHERE idCategoria = $idCate) > 0) THEN
    
		SELECT idCategoria, nombreCate, descripcion, estado, nombreFoto FROM Categoria
			WHERE idCategoria = $idCate;
--        SET $mensaje = 'Categoría encontrada.';
--        SET $encontrado = 1;
-- 	ELSE
-- 		SET $mensaje = 'Categoría no encontrada.';
--      SET $encontrado = 0;
    END IF;
END //
DELIMITER ;

-- Nuevos procedimientos para cargar las fotos

-- PROCEDIMIENTOS PARA INSERTAR UNA IMAGEN
DELIMITER $$
CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_cambiar_foto_categoria`(
IN $id INT(45),
IN $foto LONGBLOB,
IN $nombreFoto TEXT
)
BEGIN
	IF EXISTS (SELECT `idCategoria` FROM `Categoria` WHERE `idCategoria` = $id) THEN
		UPDATE `Categoria` SET
			`foto` 		= $foto,
            `nombreFoto` = $nombreFoto
        WHERE `idCategoria` = $id;
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_obtener_foto_categoria`(
IN $id INT(45)
)
BEGIN
	IF EXISTS (SELECT `idCategoria` FROM `Categoria` WHERE `idCategoria` = $id) THEN
		SELECT `foto` FROM `Categoria` WHERE `idCategoria` = $id;
    END IF;
END $$
DELIMITER ;


DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertar_categoria_foto`(
IN $nombreCate VARCHAR(45),
IN $descrip    TEXT,
IN $estado     VARCHAR(10),
IN $foto 	   LONGBLOB,
IN $nombreFoto TEXT
-- OUT $mensaje    VARCHAR(50),
-- OUT $insertado  BOOLEAN
)
BEGIN
	
    IF NOT EXISTS (SELECT nombreCate FROM Categoria WHERE nombreCate = $nombreCate) THEN
       
        INSERT INTO Categoria (nombreCate,descripcion,estado, foto, nombreFoto) 
			VALUES ($nombreCate, $descrip,$estado, $foto, $nombreFoto);
-- 		SET $insertado = 1;
-- 		SET $mensaje = 'Categoria registrada.';
-- 	ELSE
-- 		SET $insertado = 0;
--      SET $mensaje = 'Ya existe una categoría con este nombre.';
    END IF;
END //
DELIMITER ;