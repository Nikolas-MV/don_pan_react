USE don_pan;

INSERT IGNORE INTO categorias (nombre, descripcion) VALUES
  ('Panes','Panes artesanales y tradicionales'),
  ('Pastelería','Pasteles, tortas y postres'),
  ('Galletas','Galletas y bizcochos'),
  ('Bebidas','Café, jugos y bebidas frías');

INSERT IGNORE INTO proveedores (nombre, contacto, telefono, email) VALUES
  ('Molinos del Sur','Carla Restrepo','3105551122','compras@molinosdelsur.com'),
  ('Lácteos La Pradera','Julián Herrera','3154447788','ventas@lacteoslapradera.com');

INSERT IGNORE INTO insumos (nombre, unidad, stock_actual, stock_minimo) VALUES
  ('Harina de trigo','kg',120,40),
  ('Azúcar refinada','kg',60,20),
  ('Mantequilla','kg',18,10),
  ('Leche entera','L',90,30),
  ('Huevos','unidad',200,60);

INSERT IGNORE INTO clientes (nombre, telefono, email, direccion, puntos) VALUES
  ('Ana Pérez','3124567890','ana@gmail.com','Calle 123 #45-67',150),
  ('Luis Gómez','3109876543','luis@hotmail.com','Carrera 45 #67-89',80);

UPDATE productos SET id_categoria = 1 WHERE nombre LIKE '%Franc%';