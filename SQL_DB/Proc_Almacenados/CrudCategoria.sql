/*
 * Script de la tabla categoria 
 * stp de insertar  	        -> stp_insertarcategoria
 * stp de modificar 	        -> stp_modificarcategoria
 * stp de cambiar estado        -> stp_cambiarEstadocategoria
 * stp de mostrar una categoria -> stp_stp_mostrarcategoria
 */
 
-- stp insertar
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertarcategoria`(
IN  $nombreCate VARCHAR(45),
IN  $descrip    TEXT,
IN  $estado     VARCHAR(10)
-- OUT $mensaje    VARCHAR(50),
-- OUT $insertado  BOOLEAN
)
BEGIN
	
    IF NOT EXISTS (SELECT nombreCate FROM categoria WHERE nombreCate = $nombreCate) THEN
       
        INSERT INTO categoria (nombreCate,descripcion,estado) 
			VALUES ($nombreCate, $descrip,$estado);
-- 		SET $insertado = 1;
-- 		SET $mensaje = 'categoria registrada.';
-- 	ELSE
-- 		SET $insertado = 0;
--      SET $mensaje = 'Ya existe una categoría con este nombre.';
    END IF;
END //
DELIMITER ;

-- stp de modificar 
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_modificarcategoria`(
IN  $idCate 	INT,
IN  $nomCate 	VARCHAR(45),
IN  $descrip 	TEXT,
IN  $estado 	VARCHAR(10)
-- OUT $modificado BOOLEAN,
-- OUT $mensaje    VARCHAR(50)
)
BEGIN
	IF EXISTS (SELECT idcategoria FROM categoria WHERE idcategoria = $idCate) THEN
        
		UPDATE categoria SET
				nombreCate    = $nomCate,
                descripcion   = $descrip,
                estado 	      = $estado
			WHERE idcategoria = $idCate;
		
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
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadocategoria`(
IN  $idCate     INT
-- OUT $mensaje 	VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el usuario existe y si existe obtenemos su estado
		IF EXISTS (SELECT idcategoria FROM categoria WHERE idcategoria = $idCate) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM categoria WHERE idcategoria = $idCate);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'Categoría desactivada.';
                
            ELSE
            
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'Categoría activada.';
                
            END IF;
			
            UPDATE categoria SET estado = estadoActual WHERE idcategoria = $idCate;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. Categoría no encontrada.';
-- 			SET $encontrado = 0;
		END IF;
END //
DELIMITER ;

-- stp mostrar categoria
DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_mostrarcategoria`(
 IN  $idCate   	 INT
-- OUT $mensaje    VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
	IF ((SELECT COUNT(idcategoria) FROM categoria
			WHERE idcategoria = $idCate) > 0) THEN
    
		SELECT idcategoria, nombreCate, descripcion, estado, nombreFoto FROM categoria
			WHERE idcategoria = $idCate;
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
	IF EXISTS (SELECT `idcategoria` FROM `categoria` WHERE `idcategoria` = $id) THEN
		UPDATE `categoria` SET
			`foto` 		= $foto,
            `nombreFoto` = $nombreFoto
        WHERE `idcategoria` = $id;
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_obtener_foto_categoria`(
IN $id INT(45)
)
BEGIN
	IF EXISTS (SELECT `idcategoria` FROM `categoria` WHERE `idcategoria` = $id) THEN
		SELECT `foto` FROM `categoria` WHERE `idcategoria` = $id;
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
	
    IF NOT EXISTS (SELECT nombreCate FROM categoria WHERE nombreCate = $nombreCate) THEN
       
        INSERT INTO categoria (nombreCate,descripcion,estado, foto, nombreFoto) 
			VALUES ($nombreCate, $descrip,$estado, $foto, $nombreFoto);
-- 		SET $insertado = 1;
-- 		SET $mensaje = 'categoria registrada.';
-- 	ELSE
-- 		SET $insertado = 0;
--      SET $mensaje = 'Ya existe una categoría con este nombre.';
    END IF;
END //
DELIMITER ;