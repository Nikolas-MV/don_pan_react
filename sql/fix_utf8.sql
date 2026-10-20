USE don_pan;
SET NAMES utf8mb4;
-- La definición del ENUM quedó con el texto corrupto ('due?o'), por lo que
-- isOwner() nunca coincidía con 'dueño'. Se redefine el ENUM correctamente.
ALTER TABLE empleados MODIFY rol ENUM('dueño','empleada') NOT NULL DEFAULT 'empleada';
UPDATE empleados SET rol = 'dueño' WHERE id_empleado = 1;
SELECT id_empleado, usuario, rol, HEX(rol) AS rol_hex, activo FROM empleados;