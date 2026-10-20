# Modelo Relacional y Normalización — Panadería Don Pan

Evidencias de referencia: `TRA-NK - Resolución de Problemas Aplicando...docx`
(GA6-220501096-AA1-EV01) y `TRA-NK - Modelo Entidad Relación De Caso..docx`
(GA6-220501096-AA1-EV02).

Este documento resume el modelo de datos del sistema. El detalle de las
evidencia originales (con capturas de pantalla) vive en la carpeta `README/`.

## 1. Entidades del sistema

| # | Entidad | Descripción |
|---|---|---|
| 1 | Cliente | Persona que compra en la panadería |
| 2 | Venta | Transacción de compra realizada por un cliente |
| 3 | DetalleVenta | Productos específicos vendidos en cada venta |
| 4 | Producto | Productos ofrecidos por la panadería |
| 5 | Categoria | Clasificación de productos (panes, pasteles, etc.) |
| 6 | Insumo | Materias primas para la producción |
| 7 | Receta | Relación entre productos e insumos (cantidades necesarias) |
| 8 | Proveedor | Empresa que suministra insumos |
| 9 | Compra | Registro de adquisición de insumos |
| 10 | DetalleCompra | Insumos específicos comprados en cada compra |
| 11 | Empleado | Personal que trabaja en la panadería |
| 12 | Usuario | Credenciales de acceso al sistema (asociado a un empleado) |

## 2. Cardinalidades

| Relación | Cardinalidad | Explicación |
|---|---|---|
| Cliente → Venta | 1 : N | Un cliente puede hacer muchas ventas, pero una venta pertenece a un solo cliente. |
| Venta → DetalleVenta | 1 : N | Una venta puede tener muchos detalles (productos). |
| DetalleVenta → Producto | N : 1 | Muchos detalles pueden referirse al mismo producto. |
| Producto → Categoria | N : 1 | Muchos productos pueden pertenecer a la misma categoría. |
| Producto → Receta | 1 : N | Un producto puede tener muchas recetas (insumos distintos). |
| Receta → Insumo | N : 1 | Muchas recetas pueden usar el mismo insumo. |
| Proveedor → Compra | 1 : N | Un proveedor puede tener muchas compras. |
| Compra → DetalleCompra | 1 : N | Una compra puede tener muchos detalles (insumos). |
| DetalleCompra → Insumo | N : 1 | Muchos detalles pueden referirse al mismo insumo. |
| Empleado → Usuario | 1 : 1 | Un empleado tiene un único usuario y viceversa. |

Las relaciones N:N se resuelven con tablas intermedias (`recetas`,
`detalle_ventas`, `detalle_compras`), tal como indica la guía de normalización.

## 3. Normalización hasta 3FN

- **1FN — Atomicidad.** La columna `categorias` del modelo inicial contenía
  varios valores por celda (`"Panes, Artesanal"`). Solución: se separó en las
  tablas `productos` y `categorias` con la FK `productos.id_categoria`.
- **2FN — Dependencias parciales.** `DetalleVenta` tenía `nombreProducto`, que
  dependía solo de `idProducto` y no de la clave completa. Solución: `nombre`
  vive únicamente en `productos`.
- **3FN — Dependencias transitivas.** `Venta` repetía `nombreCliente` y
  `telefonoCliente`, que dependen de `idCliente` y no de `idVenta`.
  Solución: los datos del cliente están en su propia tabla `clientes`.

Resultado: 12 entidades sin redundancias, con claves primarias y foráneas que
garantizan la integridad referencial.

## 4. Mapeo al esquema implementado (`sql/schema.sql`)

| Entidad del modelo | Tabla implementada | Observación |
|---|---|---|
| Cliente | `clientes` | Ampliada con `email`, `direccion`, `puntos` |
| Venta | `ventas` | Añadido `metodo_pago`; conserva `id_turno` (Conexión 1 del mapa de procesos) |
| DetalleVenta | `detalle_ventas` | PK propia `id_detalle` en lugar de clave compuesta |
| Producto | `productos` | Añadida FK `id_categoria`; conserva `stock_actual` y `stock_minimo` para las alertas |
| Categoria | `categorias` | — |
| Insumo | `insumos` | — |
| Receta | `recetas` | — |
| Proveedor | `proveedores` | — |
| Compra | `compras` | — |
| DetalleCompra | `detalle_compras` | — |
| Empleado | `empleados` | — |
| Usuario | `empleados` (columnas `usuario`, `password_hash`, `rol`) | Ver nota siguiente |
| — (propio del proyecto) | `turnos` | Conexión 1 del mapa de procesos |
| — (propio del proyecto) | `movimientos_inventario` | Flujo 2: control de inventario |

### Nota de diseño: credenciales dentro de `empleados`

El MER documenta `Usuario` como tabla aparte con relación 1:1 respecto a
`Empleado`. En la implementación se optó por **fusionar** esas columnas en
`empleados` (`usuario`, `password_hash`, `rol`) por dos razones:

1. Toda la aplicación resuelve la sesión a partir de `id_empleado`
   (`includes/auth.php`, `actions/login_action.php`, `actions/venta_action.php`).
   Separar las tablas exigiría un JOIN en cada punto de entrada.
2. El sistema solo tiene dos roles (`dueño`, `empleada`) y un usuario por
   empleado, por lo que la tabla intermedia no aportaba cardinalidad real.

Es una desviación consciente y deliberada respecto al MER, no un descuido.

## 5. Script NoSQL equivalente

La misma estructura de 12 entidades existe en MongoDB dentro de `sql/query.sql`
(evidencia GA6-220501096-AA1-EV03, 12 colecciones). MySQL es el motor usado por
la aplicación; el script de MongoDB queda como material de estudio.
