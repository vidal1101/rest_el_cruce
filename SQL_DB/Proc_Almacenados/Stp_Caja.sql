/*
 * Scripts de procedimientos, triggers y demás para la tabla caja
 * stp apertura de caja			 -> stp_abrircaja
 * stp cierre de caja			 -> stp_cerrarcaja
 * stp mostrar caja con facturas -> stp_mostrarcajaFacturas
 * stp mostrar solamente la caja -> stp_mostrarcajaBasica
 */
 
 -- stp abrir caja
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_abrircaja`(
IN  $idtrabajador INT,
IN  $valorDolar   DOUBLE(10,2),
IN  $fondocaja    DOUBLE(10,2)
-- OUT $mensaje 	  VARCHAR(50),
-- OUT $apertura     BOOLEAN
)
BEGIN 
	
    IF EXISTS (SELECT cedula FROM trabajador WHERE cedula = $idtrabajador) THEN
    
		INSERT INTO caja (idtrabajador, fechaApertura, valorDolar, fondocaja, estado)
			VALUES ($idtrabajador, NOW(), $valorDolar, $fondocaja, 'Abierta');
            
-- 		SET $mensaje  = 'caja abierta.';
--        SET $apertura = 1;
--    ELSE 
		
-- 		SET $mensaje  = 'No se puede abrir la caja, usuario no existe.';
--      SET $apertura = 0;
    END IF;
    
END //
DELIMITER ;


 -- stp cerrar caja
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cerrarcaja`(
IN  $idcaja 	   INT,
IN  $idtrabajador  INT,
IN  $montoUsuario  DOUBLE(10,2),
IN  $diferencia    DOUBLE(10,2),
IN  $observaciones TEXT
-- OUT $mensaje 	   VARCHAR(70),
-- OUT $encontrada    BOOLEAN
)
BEGIN 
	IF EXISTS (SELECT idcaja, idtrabajador FROM caja
		WHERE idtrabajador = $idtrabajador AND idcaja = $idcaja) THEN 
		
        UPDATE caja SET
				fechaCierre   = NOW(),
				montoUsuario  = $montoUsuario,
				diferencia    = $diferencia,
				observaciones = $observaciones,
				estado        = 'Cerrada'
			WHERE idcaja = $idcaja AND idtrabajador = $idtrabajador;
        
--      SET $mensaje  = 'caja cerrada exitosamente.';
--      SET $encontrada = 1;
        
--    ELSE
-- 		SET $mensaje    = 'Error al cerrar la caja. Usuario o ID de caja no encontrados.';
--      SET $encontrada = 0;
    END IF;
    
END //
DELIMITER ;

