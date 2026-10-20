# Estado del proyecto - Panaderia Don Pan

Resumen verificado del sistema: que existe, que se probo y que queda
pendiente. Las evidencias originales estan en la carpeta `README/`.

## 1. Pantallas

| Pantalla | Archivo | Acceso | Estado |
|---|---|---|---|
| Login | `public/index.php` | Publico | Probada |
| Dashboard | `public/dashboard.php` | Autenticado | Probada |
| Registrar venta | `public/ventas.php` | Autenticado | Probada |
| Historial de ventas | `public/historial_ventas.php` | Autenticado (anular: dueno) | Probada |
| Productos | `public/productos.php` | Autenticado | Probada |
| Inventario | `public/inventario.php` | Autenticado | Probada |
| Clientes | `public/clientes.php` | Autenticado | Probada |
| Compras | `public/compras.php` | Solo dueno | Probada |
| Insumos | `public/insumos.php` | Solo dueno | Probada |
| Recetas | `public/recetas.php` | Solo dueno | Probada |
| Reportes | `public/reportes.php` | Solo dueno | Probada |
| Salir | `public/logout.php` | Autenticado | Activo |

Ademas: `public/js/venta-total.js` calcula el total en vivo del formulario de venta.

## 2. Base de datos (13 tablas)

`turnos`, `empleados`, `categorias`, `productos`, `clientes`, `ventas`,
`detalle_ventas`, `movimientos_inventario`, `insumos`, `recetas`,
`proveedores`, `compras`, `detalle_compras`.

Columnas agregadas por migracion: `productos.id_categoria`,
`ventas.metodo_pago`, `clientes.email` / `direccion` / `puntos`, y para la
anulacion `ventas.anulada` / `anulada_por` / `fecha_anulacion`.

### Scripts SQL

| Script | Para que sirve |
|---|---|
| `schema.sql` | Instalacion nueva completa |
| `seed.sql` | Turno + usuario `admin` |
| `seed_mer.sql` | Categorias, insumos, proveedores y clientes de ejemplo |
| `migracion_002.sql` | Agrega el modulo MER a una base ya existente |
| `migracion_003.sql` | Agrega las columnas de anulacion |
| `fix_utf8.sql` | Repara el ENUM `rol` y textos mal codificados |
| `query.sql` | Script de MongoDB (no es MySQL) |

## 3. Pruebas realizadas

| Prueba | Resultado |
|---|---|
| Sintaxis de todos los PHP (`php -l`) | Sin errores |
| Login `admin` / `1234` | 302 a `ventas.php` |
| Acceso a las 7 pantallas como dueno | HTTP 200 |
| Restriccion de rol `empleada` | Reportes bloqueado, operativas permitidas |
| Venta de 2 x $35.000 con cliente y metodo de pago | $70.000, stock 10 -> 8, movimiento registrado |
| Anulacion de venta | Stock devuelto, auditoria registrada |
| Doble anulacion | Rechazada, el stock no se duplico |
| Selector de fechas (hoy, rango, 2020, fechas invalidas) | Correcto en los 4 casos |
| Zona horaria | Corregida a `America/Bogota` |
| Total en vivo de la venta | El JS carga y los `data-precio` estan en el HTML |
| Baja logica de producto | Desaparece de Ventas, se conserva con su historial |
| Compra a proveedor | $85.000, stock de insumos 120 -> 145 y 60 -> 70 |
| Restriccion de `compras.php` | El rol `empleada` queda bloqueado |
| Anulacion de compra | Stock de insumos devuelto (150 -> 120), auditoria registrada |
| Doble anulacion de compra | Rechazada, el stock no se descontio dos veces |
| Receta creada | Producto "Pan de leche" + harina 0.5 kg |
| Receta duplicada | Rechazada con `?error=duplicado` |
| Historial de movimientos de insumos | Registra entrada y salida con motivo |
| Restriccion de `insumos.php` y `recetas.php` | El rol `empleada` queda bloqueado |

## 4. Correcciones importantes

1. **ENUM `empleados.rol` corrupto.** Se creo como `'due?o'` en vez de `'dueño'`,
   por lo que `isOwner()` nunca coincidia y el dueno no podia ver Reportes.
   Se redefine en `fix_utf8.sql`.
2. **Zona horaria.** PHP usaba `Europe/Berlin` mientras MySQL usaba la hora local
   de Colombia:8 horas de diferencia que hacian que los reportes del dia
   mostraran el dia equivocado tras las 7 de la tarde. Fijada a `America/Bogota`.
3. **`detalle_ventas` con `ON DELETE CASCADE`.** Por eso la anulacion marca la
   venta en vez de borrarla:así el historial y el stock nunca quedan inconsistentes.

## 5. Pendiente

- [x] ~~Interfaz de insumos y recetas~~ (hecho).
- [x] ~~Anular compras~~ (hecho).
- [x] ~~Historial de movimientos de insumos~~ (hecho).
- [ ] Descontar insumos automaticamente al vender, segun la receta.
- [ ] Gestion de proveedores (alta, edicion y baja logica).
- [ ] Grafico de barras de ventas por dia en el Dashboard.
- [ ] Migrar el catalogo HTML/CSS/JS de la evidencia AA4-EV01 a una vista real.