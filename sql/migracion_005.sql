-- =========================================================
-- Migracion 005 - Modulo de produccion completo
-- Panaderia "Don Pan"
--
-- 1) Historial de movimientos de insumos (no caben en
--    movimientos_inventario porque esa tabla apunta a productos).
-- 2) Anulacion de compras, con devolucion de insumos.
-- 3) Unicidad de la receta: un insumo no se repite por producto.
-- NO borra datos: solo agrega tablas, columnas e indices.
-- =========================================================

USE don_pan;

-- --- 1. Historial de movimientos de insumos ---
CREATE TABLE IF NOT EXISTS movimientos_insumos (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_insumo INT NOT NULL,
    id_empleado INT NULL,
    tipo ENUM('entrada','salida','ajuste') NOT NULL,
    cantidad INT NOT NULL,
    motivo VARCHAR(150),
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_insumo) REFERENCES insumos(id_insumo),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE INDEX IF NOT EXISTS idx_mov_insumos_insumo ON movimientos_insumos(id_insumo);
CREATE INDEX IF NOT EXISTS idx_mov_insumos_fecha ON movimientos_insumos(fecha_hora);

-- --- 2. Anulacion de compras ---
SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'compras' AND COLUMN_NAME = 'anulada'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE compras ADD COLUMN anulada TINYINT(1) NOT NULL DEFAULT 0 AFTER total',
    'SELECT "compras.anulada ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'compras' AND COLUMN_NAME = 'anulada_por'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE compras ADD COLUMN anulada_por INT NULL AFTER anulada',
    'SELECT "compras.anulada_por ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col := (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'compras' AND COLUMN_NAME = 'fecha_anulacion'
);
SET @sql := IF(@col = 0,
    'ALTER TABLE compras ADD COLUMN fecha_anulacion DATETIME NULL AFTER anulada_por',
    'SELECT "compras.fecha_anulacion ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk := (
    SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = 'don_pan' AND TABLE_NAME = 'compras'
      AND CONSTRAINT_NAME = 'fk_compras_anulada_por'
);
SET @sql := IF(@fk = 0,
    'ALTER TABLE compras ADD CONSTRAINT fk_compras_anulada_por FOREIGN KEY (anulada_por) REFERENCES empleados(id_empleado)',
    'SELECT "fk_compras_anulada_por ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

CREATE INDEX IF NOT EXISTS idx_compras_anulada ON compras(anulada);

-- --- 3. Un insumo no se repite dentro de la misma receta ---
SET @idx := (
    SELECT COUNT(*) FROM information_schema.STATISTICS
    WHERE TABLE_SCHEMA = 'don_pan' AND TABLE_NAME = 'recetas'
      AND INDEX_NAME = 'idx_recetas_unicidad'
);
SET @sql := IF(@idx = 0,
    'CREATE UNIQUE INDEX idx_recetas_unicidad ON recetas(id_producto, id_insumo)',
    'SELECT "idx_recetas_unicidad ya existe"');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SELECT 'Migracion 005 aplicada correctamente' AS resultado;