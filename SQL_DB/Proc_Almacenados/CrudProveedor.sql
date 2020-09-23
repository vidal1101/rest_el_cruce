/* 
 * Script de la tabla proveedor
 * stp insertar       	    -> stp_insertarproveedor
 * stp cambiar estado  	    -> stp_cambiarEstadoproveedor
 * stp modificar	  	    -> stp_modificarproveedor
 * stp mostrar un proveedor -> stp_mostrarproveedor
 */
 
 -- stp insertar
 DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_insertarproveedor`(
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
    IF NOT EXISTS (SELECT cedulaJuridi FROM proveedor WHERE cedulaJuridi = $cedula) THEN
    
		INSERT INTO proveedor (cedulaJuridi, empresa, direccion, telefono, estado, descripcion) 
			VALUES ($cedula, $empresa, $direccion, $telefono, $estado, $descripcion);
        
-- 		 SET $registrado = 1;
--       SET $mensaje = 'proveedor registrado exitosamente.';
        
-- 	ELSE 
-- 		SET $registrado = 0;
--      SET $mensaje = 'Error. proveedor ya existe';
	END IF;
 END //
 DELIMITER ;
 
 -- stp cambiar estado
 DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadoproveedor`(
 IN  $pidproveedor INT
 -- OUT $encontrado   BOOLEAN,
 -- OUT $mensaje  	   VARCHAR(50)
 )
 BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el usuario existe y si existe obtenemos su estado
		IF EXISTS (SELECT estado  FROM proveedor 
			WHERE idproveedor = $pidproveedor) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM proveedor
				WHERE idproveedor = $pidproveedor);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'proveedor desactivado.';
                
            ELSE
            
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'proveedor activado.';
                
            END IF;
			
            UPDATE proveedor SET estado = estadoActual 
				WHERE idproveedor = $pidproveedor;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. proveedor no existe.';
-- 			SET $encontrado = 0;
		END IF;
 END //
 DELIMITER ;
 
 
-- stp Modificar
DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_modificarproveedor`(
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
 
	IF EXISTS (SELECT idproveedor FROM proveedor
			   WHERE idproveedor = $id) THEN
               
			UPDATE proveedor SET
					empresa		 = $empresa,
					direccion 	 = $direccion,
                    estado 	     = $estado,
					telefono 	 = $telefono,
                    descripcion  = $descripcion
			WHERE idproveedor    = $id AND cedulaJuridi = $cedula;
-- 			SET $peditado = 1;
--             SET $mensaje  = 'proveedor modificado.';
-- 	ELSE 
-- 		SET $peditado = 0;
--      SET $mensaje  = 'Error. proveedor no existe.';
    END IF;
 END //
 DELIMITER ;

-- stp mostrar proveedor
DELIMITER //
 CREATE DEFINER = `adminRestBar`@`localhost` PROCEDURE `stp_mostrarproveedor`(
 IN  $pidproveedor INT
 -- OUT $mensaje      VARCHAR(50),
 -- OUT $encontrado   BOOLEAN
)
BEGIN
	IF ((SELECT COUNT(cedulaJuridi) FROM proveedor
			WHERE idproveedor = $pidproveedor) > 0) THEN
    
		SELECT idproveedor, cedulaJuridi, empresa AS `nom. empresa`,
            telefono, direccion, descripcion, estado FROM proveedor
			WHERE idproveedor = $pidproveedor;
--        SET $mensaje 	= 'proveedor encontrado';
--        SET $encontrado = 1;
-- 	ELSE
-- 		SET $mensaje 	= 'proveedor solicitado no existe.';
--        SET $encontrado = 0;
    END IF;
END //
DELIMITER ;
