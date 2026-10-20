USE don_pan;

INSERT INTO turnos (nombre, hora_inicio, hora_fin) VALUES ('Mañana','06:00:00','14:00:00');

INSERT INTO empleados (nombre, usuario, password_hash, rol, id_turno)
VALUES ('Admin','admin','$2y$10$gwQglB6qKLbQS/M2MOJQBOC6vS3V9Gf1glDHyEeHCAC5t596hHJgS','dueño',1);
-- La contraseña de este hash es: 1234
-- Regenerar con: php -r "echo password_hash('1234', PASSWORD_DEFAULT);"

-- =========================================================
-- Datos iniciales del módulo MER (categorías e insumos)
-- =========================================================

INSERT INTO categorias (nombre, descripcion) VALUES
  ('Panes',       'Panes artesanales y tradicionales'),
  ('Pastelería',  'Pasteles, tortas y postres'),
  ('Galletas',    'Galletas y bizcochos'),
  ('Bebidas',     'Café, jugos y bebidas frías');

INSERT INTO proveedores (nombre, contacto, telefono, email) VALUES
  ('Molinos del Sur',   'Carla Restrepo', '3105551122', 'compras@molinosdelsur.com'),
  ('Lácteos La Pradera','Julián Herrera', '3154447788', 'ventas@lacteoslapradera.com');

INSERT INTO insumos (nombre, unidad, stock_actual, stock_minimo) VALUES
  ('Harina de trigo',   'kg',  120, 40),
  ('Azúcar refinada',   'kg',   60, 20),
  ('Mantequilla',       'kg',   18, 10),
  ('Leche entera',      'L',    90, 30),
  ('Huevos',            'unidad', 200, 60);

-- Recetas: cuántos insumos usa cada producto (N:N resuelta con tabla intermedia)
INSERT INTO recetas (id_producto, id_insumo, cantidad) VALUES
  (1, 1, 0.5),  -- Pan Francés  -> harina
  (1, 2, 0.1),  -- Pan Francés  -> azúcar
  (1, 3, 0.05); -- Pan Francés  -> mantequilla