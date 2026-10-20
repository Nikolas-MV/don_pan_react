-- =========================================================
-- Migración 002 - Módulo MER: categorias, insumos y compras
-- Panadería "Don Pan"
--
-- Añade las entidades del Modelo Entidad-Relación
-- (GA6-220501096-AA1-EV02) sobre una base de datos existente.
-- NO borra datos: solo agrega tablas y columnas.
-- Para una instalación nueva basta con ejecutar schema.sql.
-- =========================================================

USE don_pan;

-- --- 1FN: tabla categorias + FK en productos ---
CREATE TABLE IF NOT EXISTS categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

-- La columna puede existir ya si se reejecuta la migración.
SET @existe_col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'productos'
      AND COLUMN_NAME = 'id_categoria'
);

SET @sql := IF(@existe_col = 0,
    'ALTER TABLE productos ADD COLUMN id_categoria INT NULL AFTER codigo_barra',
    'SELECT "productos.id_categoria ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @existe_fk := (
    SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = 'don_pan' AND TABLE_NAME = 'productos'
      AND CONSTRAINT_TYPE = 'FOREIGN KEY'
      AND CONSTRAINT_NAME = 'fk_productos_categoria'
);

SET @sql := IF(@existe_fk = 0,
    'ALTER TABLE productos ADD CONSTRAINT fk_productos_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)',
    'SELECT "fk_productos_categoria ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- --- 3FN: atributos que estaban duplicados dentro de Venta ---
SET @existe_col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'clientes' AND COLUMN_NAME = 'email'
);

SET @sql := IF(@existe_col = 0,
    'ALTER TABLE clientes ADD COLUMN email VARCHAR(120) NULL AFTER telefono, ADD COLUMN direccion VARCHAR(150) NULL AFTER email, ADD COLUMN puntos INT NOT NULL DEFAULT 0 AFTER direccion',
    'SELECT "clientes ya tiene email/direccion/puntos"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- --- Ventas: metodo de pago ---
SET @existe_col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'ventas' AND COLUMN_NAME = 'metodo_pago'
);

SET @sql := IF(@existe_col = 0,
    "ALTER TABLE ventas ADD COLUMN metodo_pago ENUM('efectivo','tarjeta','transferencia') NOT NULL DEFAULT 'efectivo' AFTER total",
    'SELECT "ventas.metodo_pago ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- --- Módulo de insumos, recetas, proveedores y compras ---
CREATE TABLE IF NOT EXISTS insumos (
    id_insumo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    unidad VARCHAR(20) NOT NULL DEFAULT 'kg',
    stock_actual INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 5
);

CREATE TABLE IF NOT EXISTS recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT NOT NULL,
    id_insumo INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo)
);

CREATE TABLE IF NOT EXISTS proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    email VARCHAR(120),
    activo TINYINT(1) NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS compras (
    id_compra INT AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT NOT NULL,
    id_empleado INT NULL,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE IF NOT EXISTS detalle_compras (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_compra INT NOT NULL,
    id_insumo INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_compra) REFERENCES compras(id_compra) ON DELETE CASCADE,
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo)
);

CREATE INDEX IF NOT EXISTS idx_compras_fecha ON compras(fecha_hora);

SELECT 'Migración 002 aplicada correctamente' AS resultado;