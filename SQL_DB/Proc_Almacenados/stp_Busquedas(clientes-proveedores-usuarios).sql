-- filtro de busqueda para las tablas 
-- --------------------------
-- clientes 
-- proveedores
-- usuarios 
-- --------------------------------------------
use bar_rest_elcruce;

-- Usuario filtro por coincidencias 
delimiter $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_buscarTrabajador`(IN $datos TEXT
)
BEGIN
		SELECT * FROM trabajador WHERE cedula LIKE CONCAT('%',$datos,'%')
                    OR nombre LIKE CONCAT('%',$datos,'%') 
                    OR puesto LIKE CONCAT('%',$datos,'%')
                    OR estado LIKE CONCAT('%',$datos,'%');
			

END$$
delimiter ;

-- cliente 
delimiter $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_buscarCliente`(IN $datos TEXT
)
BEGIN
		SELECT * FROM cliente WHERE cedula LIKE CONCAT('%',$datos,'%')
                    OR nombre LIKE CONCAT('%',$datos,'%') 
                    OR empresa LIKE CONCAT('%',$datos,'%')
                    OR observacion LIKE CONCAT('%',$datos,'%')
					OR estado LIKE CONCAT('%',$datos,'%')
                    OR email LIKE CONCAT('%',$datos,'%');
			

END$$
delimiter ;


-- proveedor

delimiter $$
CREATE DEFINER=`adminRestBar`@`localhost` PROCEDURE `stp_buscarProveedor`(IN $datos TEXT
)
BEGIN
		SELECT * FROM proveedor WHERE idProveedor LIKE CONCAT('%',$datos,'%')
                    OR cedulaJuridi LIKE CONCAT('%',$datos,'%') 
                    OR empresa LIKE CONCAT('%',$datos,'%')
                    OR direccion LIKE CONCAT('%',$datos,'%')
					OR estado LIKE CONCAT('%',$datos,'%')
                    OR descripcion LIKE CONCAT('%',$datos,'%');
			

END$$
delimiter ;

