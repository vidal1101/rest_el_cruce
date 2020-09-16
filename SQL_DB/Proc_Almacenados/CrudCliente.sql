/*
 * Script de la tabla Cliente
 * stp de insertar			 -> stp_insertarCliente
 * stp de modificar 		 -> stp_modificarCliente
 * stp de cambiar estado     -> stp_cambiarEstadoCliente
 * stp de mostrar un cliente -> stp_mostrarCliente
 */
 
-- spt de insertar
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertarCliente`(
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
	IF NOT EXISTS (SELECT cedula FROM Cliente WHERE cedula = $pcedula) THEN
		
        INSERT INTO Cliente (cedula, nombre, empresa, email, observacion, estado)
			VALUES ($pcedula, $pnombre, $pempresa, $pemail, $pobser, $pestado);
-- 		SET $pinsertado = 1;
-- 		SET $pmensaje   = 'Cliente registrado.';
        
--    ELSE
		
--        SET $pinsertado = 0;
--        SET $pmensaje   = 'Error. Cédula ya registrada.';
        
    END IF;
END //
DELIMITER ;

-- stp de modificar 
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_modificarCliente`(
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
	IF EXISTS (SELECT cedula FROM Cliente WHERE cedula = $cedula) THEN
        
		UPDATE Cliente SET
				nombre      = $nombre,
                empresa     = $empresa,
                email		= $email,
                estado      = $estado,
                observacion = $obser
			WHERE cedula    = $cedula;
            
--            SET $mensaje    = 'Cliente modificado.';
--            SET $encontrado = 1;
--    ELSE
-- 		SET $mensaje    = 'Error. Cliente no encontrado.';
--      SET $encontrado = 0;
        
    END IF;
END //
DELIMITER ;

-- stp de cambiar el estado
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadoCliente`(
IN  $cedula     VARCHAR(50)
-- OUT $mensaje    VARCHAR(50)
-- OUT $encontrado BOOLEAN
)
BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el usuario existe y si existe obtenemos su estado
		IF EXISTS (SELECT cedula FROM Cliente WHERE cedula = $cedula) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM Cliente WHERE cedula = $cedula);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'Cliente desactivado.';
                
            ELSE
            
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'Cliente activado.';
                
            END IF;
			
            UPDATE Cliente SET estado = estadoActual WHERE cedula = $cedula;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. Cliente no encontrado.';
-- 			SET $encontrado = 0;
		END IF;
END //
DELIMITER ;

-- stp de mostrar un cliente
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarCliente`(
IN  $cedula     VARCHAR(50)
-- OUT $mensaje    VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
	IF ((SELECT COUNT(cedula) FROM Cliente 
			WHERE cedula = $cedula) > 0) THEN
    
		SELECT cedula, nombre, empresa, email, observacion, estado FROM Cliente WHERE cedula = $cedula;
--         SET $mensaje = 'Cliente encontrado.';
--         SET $encontrado = 1;
-- 	ELSE
-- 		SET $mensaje = 'Error. Cliente no encontrado.';
--      SET $encontrado = 0;
    END IF;
END //
DELIMITER ;
