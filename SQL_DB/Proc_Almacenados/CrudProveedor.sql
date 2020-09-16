/* 
 * Script de la tabla Proveedor
 * stp insertar       	    -> stp_insertarProveedor
 * stp cambiar estado  	    -> stp_cambiarEstadoProveedor
 * stp modificar	  	    -> stp_modificarProveedor
 * stp mostrar un proveedor -> stp_mostrarProveedor
 */
 
 -- stp insertar
 DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_insertarProveedor`(
 IN  $cedula     VARCHAR(30),
 IN  $empresa    VARCHAR(50),
 IN  $telefono   VARCHAR(14),
 IN  $estado 	 VARCHAR(10),
 IN  $direccion  TEXT,
 IN  $descripcion TEXT
 -- OUT $registrado BOOLEAN,
 -- OUT $mensaje    VARCHAR(50)
 )
 BEGIN
    
-- Verificamos que la cedula no exista, a pesar de que esta no es la PK de la tabla
    IF NOT EXISTS (SELECT cedulaJuridi FROM Proveedor WHERE cedulaJuridi = $cedula) THEN
    
		INSERT INTO Proveedor (cedulaJuridi, empresa, direccion, telefono, estado, descripcion) 
			VALUES ($cedula, $empresa, $direccion, $telefono, $estado, $descripcion);
        
-- 		 SET $registrado = 1;
--       SET $mensaje = 'Proveedor registrado exitosamente.';
        
-- 	ELSE 
-- 		SET $registrado = 0;
--      SET $mensaje = 'Error. Proveedor ya existe';
	END IF;
 END //
 DELIMITER ;
 
 -- stp cambiar estado
 DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadoProveedor`(
 IN  $pidProveedor INT
 -- OUT $encontrado   BOOLEAN,
 -- OUT $mensaje  	   VARCHAR(50)
 )
 BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el usuario existe y si existe obtenemos su estado
		IF EXISTS (SELECT estado  FROM Proveedor 
			WHERE idProveedor = $pidProveedor) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM Proveedor
				WHERE idProveedor = $pidProveedor);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'Proveedor desactivado.';
                
            ELSE
            
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'Proveedor activado.';
                
            END IF;
			
            UPDATE Proveedor SET estado = estadoActual 
				WHERE idProveedor = $pidProveedor;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. Proveedor no existe.';
-- 			SET $encontrado = 0;
		END IF;
 END //
 DELIMITER ;
 
 
-- stp Modificar
DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_modificarProveedor`(
 IN  $id		 INT,
 IN  $cedula     VARCHAR(30),
 IN  $empresa    VARCHAR(50),
 IN  $telefono   VARCHAR(14),
 IN  $estado 	 VARCHAR(10),
 IN  $direccion  TEXT,
 IN  $descripcion TEXT
 -- OUT $peditado     BOOLEAN,
 -- OUT $mensaje      VARCHAR(50)
 )
 BEGIN
 
	IF EXISTS (SELECT idProveedor FROM Proveedor
			   WHERE idProveedor = $id) THEN
               
			UPDATE Proveedor SET
					empresa		 = $empresa,
					direccion 	 = $direccion,
                    estado 	     = $estado,
					telefono 	 = $telefono,
                    descripcion  = $descripcion
			WHERE idProveedor    = $id AND cedulaJuridi = $cedula;
-- 			SET $peditado = 1;
--             SET $mensaje  = 'Proveedor modificado.';
-- 	ELSE 
-- 		SET $peditado = 0;
--      SET $mensaje  = 'Error. Proveedor no existe.';
    END IF;
 END //
 DELIMITER ;

-- stp mostrar Proveedor
DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_mostrarProveedor`(
 IN  $pidProveedor INT
 -- OUT $mensaje      VARCHAR(50),
 -- OUT $encontrado   BOOLEAN
)
BEGIN
	IF ((SELECT COUNT(cedulaJuridi) FROM Proveedor
			WHERE idProveedor = $pidProveedor) > 0) THEN
    
		SELECT idProveedor, cedulaJuridi, empresa AS `nom. empresa`,
            telefono, direccion, descripcion, estado FROM Proveedor
			WHERE idProveedor = $pidProveedor;
--        SET $mensaje 	= 'Proveedor encontrado';
--        SET $encontrado = 1;
-- 	ELSE
-- 		SET $mensaje 	= 'Proveedor solicitado no existe.';
--        SET $encontrado = 0;
    END IF;
END //
DELIMITER ;
