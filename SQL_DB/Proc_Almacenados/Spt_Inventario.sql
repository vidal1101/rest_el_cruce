/*
 * Script del inventario, están todos los procedimientos necesarios para el módulo.
 *
 * stp insertar producto       -> stp_insertarProducto
 * stp cambiar estado producto -> stp_cambiarEstadoProducto
 * stp modificar producto  	   -> stp_modificarProducto
 * stp mostrar producto por categoria -> stp_mostrarProductos_x_Categoria
 * stp mostrar producto 	   -> stp_mostrarProducto
 *
 */
 
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarProductos_x_Categoria`(
IN  $idCategoria INT)
BEGIN

IF EXISTS (SELECT idCategoria FROM `Categoria` WHERE idCategoria = $idCategoria) THEN
	SELECT prod.idProducto, cat.nombreCate, prod.nombre, prod.precioCompra, prod.precioVenta, 
    prod.utilidad, prod.iva, inv.stock, inv.cantMano, prod.descripcion, prod.estado
		FROM `Producto` AS prod
			INNER JOIN `Inventario` AS inv ON inv.idProducto = prod.idProducto 
			INNER JOIN `Categoria` AS cat ON cat.idCategoria = prod.idCategoria
		WHERE cat.idCategoria = $idCategoria;
END IF;

END //
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_insertarProducto`(
IN $idProducto  INT,
IN $idCategoria INT,
IN $nombre 		VARCHAR(50),
IN $iva 		DOUBLE(10,2),
IN $precioVenta DOUBLE(10,2), -- Solo se coloca el precio con que se desea vender al público.
IN $descripcion TEXT,
IN $estado 		VARCHAR(25)
-- OUT $mensaje VARCHAR(50)
)
BEGIN
    IF NOT EXISTS (SELECT idProducto FROM `Producto` WHERE idProducto = $idProducto) THEN
		
        INSERT INTO `Producto` (idProducto, idCategoria, nombre, precioVenta, iva,descripcion, estado)
			VALUES ($idProducto, $idCategoria, $nombre, $precioVenta, $iva, $descripcion, $estado);
		SELECT 'Producto registrado exitosamente.';
        -- SET $mensaje = 'Producto registrado exitosamente.';
    ELSE
-- 		SET $mensaje = 'Producto con ID proporcionado ya ha sido registrado.';
		SELECT 'Producto con ID proporcionado ya ha sido registrado.';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_modificarProducto`(
IN $idProducto  INT,
IN $idCategoria INT,
IN $nombre 		VARCHAR(50),
IN $iva 		DOUBLE(10,2),
IN $precioVenta DOUBLE(10,2), -- Solo se coloca el precio con que se desea vender al público.
IN $descripcion TEXT,
IN $estado 		VARCHAR(25)
-- OUT $mensaje VARCHAR(50)
)
BEGIN
    IF EXISTS (SELECT idProducto FROM `Producto` WHERE idProducto = $idProducto) THEN
		
        UPDATE `Producto` SET 
						idCategoria = $idCategoria,
                        nombre 		= $nombre,
                        precioVenta = $precioVenta,
                        iva			= $iva,
                        descripcion = $descripcion,
                        estado 		= $estado
				WHERE idProducto    = $idProducto;
            
		SELECT 'Producto modificado exitosamente.';
        -- SET $mensaje = 'Producto registrado exitosamente.';
    ELSE
-- 		SET $mensaje = 'Producto con ID proporcionado ya ha sido registrado.';
		SELECT 'Producto con ID proporcionado no ha sido registrado.';
    END IF;
END $$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarProducto`(
IN $idProd INT
-- OUT $mensaje VARCHAR(50)
)
BEGIN
	IF EXISTS(SELECT idProducto FROM `Producto` WHERE idProducto = $idProd) THEN
    
		SELECT idProducto, idCategoria, nombre, estado, precioCompra, precioVenta, iva, descripcion
			FROM `Producto` WHERE idProducto = $idProd;
    ELSE
-- 		SET $mensaje = 'Producto no encontrado.';
		SELECT 'Producto no encontrado.';
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cambiarEstadoProducto`(
IN  $idProd     INT
-- OUT $mensaje 	VARCHAR(50),
-- OUT $encontrado BOOLEAN
)
BEGIN
-- Esta variable local será la que tenga el valor actual
DECLARE estadoActual VARCHAR(10);

-- Verificamos si el registro existe y si existe obtenemos su campo estado
		IF EXISTS (SELECT idProducto FROM `Producto` WHERE idProducto = $idProd) THEN
			
            -- Revisamos el estado actual del registro
			SET estadoActual = (SELECT estado FROM `Producto` WHERE idProducto = $idProd);
            
            -- Cambiamos el estado
            IF (estadoActual = 'Activo') THEN
            
				SET estadoActual = 'Inactivo';
-- 				SET $mensaje     = 'Producto desactivado.';
                
            ELSE
				SET estadoActual = 'Activo';
-- 				SET $mensaje     = 'Producto activado.';
                
            END IF;
			
            UPDATE `Producto` SET estado = estadoActual WHERE idProducto = $idProd;
-- 			SET $encontrado = 1;
            
-- 		ELSE
-- 			SET $mensaje    ='Error. Producto no encontrado.';
-- 			SET $encontrado = 0;
		END IF;
END $$
DELIMITER ;