-- Muestra la caja junto con las facturas de venta y compra
-- Puede que debamos dividir estos datos en 2 partes
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarcajaFacturas`(
IN  $idcaja       INT,
IN  $idtrabajador INT
-- OUT $mensaje      VARCHAR(50),
-- OUT $encontrada   BOOLEAN
)
BEGIN

	IF EXISTS (SELECT cedula FROM trabajador
		WHERE trabajador.cedula = $idtrabajador AND caja.idcaja = $idcaja) THEN
        SELECT
			usuario.cedula, -- Cédula del usuario
			usuario.nombre, -- Nombre del usuario
            
			caja.fechaApertura,
            caja.fechaCierre,
            
			caja.montoDatafono,
			caja.montoSistema,
            
			caja.cantiFacturas,
			caja.ventaPromedio,
            
			caja.observaciones,
            
            -- Facturas de las ventas
            factClie.idFactura,
            factClie.lugarConsumo,
            factClie.tipoPago,
            factClie.electronica,
            factClie.moneda,
            factClie.totalPago,
            factClie.estado,
            
            -- Facturas de las compras
            factProvee.idfacturaproveedor,
            factProvee,fechaCompra,
            factProvee.estado,
            factProvee.totalPago
            
		FROM caja AS caja 
         JOIN trabajador AS usuario
         INNER JOIN facturacliente   AS factClie   ON caja.idcaja = factClie.idcaja
         INNER JOIN facturaproveedor AS factProvee ON caja.idcaja = factProvee.idcaja
        WHERE caja.idcaja = $idcaja;
        
-- 		SET $mensaje    = 'caja encontrada.';
--      SET $encontrada = 1;
        
-- 	ELSE 
		
-- 		SET $mensaje    = 'Error. Usuario o ID de caja no encontrada.';
--         SET $encontrada = 0;
	END IF;
END //
DELIMITER ;

-- Muestra solamente los datos de la caja y del usuario relacionado
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarcajaBasica`(
IN  $idcaja       INT,
IN  $idtrabajador INT
-- OUT $mensaje      VARCHAR(50),
-- OUT $encontrada   BOOLEAN
)
BEGIN
	IF EXISTS (SELECT idcaja, idtrabajador FROM caja
		WHERE idtrabajador = $idtrabajador AND idcaja = $idcaja) THEN
		SELECT
			usuario.cedula, -- Cédula del usuario
			usuario.nombre, -- Nombre del usuario
            usuario.estado, -- Estado del usuario
            
			caja.fechaApertura,
            caja.fechaCierre,
            
			caja.fondocaja,
			caja.valorDolar,
            
			caja.montoDatafono,
			caja.montoSistema,
            caja.montoUsuario,
            caja.diferencia,
            
			caja.cantiFacturas,
			caja.ventaPromedio,
            
			caja.observaciones,
			caja.estado
            
		FROM caja AS caja
         JOIN trabajador AS usuario
        WHERE caja.idcaja = $idcaja;
        
--      SET $mensaje  = 'caja encontrada.';
--      SET $encontrada = 1;
        
-- 	ELSE 
-- 		SET $mensaje  = 'Error. Usuario o ID de caja no encontrada.';
--      SET $encontrada = 0;
    END IF;
END //
DELIMITER ;

delimiter $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_nuevacaja`(
in $idtrabajador int(11),
in $fechaHora datetime,
in $fondocaja double(10,2),
in $valorDolar double(10,2),
in $estado varchar(10)
)
BEGIN
     
	insert into caja( idtrabajador,fechaApertura,fondocaja,valorDolar,estado)
    values( $idtrabajador,$fechaHora,$fondocaja,$valorDolar,$estado);
END$$
delimiter ;


delimiter $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_verEstadocajas`()
BEGIN
	DECLARE numUltimocaja int(11);
    set numUltimocaja = (select max(idcaja) as num_caja   from caja );
    
    if exists(select idcaja , idtrabajador, estado from caja where idcaja = numUltimocaja  
		and estado ='abierta' ) then
  
			select 'cajaAbierta',numUltimocaja;
	else 
			select 'cajaCerrada',numUltimocaja;
   end if;
    
END$$
delimiter ;


DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarProductoscaja`()
BEGIN
		select pro.idProducto , cate.nombreCate , pro.nombre , pro.precioVenta
		from producto as pro inner join categoria as cate 
		on pro.idcategoria = cate.idcategoria where pro.idcategoria = cate.idcategoria
		order by pro.idProducto;
END $$
DELIMITER ;


DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarProductos_x_categoria_caja`(
IN  $idcategoria INT)
BEGIN

IF EXISTS (SELECT idcategoria FROM `categoria` WHERE idcategoria = $idcategoria) THEN
	SELECT pro.idProducto , cat.nombreCate , pro.nombre , pro.precioVenta, inv.stock
		FROM `producto` AS pro
			INNER JOIN `inventario` AS inv ON inv.idproducto = pro.idproducto 
			INNER JOIN `categoria` AS cat ON cat.idcategoria = pro.idcategoria
		WHERE cat.idcategoria = $idcategoria;
END IF;

END //
DELIMITER ;