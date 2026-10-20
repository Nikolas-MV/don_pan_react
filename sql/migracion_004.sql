-- =========================================================
-- Migracion 004 - Baja logica de productos y clientes
-- Panaderia "Don Pan"
--
-- Agrega la columna `activo` para dar de baja registros sin
-- borrarlos: asi el historial de ventas y movimientos no se rompe.
-- NO borra datos: solo agrega columnas.
-- =========================================================

USE don_pan;

SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'productos' AND COLUMN_NAME = 'activo'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE productos ADD COLUMN activo TINYINT(1) NOT NULL DEFAULT 1 AFTER id_categoria',
    'SELECT "productos.activo ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'clientes' AND COLUMN_NAME = 'activo'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE clientes ADD COLUMN activo TINYINT(1) NOT NULL DEFAULT 1 AFTER puntos',
    'SELECT "clientes.activo ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE INDEX IF NOT EXISTS idx_productos_activo ON productos(activo);
CREATE INDEX IF NOT EXISTS idx_clientes_activo ON clientes(activo);

SELECT 'Migracion 004 aplicada correctamente' AS resultado;