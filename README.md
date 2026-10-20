# Panadería "Don Pan" — Sistema de Gestión

Sistema web (HTML + CSS + PHP + MySQL) para la gestión integral de la panadería:
ventas, inventario, productos, clientes y reportes.

El modelo de datos sigue el Modelo Entidad-Relación y la normalización hasta 3FN
documentados en la carpeta `README/`. Ver `docs/modelo-relacional.md`.

## Estructura del proyecto

```
don_pan/
├── config/
│   ├── db.php                 # Única fuente de conexión a MySQL
│   └── mongo.php              # Conexión a MongoDB (script de la evidencia AA1-EV03)
├── includes/
│   ├── auth.php               # Sesión y control de acceso (login/rol)
│   ├── csrf.php               # Token CSRF para formularios
│   ├── helpers.php            # Registro de errores y redirección
│   ├── header.php             # Navegación reutilizable
│   └── footer.php
├── actions/                   # Lógica de escritura (POST -> DB)
│   ├── login_action.php
│   ├── venta_action.php
│   ├── inventario_action.php
│   ├── producto_action.php
│   ├── producto_editar_action.php
│   ├── cliente_action.php
│   ├── anular_venta_action.php  # Anula una venta y devuelve el stock
│   ├── anular_compra_action.php # Anula una compra y revierte insumos
│   ├── receta_action.php      # Alta y baja de recetas de producción
│   ├── producto_estado_action.php  # Baja/reactiva un producto
│   ├── cliente_estado_action.php   # Baja/reactiva un cliente
│   └── compra_action.php       # Registra compras a proveedores
├── public/                    # Vistas (lo que el usuario ve/navega)
│   ├── index.php              # Login
│   ├── dashboard.php          # Resumen del negocio (tarjetas + accesos rápidos)
│   ├── ventas.php             # Conexión 2: Ventas <-> Inventario
│   ├── historial_ventas.php   # Historial de ventas (anular: solo dueño)
│   ├── productos.php          # Gestión de productos (buscar, crear, editar)
│   ├── inventario.php         # Flujo 2: entradas de proveedor + alertas
│   ├── clientes.php           # Conexión 4: Cliente <-> Sistema
│   ├── insumos.php            # Stock de insumos + historial de movimientos
│   ├── recetas.php            # Recetas: qué insumos usa cada producto
│   ├── compras.php            # Compras a proveedores (solo dueño)
│   ├── reportes.php           # Flujo 3: decisiones en tiempo real (solo dueño)
│   ├── logout.php
│   ├── css/style.css          # Paleta y componentes del diseño documentado
│   ├── js/venta-total.js      # Total en vivo del formulario de venta
│   └── img/logo.png
├── sql/
│   ├── schema.sql             # Esquema completo (instalación nueva)
│   ├── seed.sql               # Datos iniciales (turno + usuario admin)
│   ├── seed_mer.sql           # Datos de ejemplo del módulo MER
│   ├── migracion_002.sql      # Agrega el módulo MER a una base existente
│   ├── migracion_003.sql      # Anulación de ventas con reversa de stock
│   ├── migracion_004.sql      # Baja lógica de productos y clientes
│   ├── migracion_005.sql      # Módulo de producción: movimientos y anulación de compras
│   ├── fix_utf8.sql           # Repara el ENUM `rol` y textos corruptos
│   └── query.sql              # Script de MongoDB (no es MySQL)
├── docs/                      # Documentación técnica
│   ├── modelo-relacional.md
│   ├── componentes-front-end.md
│   └── plan-de-trabajo.md
└── README/                    # Evidencias originales en .docx (no se modifican)
```

## Instalación

> [!IMPORTANT]
> **Guía completa de base de datos y de MySQL Workbench: ver [`mysql.md`](mysql.md).**
> Ahí están los valores exactos de conexión (127.0.0.1:3306, usuario `root`,
> contraseña vacía, SSL desactivado) y la solución a los errores típicos con XAMPP.

1. Crear la base de datos (Windows / PowerShell, usando el MySQL de XAMPP):
   ```powershell
   & 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp --default-character-set=utf8mb4 -e "source C:/ruta/al/proyecto/sql/schema.sql"
   & 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp --default-character-set=utf8mb4 -e "source C:/ruta/al/proyecto/sql/seed.sql"
   & 'C:\xampp\mysql\bin\mysql.exe' -u root --protocol=tcp --default-character-set=utf8mb4 -e "source C:/ruta/al/proyecto/sql/seed_mer.sql"
   ```
   (En Linux/macOS sigue valiendo `mysql -u root -p < sql/schema.sql`.)

   Si la base **ya existe** y quieres agregar el módulo MER sin perder datos, ejecuta
   en su lugar `sql/migracion_002.sql`, `sql/migracion_003.sql` y `sql/fix_utf8.sql`.

2. Ajustar credenciales en `config/db.php` si no usas `root` sin contraseña.

3. Empleado inicial creado por `sql/seed.sql`: usuario **`admin`**, contraseña **`1234`**.
   El rol debe quedar exactamente como `dueño` (con eñe) para que los reportes
   funcionen. Verifícalo con `SELECT rol FROM empleados;`. Si aparece vacío o con
   caracteres raros, ejecuta `sql/fix_utf8.sql`.

4. Iniciar la aplicación:
   ```
   start http://localhost/don_pan/
   ```

5. Alternativa con el servidor de PHP:
   ```bash
   php -S localhost:8000 -t public
   ```

> [!NOTE]
> `sql/query.sql` **no** es de MySQL: es un script de MongoDB (`config/mongo.php`).

## Base de datos

