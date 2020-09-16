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
-- 			SElECT cedula, nombre, puesto, estado FROM `Caja`;
		
		WHEN 'usuarios' THEN 
			SElECT cedula, nombre, puesto, estado FROM `Trabajador`;
        
        WHEN 'clientes' THEN
			SELECT cedula, nombre, empresa, email, observacion, estado FROM `Cliente`;
            
        -- En el caso de productos, seria inventario
        WHEN 'categorias' THEN 
			SELECT idCategoria, nombreCate, descripcion, estado, categorias FROM `Categoria`;
        
        -- Inner Join
        WHEN 'inventario' THEN 
			SELECT prod.idProducto, cat.nombreCate AS `categoria`, prod.nombre,
				   inve.stock, inve.cantMano AS `cant. bodega`,
				   prod.precioCompra, prod.precioVenta, prod.utilidad, prod.iva, 
				   prod.descripcion, prod.estado
				FROM `Producto` AS prod
					INNER JOIN `Categoria`  AS cat  ON cat.idCategoria = prod.idCategoria
                    INNER JOIN `Inventario` AS inve ON inve.idProducto = prod.idProducto;
		
        WHEN 'proveedores' THEN
			SELECT idProveedor, cedulaJuridi, empresa AS `nom. empresa`,
            telefono, direccion, descripcion, estado FROM `Proveedor`;
		
		-- Inner Join 
		WHEN 'facturas clientes' THEN
			SELECT fact.idFactura AS `ID factura`, fact.idCaja AS `ID caja`, cli.nombre AS `nom. cliente`,
				   fact.descripCliente, fact.lugarConsumo, trab.nombre AS `atend. por`, fact.fechaFacturado,
				   fact.electronica AS `fact. electronica`, fact.tipoPago, fact.moneda, fact.digitosTarjeta,
				   fact.totalPago AS `cobrado`, fact.diferencia AS `vuelto`, fact.estado AS `estado factura`
				FROM `FacturaCliente` AS fact
					INNER JOIN `Trabajador` AS trab ON trab.cedula = fact.idTrabajador
					INNER JOIN `Cliente`    AS cli  ON cli.cedula = fact.idCliente;
            
        -- Inner Join 
        WHEN 'facturas proveedores' THEN
			SELECT fact.idFacturaProveedor AS `ID factura`, fact.idCaja AS `ID caja`,
				   prov.empresa AS `proveedor`, fact.fechaCompra AS `comprado el dia`,
                   fact.fechaFacturacion AS `facturado el dia`, trab.nombre AS `realizado  por`,
                   fact.estado, fact.totalPago AS `cant. pagada`
				FROM `FacturaProveedor` AS fact
					INNER JOIN `Proveedor` AS prov ON prov.idProveedor = fact.idProveedor
					INNER JOIN `Trabajador` AS trab ON trab.cedula = fact.cedTrabajador;
--     ELSE 
-- 		SET $mensaje = 'No existe la tabla solicitada.';
    END CASE;
END //
DELIMITER ;