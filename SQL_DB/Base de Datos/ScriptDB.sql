-- -----------------------------------------------------
-- MySQL BD
-- -----------------------------------------------------
-- BD Bar_Rest_ElCruce
-- 
-- Las tablas son las siguientes:
-- 		1. trabajador
-- 		2. usuarios
-- 		3. proveedor
-- 		4. categoria
-- 		5. producto
-- 		6. inventario
-- 		7. caja
-- 		8. facturacliente
-- 		9. facturaproveedor
-- 		10. detallecompracliente
-- 		11. detallecompraproveedor
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Crea la BD 
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Bar_Rest_ElCruce` DEFAULT CHARACTER SET utf8 ;
USE `Bar_Rest_ElCruce`;

DROP TABLE IF EXISTS `trabajador`;
DROP TABLE IF EXISTS `usuarios`;
DROP TABLE IF EXISTS `proveedor`;
DROP TABLE IF EXISTS `categoria`;
DROP TABLE IF EXISTS `producto`;
DROP TABLE IF EXISTS `inventario`;
DROP TABLE IF EXISTS `caja`;
DROP TABLE IF EXISTS `facturacliente`;
DROP TABLE IF EXISTS `facturaproveedor`;
DROP TABLE IF EXISTS `detallecompracliente`;
DROP TABLE IF EXISTS `detallecompraproveedor`;

-- -----------------------------------------------------
-- Crea el usuario y se le asigna los permisos a la BD
-- -----------------------------------------------------
CREATE USER IF NOT EXISTS `adminRestBar`@`localhost` IDENTIFIED BY 'Password!999';
GRANT ALL PRIVILEGES ON `Bar_Rest_ElCruce`.* TO 'adminRestBar'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`trabajador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`trabajador` (
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
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`cliente` (
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
-- Table `Bar_Rest_ElCruce`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`categoria` (
  `idcategoria` INT 	    NOT NULL AUTO_INCREMENT,
  `nombreCate`  VARCHAR(45) NOT NULL,
  `descripcion` TEXT 	    NULL,
  `estado` 		VARCHAR(25) NOT NULL DEFAULT 'Activo',
  `foto`	 	LONGBLOB    NULL,
  `nombreFoto`  TEXT,
  
  PRIMARY KEY (`idcategoria`),
  UNIQUE INDEX `uq_nombreCate` (`nombreCate` ASC),
  CONSTRAINT `chk_estadoCate` CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'))
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`proveedor` (
  `idproveedor`  INT NOT NULL AUTO_INCREMENT,
  `cedulaJuridi` VARCHAR(30) NOT NULL,
  `empresa` 	 VARCHAR(50) NOT NULL,
  `direccion`    TEXT        NULL ,
  `telefono`     VARCHAR(14) NOT NULL,
  `estado`       VARCHAR(25) NOT NULL DEFAULT 'Activo',
  `descripcion`  TEXT,
  
  PRIMARY KEY (`idproveedor`),
  UNIQUE INDEX `uq_cedulaJuridi` (`cedulaJuridi` ASC),
  CONSTRAINT `chk_estadoProve` CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'))
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`producto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`producto` (
  `idproducto`   INT 		  NOT NULL,
  `idcategoria`  INT	 	  NOT NULL,
  `nombre` 		 VARCHAR(50)  NOT NULL,
  `precioCompra` DOUBLE(10,2) NOT NULL DEFAULT 0,
  `precioVenta`  DOUBLE(10,2) NOT NULL DEFAULT 0,
  `utilidad` 	 DOUBLE(10,2) NOT NULL DEFAULT 0,
  `iva` 		 DOUBLE(10,2) NOT NULL DEFAULT 0,
  `descripcion`  TEXT 		  NULL,
  `estado` 		 VARCHAR(25)  NOT NULL DEFAULT 'Activo',
  
  PRIMARY KEY (`idproducto`),
  INDEX      `FK_idcategoria-Prod` 	  (`idcategoria` ASC),
  
  CONSTRAINT `chk_estado-Prod` 		 CHECK (`estado` = 'Activo' OR `estado` = 'Inactivo'),
  CONSTRAINT `chk_precioCompra-Prod` CHECK (`precioCompra` >= 0),
  CONSTRAINT `chk_precioVenta-Prod`  CHECK (`precioVenta`  >= 0),
  CONSTRAINT `chk_utilidad-Prod`     CHECK (`utilidad` 	   >= 0),
  CONSTRAINT `chk_iva-Prod`    		 CHECK (`iva` 		   >= 0),
  
  CONSTRAINT `FK_idcategoria-Prod`
    FOREIGN KEY (`idcategoria`)
    REFERENCES `Bar_Rest_ElCruce`.`categoria` (`idcategoria`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`caja`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`caja` (
  `idcaja` 		  INT 		   NOT NULL AUTO_INCREMENT,
  `idtrabajador`  INT          NOT NULL,
  `fechaApertura` DATETIME     NOT NULL DEFAULT NOW(),
  `fondocaja`     DOUBLE(10,2) NOT NULL,
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
  
  PRIMARY KEY (`idcaja`),
  INDEX `FK_trabajador-Caj` (`idtrabajador` ASC),
  
  CONSTRAINT `chk_fondo-Caj`         CHECK (`fondocaja`     >= 0),
  CONSTRAINT `chk_valorDolar-Caj`  	 CHECK (`valorDolar`    >= 0),
  CONSTRAINT `chk_MontoDatafono-Caj` CHECK (`montoDatafono` >= 0),
  CONSTRAINT `chk_montoSistema-Caj`  CHECK (`montoSistema`  >= 0),
  CONSTRAINT `chk_cantiFacturas-Caj` CHECK (`cantiFacturas` >= 0),
  CONSTRAINT `chk_ventaPromedio-Caj` CHECK (`ventaPromedio` >= 0),
  CONSTRAINT `chk_montoUsuario-Caj`  CHECK (`montoUsuario`  >= 0),
  CONSTRAINT `chk_diferencia-Caj` 	 CHECK (`diferencia`    >= 0),
  CONSTRAINT `chk_estado-Caj` 	 CHECK (`estado` = 'Abierta' OR `estado` = 'Cerrada'),
  
  CONSTRAINT `FK_trabajador-Caj`
    FOREIGN KEY (`idtrabajador`)
    REFERENCES `Bar_Rest_ElCruce`.`trabajador` (`cedula`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`facturacliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`facturacliente` (
  `idFactura` 	   INT 			NOT NULL AUTO_INCREMENT,
  `idcaja` 		     INT 			NOT NULL,
  `idCliente` 	   VARCHAR(50)  NOT NULL,
  `idtrabajador`   INT 			NOT NULL,
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
  INDEX `FK_idtrabajador-FactCliente` (`idtrabajador` ASC),
  INDEX `FK_idcaja-FactCliente`    	  (`idcaja` ASC),
  
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
    
  CONSTRAINT `FK_idtrabajador-FactCliente`
    FOREIGN KEY (`idtrabajador`)
    REFERENCES `Bar_Rest_ElCruce`.`trabajador` (`cedula`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idcaja-FactCliente`
    FOREIGN KEY (`idcaja`)
    REFERENCES `Bar_Rest_ElCruce`.`caja` (`idcaja`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;

-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`detallecompracliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`detallecompracliente` (
  `idDetalleClient` INT 		 NOT NULL AUTO_INCREMENT,
  `idFactura` 		INT 		 NOT NULL,
  `idproducto` 		INT 		 NOT NULL,
  `precioVenta` 	DOUBLE(10,2) NOT NULL DEFAULT 0, -- Recomendable para realizar operaciones sin hacer JOIN
  `cantConsumo` 	INT 		 NOT NULL DEFAULT 1,
  `subtotal` 		DOUBLE(10,2) NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idDetalleClient`),
  INDEX `FK_idproducto-DetCompCliente` (`idproducto` ASC),
  INDEX `FK_idFactura-DetCompCliente`  (`idFactura` ASC),
  
  CONSTRAINT `chk_precioVentas-DetCompCliente` CHECK (`precioVenta` >= 0),
  CONSTRAINT `chk_cantConsumo-DetCompCliente`  CHECK (`cantConsumo` >  0), -- Nunca se consume 0 productos
  CONSTRAINT `chk_subtotal-DetCompCliente`     CHECK (`subtotal`    >= 0),
  
  CONSTRAINT `FK_idproducto-DetCompCliente`
    FOREIGN KEY (`idproducto`)
    REFERENCES `Bar_Rest_ElCruce`.`producto` (`idproducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idFactura-DetCompCliente`
    FOREIGN KEY (`idFactura`)
    REFERENCES `Bar_Rest_ElCruce`.`facturacliente` (`idFactura`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`facturaproveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`facturaproveedor` (
  `idfacturaproveedor`  INT 		 NOT NULL AUTO_INCREMENT,
  `idcaja` 			 	INT 		 NOT NULL,
  `idproveedor` 	 	INT 		 NOT NULL,
  `cedtrabajador` 	 	INT 		 NOT NULL,
  `fechaCompra` 	 	DATETIME 	 NOT NULL DEFAULT NOW(),
  `fechaFacturacion` 	DATETIME 	 NULL,
  `estado` 			 	VARCHAR(20)  NOT NULL DEFAULT 'Pendiente',
  `totalPago` 		 	DOUBLE(10,2) NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idfacturaproveedor`),
  INDEX `Fk_idproveedor-FactProve`    (`idproveedor` ASC),
  INDEX `FK_idtrabajador-FactProve`   (`cedtrabajador` ASC),
  INDEX `FK_idcaja-FactProve`         (`idcaja` ASC),
  
  CONSTRAINT `chk_estado-FactProve`     CHECK (`estado` = 'Pendiente' OR `estado` = 'Facturada'),
  CONSTRAINT `chk_totalPagar-FactProve` CHECK (`totalPago` >= 0),
  
  CONSTRAINT `Fk_idproveedor-FactProve`
    FOREIGN KEY (`idproveedor`)
    REFERENCES `Bar_Rest_ElCruce`.`proveedor` (`idproveedor`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idtrabajador-FactProve`
    FOREIGN KEY (`cedtrabajador`)
    REFERENCES `Bar_Rest_ElCruce`.`trabajador` (`cedula`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idcaja-FactProve`
    FOREIGN KEY (`idcaja`)
    REFERENCES `Bar_Rest_ElCruce`.`caja` (`idcaja`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;


-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`detallecompraproveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`detallecompraproveedor` (
  `idDetalleProv` INT NOT NULL AUTO_INCREMENT,
  `idFactura` 	  INT NOT NULL,
  `idproducto` 	  INT NOT NULL,
  `entrada` 	  INT NOT NULL DEFAULT 1,
  `precioCompra`  DOUBLE(10,2) NOT NULL DEFAULT 0, -- Recomendable para realizar operaciones sin hacer JOIN
  `subTotal` 	  DOUBLE(10,2) NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idDetalleProv`),
  INDEX `Fk_idproducto-DetCompProve` (`idproducto` ASC),
  INDEX `FK_idFactura-DetCompProve`  (`idFactura` ASC),
  
  CONSTRAINT `chk_entrada-DetCompProve` 	 CHECK (`entrada`      >  0), -- Nunca se compra 0 productos
  CONSTRAINT `chk_precioCompra-DetCompProve` CHECK (`precioCompra` >= 0),
  CONSTRAINT `chk_subTotale-DetCompProve` 	 CHECK (`subTotal`     >= 0),
  
  CONSTRAINT `Fk_idproducto-DetCompProve`
    FOREIGN KEY (`idproducto`)
    REFERENCES `Bar_Rest_ElCruce`.`producto` (`idproducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
    
  CONSTRAINT `FK_idFactura-DetCompProve`
    FOREIGN KEY (`idFactura`)
    REFERENCES `Bar_Rest_ElCruce`.`facturaproveedor` (`idfacturaproveedor`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;

-- -----------------------------------------------------
-- Table `Bar_Rest_ElCruce`.`inventario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Bar_Rest_ElCruce`.`inventario` (
  `idinventario` INT NOT NULL AUTO_INCREMENT,
  `idproducto`   INT NOT NULL,
  `cantMano`     INT NOT NULL DEFAULT 0,
  `stock` 		 INT NOT NULL DEFAULT 0,
  
  PRIMARY KEY (`idinventario`),
  INDEX `FK_idproducto-Inv` (`idproducto` ASC),
  
  CONSTRAINT `chk_cantMano-Inv` CHECK (`cantMano` >= 0), -- Cantidad preparada para vender
  CONSTRAINT `chk_stock-Inv`    CHECK (`stock`    >= 0), -- Cantidad restante aparte de cantMano
  
  CONSTRAINT `FK_idproducto-Inv`
    FOREIGN KEY (`idproducto`)
    REFERENCES `Bar_Rest_ElCruce`.`producto` (`idproducto`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB
AUTO_INCREMENT = 100;
