/*
 * Script del inventario, están todos los procedimientos necesarios para el módulo.
 *
 * stp insertar producto       -> stp_insertarproducto
 * stp cambiar estado producto -> stp_cambiarEstadoproducto
 * stp modificar producto  	   -> stp_modificarproducto
 * stp mostrar producto por categoria -> stp_mostrarproductos_x_categoria
 * stp mostrar producto 	   -> stp_mostrarproducto
 *
 */
 
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarproductos_x_categoria`(
IN  $idcategoria INT)
BEGIN

IF EXISTS (SELECT idcategoria FROM `categoria` WHERE idcategoria = $idcategoria) THEN
	SELECT prod.idproducto, cat.nombreCate, prod.nombre, prod.precioCompra, prod.precioVenta, 
    prod.utilidad, prod.iva, inv.stock, inv.cantMano, prod.descripcion, prod.estado
		FROM `producto` AS prod
			INNER JOIN `inventario` AS inv ON inv.idproducto = prod.idproducto 
			INNER JOIN `categoria` AS cat ON cat.idcategoria = prod.idcategoria
		WHERE cat.idcategoria = $idcategoria;
END IF;

END //
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertarproducto`(
IN $idproducto  INT,
IN $idcategoria INT,
IN $nombre 		VARCHAR(50),
IN $iva 		DOUBLE(10,2),
IN $precioVenta DOUBLE(10,2), -- Solo se coloca el precio con que se desea vender al público.
IN $descripcion TEXT,
IN $estado 		VARCHAR(25)
-- OUT $mensaje VARCHAR(50)
)
BEGIN
    IF NOT EXISTS (SELECT idproducto FROM `producto` WHERE idproducto = $idproducto) THEN
		
        INSERT INTO `producto` (idproducto, idcategoria, nombre, precioVenta, iva,descripcion, estado)
			VALUES ($idproducto, $idcategoria, $nombre, $precioVenta, $iva, $descripcion, $estado);
		SELECT 'producto registrado exitosamente.';
        -- SET $mensaje = 'producto registrado exitosamente.';
    ELSE
-- 		SET $mensaje = 'producto con ID proporcionado ya ha sido registrado.';
		SELECT 'producto con ID proporcionado ya ha sido registrado.';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_modificarproducto`(
IN $idproducto  INT,
IN $idcategoria INT,
IN $nombre 		VARCHAR(50),
IN $iva 		DOUBLE(10,2),
IN $precioVenta DOUBLE(10,2), -- Solo se coloca el precio con que se desea vender al público.
IN $descripcion TEXT,
IN $estado 		VARCHAR(25)
-- OUT $mensaje VARCHAR(50)
)
BEGIN
    IF EXISTS (SELECT idproducto FROM `producto` WHERE idproducto = $idproducto) THEN
		
        UPDATE `producto` SET 
						idcategoria = $idcategoria,
                        nombre 		= $nombre,
                        precioVenta = $precioVenta,
                        iva			= $iva,
                        descripcion = $descripcion,
                        estado 		= $estado
				WHERE idproducto    = $idproducto;
            
		SELECT 'producto modificado exitosamente.';
        -- SET $mensaje = 'producto registrado exitosamente.';
    ELSE
-- 		SET $mensaje = 'producto con ID proporcionado ya ha sido registrado.';
		SELECT 'producto con ID proporcionado no ha sido registrado.';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarproducto`(
IN $idProd INT
-- OUT $mensaje VARCHAR(50)
)
BEGIN
	IF EXISTS(SELECT idproducto FROM `producto` WHERE idproducto = $idProd) THEN
    
		SELECT idproducto, idcategoria, nombre, estado, precioCompra, precioVenta, iva, descripcion
			FROM `producto` WHERE idproducto = $idProd;
    ELSE
-- 		SET $mensaje = 'producto no encontrado.';
		SELECT 'producto no encontrado.';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadoproducto`(
IN  $idProd     INT
-- OUT $mensaje 	VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el registro existe y si existe obtenemos su campo estado
		IF EXISTS (SELECT idproducto FROM `producto` WHERE idproducto = $idProd) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM `producto` WHERE idproducto = $idProd);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'producto desactivado.';
                
            ELSE
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'producto activado.';
                
            END IF;
			
            UPDATE `producto` SET estado = estadoActual WHERE idproducto = $idProd;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. producto no encontrado.';
-- 			SET $encontrado = 0;
		END IF;
END $$
DELIMITER ;