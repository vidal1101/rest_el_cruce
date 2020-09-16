/*
 * Scripts de procedimientos, triggers y demás para la tabla Caja
 * stp apertura de caja			 -> stp_abrirCaja
 * stp cierre de caja			 -> stp_cerrarCaja
 * stp mostrar caja con facturas -> stp_mostrarCajaFacturas
 * stp mostrar solamente la caja -> stp_mostrarCajaBasica
 */
 
 -- stp abrir caja
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_abrirCaja`(
IN  $idTrabajador INT,
IN  $valorDolar   DOUBLE(10,2),
IN  $fondoCaja    DOUBLE(10,2)
-- OUT $mensaje 	  VARCHAR(50),
-- OUT $apertura     BOOLEAN
)
BEGIN 
	
    IF EXISTS (SELECT cedula FROM Trabajador WHERE cedula = $idTrabajador) THEN
    
		INSERT INTO Caja (idTrabajador, fechaApertura, valorDolar, fondoCaja, estado)
			VALUES ($idTrabajador, NOW(), $valorDolar, $fondoCaja, 'Abierta');
            
-- 		SET $mensaje  = 'Caja abierta.';
--        SET $apertura = 1;
--    ELSE 
		
-- 		SET $mensaje  = 'No se puede abrir la caja, usuario no existe.';
--      SET $apertura = 0;
    END IF;
    
END //
DELIMITER ;


 -- stp cerrar caja
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_cerrarCaja`(
IN  $idCaja 	   INT,
IN  $idTrabajador  INT,
IN  $montoUsuario  DOUBLE(10,2),
IN  $diferencia    DOUBLE(10,2),
IN  $observaciones TEXT
-- OUT $mensaje 	   VARCHAR(70),
-- OUT $encontrada    BOOLEAN
)
BEGIN 
	IF EXISTS (SELECT idCaja, idTrabajador FROM Caja
		WHERE idTrabajador = $idTrabajador AND idCaja = $idCaja) THEN 
		
        UPDATE Caja SET
				fechaCierre   = NOW(),
				montoUsuario  = $montoUsuario,
				diferencia    = $diferencia,
				observaciones = $observaciones,
				estado        = 'Cerrada'
			WHERE idCaja = $idCaja AND idTrabajador = $idTrabajador;
        
--      SET $mensaje  = 'Caja cerrada exitosamente.';
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
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarCajaFacturas`(
IN  $idCaja       INT,
IN  $idTrabajador INT
-- OUT $mensaje      VARCHAR(50),
-- OUT $encontrada   BOOLEAN
)
BEGIN

	IF EXISTS (SELECT cedula FROM Trabajador
		WHERE Trabajador.cedula = $idTrabajador AND Caja.idCaja = $idCaja) THEN
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
            factProvee.idFacturaProveedor,
            factProvee,fechaCompra,
            factProvee.estado,
            factProvee.totalPago
            
		FROM Caja AS caja 
         JOIN Trabajador AS usuario
         INNER JOIN FacturaCliente   AS factClie   ON caja.idCaja = factClie.idCaja
         INNER JOIN FacturaProveedor AS factProvee ON caja.idCaja = factProvee.idCaja
        WHERE caja.idCaja = $idCaja;
        
-- 		SET $mensaje    = 'Caja encontrada.';
--      SET $encontrada = 1;
        
-- 	ELSE 
		
-- 		SET $mensaje    = 'Error. Usuario o ID de caja no encontrada.';
--         SET $encontrada = 0;
	END IF;
END //
DELIMITER ;

-- Muestra solamente los datos de la caja y del usuario relacionado
DELIMITER //
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_mostrarCajaBasica`(
IN  $idCaja       INT,
IN  $idTrabajador INT
-- OUT $mensaje      VARCHAR(50),
-- OUT $encontrada   BOOLEAN
)
BEGIN
	IF EXISTS (SELECT idcaja, idTrabajador FROM Caja
		WHERE idTrabajador = $idTrabajador AND idCaja = $idCaja) THEN
		SELECT
			usuario.cedula, -- Cédula del usuario
			usuario.nombre, -- Nombre del usuario
            usuario.estado, -- Estado del usuario
            
			caja.fechaApertura,
            caja.fechaCierre,
            
			caja.fondoCaja,
			caja.valorDolar,
            
			caja.montoDatafono,
			caja.montoSistema,
            caja.montoUsuario,
            caja.diferencia,
            
			caja.cantiFacturas,
			caja.ventaPromedio,
            
			caja.observaciones,
			caja.estado
            
		FROM Caja AS caja
         JOIN Trabajador AS usuario
        WHERE caja.idCaja = $idCaja;
        
--      SET $mensaje  = 'Caja encontrada.';
--      SET $encontrada = 1;
        
-- 	ELSE 
-- 		SET $mensaje  = 'Error. Usuario o ID de caja no encontrada.';
--      SET $encontrada = 0;
    END IF;
END //
DELIMITER ;




delimiter $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_nuevaCaja`(
in $idTrabajador int(11),
in $fechaHora datetime,
in $fondoCaja double(10,2),
in $valorDolar double(10,2),
in $estado varchar(10)
)
BEGIN
     
	insert into caja( idTrabajador,fechaApertura,fondoCaja,valorDolar,estado)
    values( $idTrabajador,$fechaHora,$fondoCaja,$valorDolar,$estado);
END$$
delimiter ;


delimiter $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_verEstadoCajas`()
BEGIN
	DECLARE numUltimoCaja int(11);
    set numUltimoCaja = (select max(idCaja) as num_Caja   from caja );
    
    if exists(select idCaja , idTrabajador, estado from caja where idCaja = numUltimoCaja  
		and estado ='abierta' ) then
  
			select 'cajaAbierta',numUltimoCaja;
	else 
			select 'cajaCerrada',numUltimoCaja;
   end if;
    
END$$
delimiter ;


delimiter $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `stp_mostrarProductosCaja`()
BEGIN
		select pro.idProducto , cate.nombreCate , pro.nombre , pro.precioVenta
		from producto as pro inner join categoria as cate 
		on pro.idCategoria = cate.idCategoria where pro.idCategoria = cate.idCategoria
		order by pro.idProducto;
END
delimiter ;