13 tablas. Las 7 originales más las 6 del MER (GA6-220501096-AA1-EV02):

| Tabla | Origen | Descripción |
|---|---|---|
| `turnos` | Mapa de procesos | Turnos de trabajo (Conexión 1) |
| `empleados` | Mapa de procesos | Personal; incluye usuario, hash y rol |
| `productos` | Mapa de procesos + MER | Productos, stock y FK a `categorias` |
| `categorias` | MER | Clasificación de productos |
| `clientes` | Mapa de procesos + MER | Clientes con email, dirección y puntos |
| `ventas` | Mapa de procesos + MER | Ventas con método de pago y auditoría de anulación |
| `detalle_ventas` | Mapa de procesos | Productos de cada venta |
| `movimientos_inventario` | Mapa de procesos | Entradas, salidas y ajustes |
| `insumos` | MER | Materias primas |
| `recetas` | MER | Relación N:N producto ↔ insumo |
| `proveedores` | MER | Proveedores de insumos |
| `compras` | MER | Registro de compras a proveedores |
| `detalle_compras` | MER | Insumos de cada compra |

## Trazabilidad con el mapa de procesos

| Conexión/Flujo | Implementación |
|---|---|
| Conexión 1: Turno A ↔ Turno B | Tabla `turnos`, historial en `ventas.id_turno` |
| Conexión 2: Ventas ↔ Inventario | `venta_action.php` descuenta `productos.stock_actual` en transacción |
| Conexión 3: Operación ↔ Gerencia | `reportes.php` y `dashboard.php` (solo rol `dueño`) |
| Conexión 4: Cliente ↔ Sistema | `clientes.php` + `cliente_action.php`, la venta registra `id_cliente` |
| Flujo 2: Control de inventario | `inventario.php` + `inventario_action.php` (entradas de proveedor) |
| Flujo 3: Toma de decisiones | `reportes.php` con selector de periodo, top productos y alertas de stock |

## Anulación de ventas

Una venta mal digitada se corrige desde `historial_ventas.php` (solo el dueño).
Al anular, dentro de **una sola transacción**:

1. La venta se marca con `anulada = 1`, `anulada_por` y `fecha_anulacion`.
2. El stock de cada producto se devuelve (`stock_actual + cantidad`).
3. Se registra un movimiento de tipo `entrada` con el motivo de la anulación.

La venta **no se borra**: se conserva para la auditoría y queda excluida de los
reportes. Un `SELECT ... FOR UPDATE` evita que dos anulaciones simultáneas
devuelvan el stock dos veces.

## Baja lógica de productos y clientes

Productos y clientes no se borran: se marcan con `activo = 0`. Así una venta
antigua sigue mostrando el nombre del producto aunque hoy ya no se venda.

- Un producto dado de baja **desaparece del punto de venta**.
- El enlace *"Ver productos dados de baja"* permite consultarlos y reactivarlos.
- `clientes.php` funciona igual, y un cliente dado de baja libera su teléfono.

## Seguridad

- Consultas preparadas (`mysqli` + `bind_param`) en todos los accesos a datos.
- Salida escapada con `htmlspecialchars()`.
- Token CSRF en todos los formularios (`includes/csrf.php`).
- Sesión con cookie `httponly`, `samesite=Lax` y regeneración de ID al iniciar sesión.
- Bloqueo temporal de 1 minuto tras 5 intentos fallidos de login.
- `config/` e `includes/` bloqueados por `.htaccess`.
- Zona horaria fijada a `America/Bogota` en `config/db.php` para que PHP y MySQL
  coincidan; sin esto los reportes por fecha muestran el día equivocado.

## Compras a proveedores

`compras.php` (solo dueño) registra compras de insumos. En una transacción
inserta la cabecera en `compras`, el detalle en `detalle_compras` y suma el
`stock_actual` de cada `insumo` afectado.

Cada cambio de stock queda registrado en `movimientos_insumos` (tabla aparte de
`movimientos_inventario`, que tiene clave foránea a `productos` y no a insumos).

Las compras se pueden **anular** desde la misma pantalla: se marcan con
`anulada = 1`, se descuenta el stock devuelto y se registra el movimiento de
salida. Si algún insumo quedaría en negativo, la anulación se rechaza entera.

## Módulo de producción

- **`insumos.php`** — stock actual vs. mínimo, alerta de reposición e historial
  de los últimos 100 movimientos.
- **`recetas.php`** — define qué insumos y en qué cantidad usa cada producto.
  Resuelve la relación N:N del MER y evita insumos repetidos en una misma receta
  mediante el índice único `idx_recetas_unicidad`.

## Total en vivo

`public/js/venta-total.js` calcula el total mientras el cajero escribe cantidades,
marca en rojo las filas que superan el stock y desactiva el botón *Cobrar* si
falta algo por corregir. Es la prevención de errores descrita en el diseño.

## Documentación

| Documento | Contenido |
|---|---|
| [`docs/estado-del-proyecto.md`](docs/estado-del-proyecto.md) | Qué pantallas existen, qué se probó y qué falta |
| [`docs/modelo-relacional.md`](docs/modelo-relacional.md) | MER, cardinalidades y normalización 3FN |
| [`docs/componentes-front-end.md`](docs/componentes-front-end.md) | Paleta de colores, pantallas y componentes |
| [`docs/plan-de-trabajo.md`](docs/plan-de-trabajo.md) | Herramientas, Git/GitHub y estándares de código |
| [`mysql.md`](mysql.md) | Guía de conexión a MySQL con XAMPP |
| `README/` | Evidencias originales en `.docx` (se conservan intactas) |
