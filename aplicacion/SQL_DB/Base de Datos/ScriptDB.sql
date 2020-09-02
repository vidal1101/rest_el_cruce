-- -----------------------------------------------------
-- MySQL BD
-- -----------------------------------------------------
-- BD Bar_Rest_ElCruce
-- 
-- Las tablas son las siguientes:
-- 		1. Trabajador
-- 		2. Usuarios
-- 		3. Proveedor
-- 		4. Categoria
-- 		5. Producto
-- 		6. ProductoYProveedor -> Tabla intermedia entre Producto y Proveedor
-- 		7. Inventario
-- 		8. Caja
-- 		9. FacturaCliente
-- 		10. FacturaProveedor
-- 		11. DetalleCompraCliente
-- 		12. DetalleCompraProveedor
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Crea la BD 
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Bar_Rest_ElCruce` DEFAULT CHARACTER SET utf8 ;
USE `Bar_Rest_ElCruce`;

DROP TABLE IF EXISTS `Trabajador`;
DROP TABLE IF EXISTS `Usuarios`;
DROP TABLE IF EXISTS `Proveedor`;
DROP TABLE IF EXISTS `Categoria`;
DROP TABLE IF EXISTS `Producto`;
DROP TABLE IF EXISTS `ProductoProveedor`;
DROP TABLE IF EXISTS `Inventario`;
DROP TABLE IF EXISTS `Caja`;
DROP TABLE IF EXISTS `FacturaCliente`;
DROP TABLE IF EXISTS `FacturaProveedor`;
DROP TABLE IF EXISTS `DetalleCompraCliente`;
DROP TABLE IF EXISTS `DetalleCompraProveedor`;

-- -----------------------------------------------------
-- Crea el usuario y se le asigna los permisos a la BD
-- -----------------------------------------------------
CREATE USER IF NOT EXISTS `adminRestBar`@`localhost` IDENTIFIED BY 'Password!999';
GRANT ALL PRIVILEGES ON `Bar_Rest_ElCruce`.* TO 'adminRestBar'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`Trabajador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`Trabajador` (
  `cedula` INT(15) 	   NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `puesto` VARCHAR(45) NOT NULL DEFAULT 'Salonera',
  `contrasenia` TEXT   NOT NULL,
  `estado` VARCHAR(25) NOT NULL DEFAULT 'Activo',
  
  PRIMARY KEY (`cedula`),
  CONSTRAINT `chk_puestoTrab` CHECK (`puesto` = 'Administradora' OR `puesto` = 'Salonera'
									OR `puesto` = 'Suplente'),
  CONSTRAINT `chk_estadoTrab` CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`Cliente` (
  `cedula`  VARCHAR(50) NOT NULL,
  `nombre`  VARCHAR(45) NOT NULL,
  `empresa` VARCHAR(50) NOT NULL,
  `email`   VARCHAR(50) NOT NULL DEFAULT 'user@me.com',
  `observacion` TEXT    NULL,
  `estado`  VARCHAR(25) NOT NULL DEFAULT 'Activo',
  
  PRIMARY KEY (`cedula`),
  CONSTRAINT `chk_estadoCli` CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`Categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`Categoria` (
  `idCategoria` INT 	    NOT NULL AUTO_INCREMENT,
  `nombreCate`  VARCHAR(45) NOT NULL,
  `descripcion` TEXT 	    NULL,
  `estado` 		  VARCHAR(25) NOT NULL DEFAULT 'Activo',
  `foto`	 	    LONGBLOB    NULL,
  `nombreFoto`  TEXT,
  
  PRIMARY KEY (`idCategoria`),
  UNIQUE INDEX `uq_nombreCate` (`nombreCate` ASC),
  CONSTRAINT `chk_estadoCate` CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'))
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`Proveedor` (
  `idProveedor`  INT NOT NULL AUTO_INCREMENT,
  `cedulaJuridi` VARCHAR(30) NOT NULL,
  `empresa` 	 VARCHAR(50) NOT NULL,
  `direccion`    TEXT        NULL ,
  `telefono`     VARCHAR(14) NOT NULL,
  `estado`       VARCHAR(25) NOT NULL DEFAULT 'Activo',
  `descripcion`  TEXT,
  
  PRIMARY KEY (`idProveedor`),
  UNIQUE INDEX `uq_cedulaJuridi` (`cedulaJuridi` ASC),
  CONSTRAINT `chk_estadoProve` CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'))
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`Producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`Producto` (
  `idProducto`   INT 		  NOT NULL,
  `idCategoria`  INT	 	  NOT NULL,
  `nombre` 		 VARCHAR(50)  NOT NULL,
  `precioCompra` DOUBLE(10,2) NOT NULL DEFAULT 0,
  `precioVenta`  DOUBLE(10,2) NOT NULL DEFAULT 0,
  `utilidad` 	 DOUBLE(10,2) NOT NULL DEFAULT 0,
  `iva` 		 DOUBLE(10,2) NOT NULL DEFAULT 0,
  `descripcion`  TEXT 		  NULL,
  `estado` 		 VARCHAR(25)  NOT NULL DEFAULT 'Activo',
  
  PRIMARY KEY (`idProducto`),
  INDEX      `FK_idCategoria-Prod` 	  (`idCategoria` ASC),
  
  CONSTRAINT `chk_estado-Prod` 		 CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'),
  CONSTRAINT `chk_precioCompra-Prod` CHECK (`precioCompra` >= 0),
  CONSTRAINT `chk_precioVenta-Prod`  CHECK (`precioVenta`  >= 0),
  CONSTRAINT `chk_utilidad-Prod`     CHECK (`utilidad` 	   >= 0),
  CONSTRAINT `chk_iva-Prod`    		 CHECK (`iva` 		   >= 0),
  
  CONSTRAINT `FK_idCategoria-Prod`
    FOREIGN KEY (`idCategoria`)
    REFERENCES `Bar_Rest_ElCruce`.`Categoria` (`idCategoria`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`Caja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`Caja` (
  `idCaja` 		  INT 		   NOT NULL AUTO_INCREMENT,
  `idTrabajador`  INT          NOT NULL,
  `fechaApertura` DATETIME     NOT NULL DEFAULT NOW(),
  `fondoCaja`     DOUBLE(10,2) NOT NULL,
  `valorDolar`    DOUBLE(10,2) NOT NULL DEFAULT 1, -- Si queda en 0, porque al multiplicar todo dara 0
  `fechaCierre`   DATETIME 	   NULL,
  `montoDatafono` DOUBLE(10,2) NULL DEFAULT 0,
  `montoSistema`  DOUBLE(10,2) NULL DEFAULT 0,
  `cantiFacturas` INT 		   NULL DEFAULT 0,
  `ventaPromedio` DOUBLE(10,2) NULL DEFAULT 0,
  `montoUsuario`  DOUBLE(10,2) NULL DEFAULT 0,
  `diferencia`    DOUBLE(10,2) NULL DEFAULT 0,
  `observaciones` TEXT         NULL,
  `estado`      VARCHAR(10)  NOT NULL DEFAULT 'Abierta',
  
  PRIMARY KEY (`idCaja`),
  INDEX `FK_Trabajador-Caj` (`idTrabajador` ASC),
  
  CONSTRAINT `chk_fondo-Caj`         CHECK (`fondoCaja`     >= 0),
  CONSTRAINT `chk_valorDolar-Caj`  	 CHECK (`valorDolar`    >= 0),
  CONSTRAINT `chk_MontoDatafono-Caj` CHECK (`montoDatafono` >= 0),
  CONSTRAINT `chk_montoSistema-Caj`  CHECK (`montoSistema`  >= 0),
  CONSTRAINT `chk_cantiFacturas-Caj` CHECK (`cantiFacturas` >= 0),
  CONSTRAINT `chk_ventaPromedio-Caj` CHECK (`ventaPromedio` >= 0),
  CONSTRAINT `chk_montoUsuario-Caj`  CHECK (`montoUsuario`  >= 0),
  CONSTRAINT `chk_diferencia-Caj` 	 CHECK (`diferencia`    >= 0),
  CONSTRAINT `chk_estado-Caj` 	 CHECK (`estado` = 'Abierta' OR `estado` = 'Cerrada'),
  
  CONSTRAINT `FK_Trabajador-Caj`
    FOREIGN KEY (`idTrabajador`)
    REFERENCES `Bar_Rest_ElCruce`.`Trabajador` (`cedula`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`FacturaCliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`FacturaCliente` (
  `idFactura` 	   INT 			NOT NULL AUTO_INCREMENT,
  `idCaja` 		   INT 			NOT NULL,
  `idCliente` 	   VARCHAR(50)  NOT NULL,
  `idTrabajador`   INT 			NOT NULL,
  `lugarConsumo`   VARCHAR(10)  NOT NULL DEFAULT 'Barra',
  `descripCliente` VARCHAR(50)  NOT NULL DEFAULT 'Cliente genérico',
  `fechaProforma`  DATETIME 	NOT NULL DEFAULT NOW(), -- Este si agarra la fecha actual porque es primero una proforma
  `fechaFacturado` DATETIME 	NULL,
  `electronica`    TINYINT 		NOT NULL DEFAULT FALSE,
  `tipoPago` 	   VARCHAR(20)  NOT NULL DEFAULT 'Efectivo',
  `digitosTarjeta` INT(4) 		NULL, -- Puede ir NULL porque no siempre es con trajeta, son los últimos 4
  `estado` 		   VARCHAR(25)  NOT NULL DEFAULT 'Pendiente', -- Primero es proforma
  `montCliente`    DOUBLE(10,2) NOT NULL DEFAULT 0,
  `diferencia` 	   DOUBLE(10,2) NOT NULL DEFAULT 0,
  `totalPago` 	   DOUBLE(10,2) NOT NULL DEFAULT 0,
  `moneda` 		   VARCHAR(10)  NOT NULL DEFAULT 'Colones',
  
  PRIMARY KEY (`idFactura`),
  INDEX `FK_idCliente-FactCliente` 	  (`idCliente` ASC),
  INDEX `FK_idTrabajador-FactCliente` (`idTrabajador` ASC),
  INDEX `FK_idCaja-FactCliente`    	  (`idCaja` ASC),
  
  CONSTRAINT `chk_lugarConsumo-FactCliente`CHECK (`lugarConsumo` = 'Barra' OR `lugarConsumo` = 'Mesa'),
  CONSTRAINT `chk_tipoPago-FactCliente`    CHECK (`tipoPago` = 'Efectivo'  OR `tipoPago` = 'Tarjeta'),
  CONSTRAINT `chk_estado-FactCliente` 	   CHECK (`estado`   = 'Pendiente' OR `estado`   = 'Facturada'),
  CONSTRAINT `chk_montCliente-FactCliente` CHECK (`montCliente` >= 0),
  CONSTRAINT `chk_totalPago-FactCliente`   CHECK (`totalPago`   >= 0),
  CONSTRAINT `chk_diferencia-FactCliente`  CHECK (`diferencia`  >= 0),
  CONSTRAINT `chk_moneda-FactCliente` 	   CHECK (`moneda` = 'Colones' OR `moneda` = 'Dólares'),
  
  CONSTRAINT `FK_idCliente-FactCliente`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Bar_Rest_ElCruce`.`Cliente` (`cedula`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idTrabajador-FactCliente`
    FOREIGN KEY (`idTrabajador`)
    REFERENCES `Bar_Rest_ElCruce`.`Trabajador` (`cedula`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idCaja-FactCliente`
    FOREIGN KEY (`idCaja`)
    REFERENCES `Bar_Rest_ElCruce`.`Caja` (`idCaja`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;

-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`DetalleCompraCliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`DetalleCompraCliente` (
  `idDetalleClient` INT 		 NOT NULL AUTO_INCREMENT,
  `idFactura` 		INT 		 NOT NULL,
  `idProducto` 		INT 		 NOT NULL,
  `precioVenta` 	DOUBLE(10,2) NOT NULL DEFAULT 0, -- Recomendable para realizar operaciones sin hacer JOIN
  `cantConsumo` 	INT 		 NOT NULL DEFAULT 1,
  `subtotal` 		DOUBLE(10,2) NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idDetalleClient`),
  INDEX `FK_idProducto-DetCompCliente` (`idProducto` ASC),
  INDEX `FK_idFactura-DetCompCliente`  (`idFactura` ASC),
  
  CONSTRAINT `chk_precioVentas-DetCompCliente` CHECK (`precioVenta` >= 0),
  CONSTRAINT `chk_cantConsumo-DetCompCliente`  CHECK (`cantConsumo` >  0), -- Nunca se consume 0 productos
  CONSTRAINT `chk_subtotal-DetCompCliente`     CHECK (`subtotal`    >= 0),
  
  CONSTRAINT `FK_idProducto-DetCompCliente`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Bar_Rest_ElCruce`.`Producto` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idFactura-DetCompCliente`
    FOREIGN KEY (`idFactura`)
    REFERENCES `Bar_Rest_ElCruce`.`FacturaCliente` (`idFactura`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`FacturaProveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`FacturaProveedor` (
  `idFacturaProveedor`  INT 		 NOT NULL AUTO_INCREMENT,
  `idCaja` 			 	INT 		 NOT NULL,
  `idProveedor` 	 	INT 		 NOT NULL,
  `cedTrabajador` 	 	INT 		 NOT NULL,
  `fechaCompra` 	 	DATETIME 	 NOT NULL DEFAULT NOW(),
  `fechaFacturacion` 	DATETIME 	 NULL,
  `estado` 			 	VARCHAR(20)  NOT NULL DEFAULT 'Pendiente',
  `totalPago` 		 	DOUBLE(10,2) NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idFacturaProveedor`),
  INDEX `Fk_idProveedor-FactProve`    (`idProveedor` ASC),
  INDEX `FK_idTrabajador-FactProve`   (`cedTrabajador` ASC),
  INDEX `FK_idCaja-FactProve`         (`idCaja` ASC),
  
  CONSTRAINT `chk_estado-FactProve`     CHECK (`estado` = 'Pendiente' OR `estado` = 'Facturada'),
  CONSTRAINT `chk_totalPagar-FactProve` CHECK (`totalPago` >= 0),
  
  CONSTRAINT `Fk_idProveedor-FactProve`
    FOREIGN KEY (`idProveedor`)
    REFERENCES `Bar_Rest_ElCruce`.`Proveedor` (`idProveedor`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idTrabajador-FactProve`
    FOREIGN KEY (`cedTrabajador`)
    REFERENCES `Bar_Rest_ElCruce`.`Trabajador` (`cedula`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idCaja-FactProve`
    FOREIGN KEY (`idCaja`)
    REFERENCES `Bar_Rest_ElCruce`.`Caja` (`idCaja`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`DetalleCompraProveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`DetalleCompraProveedor` (
  `idDetalleProv` INT NOT NULL AUTO_INCREMENT,
  `idFactura` 	  INT NOT NULL,
  `idProducto` 	  INT NOT NULL,
  `entrada` 	  INT NOT NULL DEFAULT 1,
  `precioCompra`  DOUBLE(10,2) NOT NULL DEFAULT 0, -- Recomendable para realizar operaciones sin hacer JOIN
  `subTotal` 	  DOUBLE(10,2) NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idDetalleProv`),
  INDEX `Fk_idProducto-DetCompProve` (`idProducto` ASC),
  INDEX `FK_idFactura-DetCompProve`  (`idFactura` ASC),
  
  CONSTRAINT `chk_entrada-DetCompProve` 	 CHECK (`entrada`      >  0), -- Nunca se compra 0 productos
  CONSTRAINT `chk_precioCompra-DetCompProve` CHECK (`precioCompra` >= 0),
  CONSTRAINT `chk_subTotale-DetCompProve` 	 CHECK (`subTotal`     >= 0),
  
  CONSTRAINT `Fk_idProducto-DetCompProve`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Bar_Rest_ElCruce`.`Producto` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idFactura-DetCompProve`
    FOREIGN KEY (`idFactura`)
    REFERENCES `Bar_Rest_ElCruce`.`FacturaProveedor` (`idFacturaProveedor`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;

-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`ProductoYProveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`ProductoYProveedor` (
  `idProveedor` INT NOT NULL,
  `idProducto`  INT NOT NULL,
  
  PRIMARY KEY (`idProducto`, `idProveedor`),
  INDEX `Fk_idProveedor-ProdProve` (`idProveedor` ASC),
  INDEX `Fk_idProducto-ProdProve`  (`idProducto` ASC),
  
  CONSTRAINT `Fk_idProveedor-ProdProve`
    FOREIGN KEY (`idProveedor`)
    REFERENCES `Bar_Rest_ElCruce`.`Proveedor` (`idProveedor`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `Fk_idProducto-ProdProve`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Bar_Rest_ElCruce`.`Producto` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`Inventario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`Inventario` (
  `idInventario` INT NOT NULL AUTO_INCREMENT,
  `idProducto`   INT NOT NULL,
  `cantMano`     INT NOT NULL DEFAULT 0,
  `stock` 		 INT NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idInventario`),
  INDEX `FK_idProducto-Inv` (`idProducto` ASC),
  
  CONSTRAINT `chk_cantMano-Inv` CHECK (`cantMano` >= 0), -- Cantidad preparada para vender
  CONSTRAINT `chk_stock-Inv`    CHECK (`stock`    >= 0), -- Cantidad restante aparte de cantMano
  
  CONSTRAINT `FK_idProducto-Inv`
    FOREIGN KEY (`idProducto`)
    REFERENCES `Bar_Rest_ElCruce`.`Producto` (`idProducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;
