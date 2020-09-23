/*
 * Scripts que trabajan con varias tablas a la vez
 * stp mostrar una tabla -> stp_mostrarRegistros
 *				-- caja
 * 				-- usuarios
 *				-- clientes
 *				-- categorias
 *				-- inventario
 *				-- proveedores
 *				-- facturas clientes
 *				-- facturas proveedores
 */
 
 -- Muestra todos los registros de cualquier tabla
DELIMITER //
CREATE DEFINER =`adminRestBar`@`localhost` PROCEDURE `stp_mostrarRegistros`(
IN  $tabla   VARCHAR(50)
-- OUT $mensaje VARCHAR(50)
)
BEGIN
-- Solo para tener valores por defecto
-- 	SET $mensaje = 'Tabla encontrada.';
    
	CASE $tabla 
    -- Inner Join, aunque esta consulta puede ser separa por su gran cantidad de información a mostrar
-- 		WHEN 'caja' THEN 
-- 			SElECT cedula, nombre, puesto, estado FROM `caja`;
		
		WHEN 'usuarios' THEN 
			SElECT cedula, nombre, puesto, estado FROM `trabajador`;
        
        WHEN 'clientes' THEN
			SELECT cedula, nombre, empresa, email, observacion, estado FROM `cliente`;
            
        -- En el caso de productos, seria inventario
        WHEN 'categorias' THEN 
			SELECT idcategoria, nombreCate, descripcion, estado, nombreFoto FROM `categoria`;
        
        -- Inner Join
        WHEN 'inventario' THEN 
			SELECT prod.idProducto, cat.nombreCate AS `categoria`, prod.nombre,
				   inve.stock, inve.cantMano AS `cant. bodega`,
				   prod.precioCompra, prod.precioVenta, prod.utilidad, prod.iva, 
				   prod.descripcion, prod.estado
				FROM `Producto` AS prod
					INNER JOIN `categoria`  AS cat  ON cat.idcategoria = prod.idcategoria
                    INNER JOIN `inventario` AS inve ON inve.idProducto = prod.idProducto;
		
        WHEN 'proveedores' THEN
			SELECT idproveedor, cedulaJuridi, empresa AS `nom. empresa`,
            telefono, direccion, descripcion, estado FROM `proveedor`;
		
		-- Inner Join 
		WHEN 'facturas clientes' THEN
			SELECT fact.idFactura AS `ID factura`, fact.idcaja AS `ID caja`, cli.nombre AS `nom. cliente`,
				   fact.descripcliente, fact.lugarConsumo, trab.nombre AS `atend. por`, fact.fechaFacturado,
				   fact.electronica AS `fact. electronica`, fact.tipoPago, fact.moneda, fact.digitosTarjeta,
				   fact.totalPago AS `cobrado`, fact.diferencia AS `vuelto`, fact.estado AS `estado factura`
				FROM `facturacliente` AS fact
					INNER JOIN `trabajador` AS trab ON trab.cedula = fact.idtrabajador
					INNER JOIN `cliente`    AS cli  ON cli.cedula = fact.idcliente;
            
        -- Inner Join 
        WHEN 'facturas proveedores' THEN
			SELECT fact.idFacturaproveedor AS `ID factura`, fact.idcaja AS `ID caja`,
				   prov.empresa AS `proveedor`, fact.fechaCompra AS `comprado el dia`,
                   fact.fechaFacturacion AS `facturado el dia`, trab.nombre AS `realizado  por`,
                   fact.estado, fact.totalPago AS `cant. pagada`
				FROM `Facturaproveedor` AS fact
					INNER JOIN `proveedor` AS prov ON prov.idproveedor = fact.idproveedor
					INNER JOIN `trabajador` AS trab ON trab.cedula = fact.cedtrabajador;
--     ELSE 
-- 		SET $mensaje = 'No existe la tabla solicitada.';
    END CASE;
END //
DELIMITER ;