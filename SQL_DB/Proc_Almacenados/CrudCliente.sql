/*
 * Script de la tabla cliente
 * stp de insertar			 -> stp_insertarcliente
 * stp de modificar 		 -> stp_modificarcliente
 * stp de cambiar estado     -> stp_cambiarEstadocliente
 * stp de mostrar un cliente -> stp_mostrarcliente
 */
 
-- spt de insertar
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertarcliente`(
IN  $pcedula    VARCHAR(50),
IN  $pnombre    VARCHAR(45),
IN  $pempresa   VARCHAR(50),
IN  $pemail		VARCHAR(50),
IN  $pobser 	TEXT,
IN  $pestado    VARCHAR(10)
-- OUT $pmensaje   VARCHAR(50),
-- OUT $pinsertado BOOLEAN
)
BEGIN
	IF NOT EXISTS (SELECT cedula FROM cliente WHERE cedula = $pcedula) THEN
		
        INSERT INTO cliente (cedula, nombre, empresa, email, observacion, estado)
			VALUES ($pcedula, $pnombre, $pempresa, $pemail, $pobser, $pestado);
-- 		SET $pinsertado = 1;
-- 		SET $pmensaje   = 'cliente registrado.';
        
--    ELSE
		
--        SET $pinsertado = 0;
--        SET $pmensaje   = 'Error. Cédula ya registrada.';
        
    END IF;
END //
DELIMITER ;

-- stp de modificar 
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_modificarcliente`(
IN  $cedula 	VARCHAR(50),
IN  $nombre 	VARCHAR(45),
IN  $empresa	VARCHAR(50),
IN  $email		VARCHAR(50),
IN  $obser 		TEXT,
IN  $estado 	VARCHAR(10)
-- OUT $mensaje    VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
	IF EXISTS (SELECT cedula FROM cliente WHERE cedula = $cedula) THEN
        
		UPDATE cliente SET
				nombre      = $nombre,
                empresa     = $empresa,
                email		= $email,
                estado      = $estado,
                observacion = $obser
			WHERE cedula    = $cedula;
            
--            SET $mensaje    = 'cliente modificado.';
--            SET $encontrado = 1;
--    ELSE
-- 		SET $mensaje    = 'Error. cliente no encontrado.';
--      SET $encontrado = 0;
        
    END IF;
END //
DELIMITER ;

-- stp de cambiar el estado
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadocliente`(
IN  $cedula     VARCHAR(50)
-- OUT $mensaje    VARCHAR(50)
-- OUT $encontrado BOOLEAN
)
BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el usuario existe y si existe obtenemos su estado
		IF EXISTS (SELECT cedula FROM cliente WHERE cedula = $cedula) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM cliente WHERE cedula = $cedula);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'cliente desactivado.';
                
            ELSE
            
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'cliente activado.';
                
            END IF;
			
            UPDATE cliente SET estado = estadoActual WHERE cedula = $cedula;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. cliente no encontrado.';
-- 			SET $encontrado = 0;
		END IF;
END //
DELIMITER ;

-- stp de mostrar un cliente
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarcliente`(
IN  $cedula     VARCHAR(50)
-- OUT $mensaje    VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
	IF ((SELECT COUNT(cedula) FROM cliente 
			WHERE cedula = $cedula) > 0) THEN
    
		SELECT cedula, nombre, empresa, email, observacion, estado FROM cliente WHERE cedula = $cedula;
--         SET $mensaje = 'cliente encontrado.';
--         SET $encontrado = 1;
-- 	ELSE
-- 		SET $mensaje = 'Error. cliente no encontrado.';
--      SET $encontrado = 0;
    END IF;
END //
DELIMITER ;
