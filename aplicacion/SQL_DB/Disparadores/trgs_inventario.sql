DELIMITER $$
CREATE DEFINER=`adminRestBar`@`localhost` TRIGGER `after_insert_inventario` 
AFTER INSERT ON `Producto`
FOR EACH ROW
BEGIN 
	INSERT INTO `Inventario` (idProducto,cantMano,stock) VALUES(NEW.idProducto,0,0);
END$$
DELIMITER ;

DROP TRIGGER `after_insert_inventario`;