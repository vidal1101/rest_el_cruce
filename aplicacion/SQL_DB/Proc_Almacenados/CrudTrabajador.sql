/*
 * Script de la tabla Trabajador
 * stp de insertar		     -> pa_insertarTrabajador
 * stp de cambiar estado	 -> pa_modificarTrabajador
 * stp de modificar 		 -> pa_cambiarEstadoTrabajador
 * stp de mostrar un usuario -> pa_mostrarTrabajador
 */

-- spt de insertar
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertarTrabajador`(
IN  $cedula     INT,
IN  $nombre     VARCHAR(50),
IN  $puesto     VARCHAR(45),
IN  $contra     TEXT,
IN  $estado		VARCHAR(10)
-- OUT $insertado  BOOLEAN,
-- OUT $mensaje    VARCHAR(50)
)
BEGIN
	IF NOT EXISTS (SELECT cedula FROM 	Trabajador WHERE cedula = $cedula) THEN
		
        INSERT INTO Trabajador (cedula,nombre,puesto,contrasenia,estado)
			VALUES ($cedula, $nombre, $puesto, $contra, $estado);
		
-- 		SET $insertado = 1;
--  	SET $mensaje   = 'Usuario registrado exitosamente.';
--    ELSE
--  		SET $mensaje   = 'Error. Usuario ya existe.';
--         SET $insertado = 0;
        
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_modificarTrabajador`(
IN  $cedula 	INT,
IN  $nombre 	VARCHAR(50),
IN  $puesto 	VARCHAR(45),
IN  $contra 	TEXT,
IN  $estado 	VARCHAR(10)
-- OUT $modificado BOOLEAN,
-- OUT $mensaje    VARCHAR(50)
)
BEGIN

	IF EXISTS (SELECT cedula FROM Trabajador WHERE cedula = $cedula) THEN
		UPDATE Trabajador SET
			  nombre        = $nombre,
              puesto        = $puesto,
              contrasenia   = $contra,
              estado 	    = $estado
		WHERE cedula        = $cedula;
-- 			SET $mensaje    = 'Usuario modificado exitosamente.';
--             SET $modificado = 1;
--     ELSE
-- 		SET $mensaje    = 'Error. Usuario no encontrado.';
--         SET $modificado = 0;
        
    END IF;
END //
DELIMITER ;

-- Cambia el estado de un trabajador
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadoTrabajador`(
IN  $ced 		INT
-- OUT $encontrado BOOLEAN,
-- OUT $mensaje 	VARCHAR(50)
)
BEGIN

-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el usuario existe y si existe obtenemos su estado
		IF EXISTS (SELECT estado  FROM Trabajador WHERE cedula = $ced) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM Trabajador WHERE cedula = $ced);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'Usuario desactivado.';
                
            ELSE
            
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'Usuario activado.';
                
            END IF;
			
            UPDATE Trabajador SET estado = estadoActual WHERE cedula = $ced;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje     ='Error. Usuario no encontrado.';
-- 			SET $encontrado  = 0;
		END IF;
END //
DELIMITER ;

-- Muestra los datos de un trabajador
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarTrabajador`(
IN  $ced     INT
-- OUT $mensaje VARCHAR(50)
)
BEGIN
	IF ((SELECT COUNT(cedula) FROM Trabajador WHERE cedula = $ced) > 0) THEN
    
		SELECT cedula, nombre, puesto, estado FROM Trabajador WHERE cedula = $ced;
--         SET $mensaje = 'Usuario encontrado';
-- 	ELSE
-- 		SET $mensaje = 'Error. Usuario no encontrado';
    END IF;
END //
DELIMITER ;
