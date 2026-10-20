-- =========================================================
-- Migracion 003 - Anulacion de ventas con reversa de stock
-- Panaderia "Don Pan"
--
-- Anade una marca de anulacion y auditoria a `ventas`.
-- NO borra datos: solo agrega columnas.
-- =========================================================

USE don_pan;

SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'ventas' AND COLUMN_NAME = 'anulada'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE ventas ADD COLUMN anulada TINYINT(1) NOT NULL DEFAULT 0 AFTER total',
    'SELECT "ventas.anulada ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'ventas' AND COLUMN_NAME = 'anulada_por'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE ventas ADD COLUMN anulada_por INT NULL AFTER anulada',
    'SELECT "ventas.anulada_por ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'ventas' AND COLUMN_NAME = 'fecha_anulacion'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE ventas ADD COLUMN fecha_anulacion DATETIME NULL AFTER anulada_por',
    'SELECT "ventas.fecha_anulacion ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk := (
    SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = 'don_pan' AND TABLE_NAME = 'ventas'
      AND CONSTRAINT_NAME = 'fk_ventas_anulada_por'
);
SET @sql := IF(@fk = 0,
    'ALTER TABLE ventas ADD CONSTRAINT fk_ventas_anulada_por FOREIGN KEY (anulada_por) REFERENCES empleados(id_empleado)',
    'SELECT "fk_ventas_anulada_por ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Indice para no listar ventas anuladas en los reportes.
SET @idx := (
    SELECT COUNT(*) FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'ventas' AND INDEX_NAME = 'idx_ventas_anulada'
);
SET @sql := IF(@idx = 0,
    'CREATE INDEX idx_ventas_anulada ON ventas(anulada)',
    'SELECT "idx_ventas_anulada ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT 'Migracion 003 aplicada correctamente' AS resultado;