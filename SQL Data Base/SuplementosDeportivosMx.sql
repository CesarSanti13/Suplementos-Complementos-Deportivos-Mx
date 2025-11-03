CREATE DATABASE IF NOT EXISTS SuplementosDeportivosMx;


CREATE TABLE `Categoria` (
  `idCategoria` int NOT NULL,
  `nombreCategoria` varchar(100) NOT NULL
);

CREATE TABLE `Clientes` (
  `telefono` varchar(20) NOT NULL,
  `idEmpleado` int NOT NULL,
  `nombreCliente` varchar(100) NOT NULL,
  `apellidosCliente` varchar(150) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `seudonimo` varchar(100) DEFAULT NULL,
  `comentarios` varchar(150) DEFAULT NULL,
  `tipoCliente` enum('Publico','Mayoreo','Super Mayoreo','VIP') NOT NULL,
  `porcentajeComision` decimal(5,4) NOT NULL DEFAULT '0.0000'
);

CREATE TABLE `Cotizacion` (
  `idCotizacion` int NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `idEmpleado` int NOT NULL,
  `fechaCotizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `totalCotizacion` decimal(12,2) NOT NULL DEFAULT '0.00',
  `descuentoGlobal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `estatus` enum('Pendiente','Aprobada','Cancelada') NOT NULL DEFAULT 'Pendiente',
  `razonDescuento` varchar(100) DEFAULT NULL,
  `comentarios` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `DetalleCotizacion` (
  `idDetalleCotizacion` int NOT NULL,
  `idCotizacion` int NOT NULL,
  `idProducto` int NOT NULL,
  `cantidad` int UNSIGNED NOT NULL,
  `precioUnitario` decimal(12,2) NOT NULL,
  `descuentoProducto` decimal(12,2) NOT NULL DEFAULT '0.00',
  `totalDetalleCotizacion` decimal(12,2) GENERATED ALWAYS AS (((`cantidad` * `precioUnitario`) - `descuentoProducto`)) STORED
);

CREATE TABLE `DetalleVenta` (
  `idDetalleVenta` int NOT NULL,
  `idVenta` int NOT NULL,
  `idProducto` int NOT NULL,
  `cantidad` int UNSIGNED NOT NULL,
  `costoSnapshot` decimal(12,2) NOT NULL DEFAULT '0.00',
  `precioUnitario` decimal(12,2) NOT NULL,
  `descuentoProducto` decimal(12,2) NOT NULL DEFAULT '0.00',
  `porcentajeComisionAplicada` decimal(5,4) NOT NULL DEFAULT '0.0000',
  `costoSnapShotTotal` decimal(12,2) GENERATED ALWAYS AS ((`cantidad` * `costoSnapshot`)) STORED,
  `subTotalDetalleVenta` decimal(12,2) GENERATED ALWAYS AS ((`cantidad` * `precioUnitario`)) STORED,
  `totalDetalleVenta` decimal(12,2) GENERATED ALWAYS AS ((`subTotalDetalleVenta` - `descuentoProducto`)) STORED,
  `margen` decimal(12,2) GENERATED ALWAYS AS ((`totalDetalleVenta` - `costoSnapShotTotal`)) STORED,
  `montoComision` decimal(12,2) GENERATED ALWAYS AS ((case when ((`totalDetalleVenta` - `costoSnapShotTotal`) < 1) then 0 else round(((`totalDetalleVenta` - `costoSnapShotTotal`) * ifnull(`porcentajeComisionAplicada`,0)),2) end)) STORED,
  `margenEmpresa` decimal(12,2) GENERATED ALWAYS AS (((`totalDetalleVenta` - `costoSnapShotTotal`) - greatest(round(((`totalDetalleVenta` - `costoSnapShotTotal`) * ifnull(`porcentajeComisionAplicada`,0)),2),0))) STORED
);

CREATE TABLE `Direcciones` (
  `idDireccion` int NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `calle` varchar(150) NOT NULL,
  `numExterior` varchar(10) NOT NULL,
  `numInterior` varchar(10) DEFAULT NULL,
  `codigoPostal` varchar(10) NOT NULL,
  `colonia` varchar(100) NOT NULL,
  `ciudad` varchar(100) NOT NULL,
  `estado` enum('Aguascalientes','Baja California','Baja California Sur','Campeche','Chiapas','Chihuahua','Ciudad de México','Coahuila','Colima','Durango','Guanajuato','Guerrero','Hidalgo','Jalisco','México','Michoacán','Morelos','Nayarit','Nuevo León','Oaxaca','Puebla','Querétaro','Quintana Roo','San Luis Potosí','Sinaloa','Sonora','Tabasco','Tamaulipas','Tlaxcala','Veracruz','Yucatán','Zacatecas') DEFAULT NULL
);

CREATE TABLE `Empleados` (
  `idEmpleado` int NOT NULL,
  `nombreEmpleado` varchar(120) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `rol` enum('Administrativo','Vendedor','Cajero','Almacen','Paqueteria','Otro') NOT NULL,
  `estatus` enum('Activo','Inactivo','Suspendido') NOT NULL DEFAULT 'Activo',
  `fechaIngreso` date DEFAULT NULL,
  `fechaSalida` date DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE `Marca` (
  `idMarca` int NOT NULL,
  `nombreMarca` varchar(100) NOT NULL
);

CREATE TABLE `Producto` (
  `idProducto` int NOT NULL,
  `idCategoria` int NOT NULL,
  `idMarca` int NOT NULL,
  `nombreProducto` varchar(150) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `codigoBarras` varchar(50) DEFAULT NULL,
  `SKU` varchar(50) DEFAULT NULL,
  `existencias` int DEFAULT '0',
  `existenciasMinimas` int DEFAULT '0',
  `costo` decimal(12,2) NOT NULL DEFAULT '0.00',
  `precioPublico` decimal(12,2) NOT NULL DEFAULT '0.00',
  `precioMayoreo` decimal(12,2) NOT NULL DEFAULT '0.00',
  `precioSuperMayoreo` decimal(12,2) NOT NULL DEFAULT '0.00',
  `precioVIP` decimal(12,2) NOT NULL DEFAULT '0.00',
  `fechaCaducidad` date DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL
);

CREATE TABLE `Venta` (
  `idVenta` int NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `idEmpleado` int NOT NULL,
  `idDireccion` int DEFAULT NULL,
  `idCotizacion` int DEFAULT NULL,
  `fechaVenta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `subTotalVenta` decimal(12,2) NOT NULL DEFAULT '0.00',
  `descuentoGlobal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `totalVenta` decimal(12,2) GENERATED ALWAYS AS ((`subTotalVenta` - `descuentoGlobal`)) STORED,
  `estado` enum('Pendiente','Pagada','Cancelada') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Pendiente',
  `razonCancelada` varchar(255) DEFAULT NULL,
  `razonDescuento` varchar(100) DEFAULT NULL,
  `comentarios` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE `Categoria`
  ADD PRIMARY KEY (`idCategoria`),
  ADD UNIQUE KEY `uq_categoria_nombre` (`nombreCategoria`);

--
-- Index Table `Clientes`
--
ALTER TABLE `Clientes`
  ADD PRIMARY KEY (`telefono`),
  ADD KEY `fk_cliente_empleado` (`idEmpleado`),
  ADD KEY `idx_clientes_seudonimo` (`seudonimo`);

--
-- Index Table `Cotizacion`
--
ALTER TABLE `Cotizacion`
  ADD PRIMARY KEY (`idCotizacion`),
  ADD KEY `ix_cot_cliente` (`telefono`),
  ADD KEY `ix_cot_empleado` (`idEmpleado`),
  ADD KEY `ix_cot_estatus` (`estatus`);

--
-- Index Table `DetalleCotizacion`
--
ALTER TABLE `DetalleCotizacion`
  ADD PRIMARY KEY (`idDetalleCotizacion`),
  ADD KEY `ix_det_cot_cotizacion` (`idCotizacion`),
  ADD KEY `ix_det_cot_producto` (`idProducto`);

--
-- Index Table `DetalleVenta`
--
ALTER TABLE `DetalleVenta`
  ADD PRIMARY KEY (`idDetalleVenta`),
  ADD KEY `ix_detventa_venta` (`idVenta`),
  ADD KEY `ix_detventa_producto` (`idProducto`);

--
-- Index Table `Direcciones`
--
ALTER TABLE `Direcciones`
  ADD PRIMARY KEY (`idDireccion`),
  ADD KEY `ix_dir_telefono` (`telefono`),
  ADD KEY `ix_dir_cp` (`codigoPostal`),
  ADD KEY `ix_dir_estado` (`estado`),
  ADD KEY `ix_dir_ciudad` (`ciudad`);

--
-- Index Table `Empleados`
--
ALTER TABLE `Empleados`
  ADD PRIMARY KEY (`idEmpleado`),
  ADD UNIQUE KEY `uq_empleado_usuario` (`usuario`),
  ADD UNIQUE KEY `uq_empleado_email` (`email`),
  ADD UNIQUE KEY `uq_empleado_telefono` (`telefono`);

--
-- Index Table `Marca`
--
ALTER TABLE `Marca`
  ADD PRIMARY KEY (`idMarca`),
  ADD UNIQUE KEY `uq_marca_nombre` (`nombreMarca`);

--
-- Index Table `Producto`
--
ALTER TABLE `Producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD UNIQUE KEY `uq_prod_codigobarras` (`codigoBarras`),
  ADD UNIQUE KEY `uq_prod_sku` (`SKU`),
  ADD KEY `ix_prod_categoria` (`idCategoria`),
  ADD KEY `ix_prod_marca` (`idMarca`),
  ADD KEY `ix_prod_nombre` (`nombreProducto`);

--
-- Index Table `Venta`
--
ALTER TABLE `Venta`
  ADD PRIMARY KEY (`idVenta`),
  ADD KEY `ix_venta_fechaVenta` (`fechaVenta`),
  ADD KEY `ix_venta_cliente` (`telefono`),
  ADD KEY `ix_venta_empleado` (`idEmpleado`),
  ADD KEY `ix_venta_direccion` (`idDireccion`),
  ADD KEY `ix_venta_estatus` (`estado`),
  ADD KEY `ix_venta_cotizacion` (`idCotizacion`);

--
-- AUTO_INCREMENT table `Categoria`
--
ALTER TABLE `Categoria`
  MODIFY `idCategoria` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT table `Cotizacion`
--
ALTER TABLE `Cotizacion`
  MODIFY `idCotizacion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT table `DetalleCotizacion`
--
ALTER TABLE `DetalleCotizacion`
  MODIFY `idDetalleCotizacion` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT table `DetalleVenta`
--
ALTER TABLE `DetalleVenta`
  MODIFY `idDetalleVenta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT table `Direcciones`
--
ALTER TABLE `Direcciones`
  MODIFY `idDireccion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT table `Empleados`
--
ALTER TABLE `Empleados`
  MODIFY `idEmpleado` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT table `Marca`
--
ALTER TABLE `Marca`
  MODIFY `idMarca` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT table `Producto`
--
ALTER TABLE `Producto`
  MODIFY `idProducto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

--
-- AUTO_INCREMENT table `Venta`
--
ALTER TABLE `Venta`
  MODIFY `idVenta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=0;

-- --------------------------------------------------------

--
-- Foreing Keys Table `Clientes`
--
ALTER TABLE `Clientes`
  ADD CONSTRAINT `fk_cliente_empleado` FOREIGN KEY (`idEmpleado`) REFERENCES `Empleados` (`idEmpleado`) ON UPDATE CASCADE;

--
-- Foreing Keys Table `Cotizacion`
--
ALTER TABLE `Cotizacion`
  ADD CONSTRAINT `fk_cot_cliente` FOREIGN KEY (`telefono`) REFERENCES `Clientes` (`telefono`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cot_empleado` FOREIGN KEY (`idEmpleado`) REFERENCES `Empleados` (`idEmpleado`) ON UPDATE CASCADE;

--
-- Foreing Keys Table `DetalleCotizacion`
--
ALTER TABLE `DetalleCotizacion`
  ADD CONSTRAINT `fk_det_cot_cotizacion` FOREIGN KEY (`idCotizacion`) REFERENCES `Cotizacion` (`idCotizacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_det_cot_producto` FOREIGN KEY (`idProducto`) REFERENCES `Producto` (`idProducto`) ON UPDATE CASCADE;

--
-- Foreing Keys Table `DetalleVenta`
--
ALTER TABLE `DetalleVenta`
  ADD CONSTRAINT `fk_detventa_producto` FOREIGN KEY (`idProducto`) REFERENCES `Producto` (`idProducto`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detventa_venta` FOREIGN KEY (`idVenta`) REFERENCES `Venta` (`idVenta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Foreing Keys Table `Direcciones`
--
ALTER TABLE `Direcciones`
  ADD CONSTRAINT `fk_dir_cliente` FOREIGN KEY (`telefono`) REFERENCES `Clientes` (`telefono`) ON UPDATE CASCADE;

--
-- Foreing Keys Table `Producto`
--
ALTER TABLE `Producto`
  ADD CONSTRAINT `fk_prod_categoria` FOREIGN KEY (`idCategoria`) REFERENCES `Categoria` (`idCategoria`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_prod_marca` FOREIGN KEY (`idMarca`) REFERENCES `Marca` (`idMarca`) ON UPDATE CASCADE;

--
-- Foreing Keys Table `Venta`
--
ALTER TABLE `Venta`
  ADD CONSTRAINT `fk_venta_cliente` FOREIGN KEY (`telefono`) REFERENCES `Clientes` (`telefono`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_venta_cotizacion` FOREIGN KEY (`idCotizacion`) REFERENCES `Cotizacion` (`idCotizacion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_venta_direccion` FOREIGN KEY (`idDireccion`) REFERENCES `Direcciones` (`idDireccion`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_venta_empleado` FOREIGN KEY (`idEmpleado`) REFERENCES `Empleados` (`idEmpleado`) ON UPDATE CASCADE;
COMMIT;