# TODO - Arreglar lanzamiento del proyecto

- [x] 1. Analizar el proyecto y entorno
- [x] 2. Crear `public/index.php` con la vista de login
- [x] 3. Reemplazar el `index.php` raíz por redirección a `public/index.php`
- [x] 4. Crear la base de datos `don_pan` importando `sql/schema.sql`
- [x] 5. Insertar empleado inicial (`admin` / `1234`) y un turno
- [x] 6. Verificar que la página cargue y se pueda iniciar sesión

# TODO - Registrar productos y verificar descuento de stock

- [x] 1. Crear acción `producto_action.php` para registrar productos nuevos
- [x] 2. Añadir formulario "Registrar nuevo producto" en `public/inventario.php`
- [x] 3. Añadir estilos CSS para el nuevo formulario
- [x] 4. Verificar que `venta_action.php` descuente stock al vender

# TODO - Integración con las evidencias de la carpeta README/

- [x] 1. Documentar el MER y la normalización 3FN en `docs/modelo-relacional.md`
- [x] 2. Documentar la paleta y los componentes en `docs/componentes-front-end.md`
- [x] 3. Documentar herramientas y versionamiento en `docs/plan-de-trabajo.md`
- [x] 4. Agregar las 6 tablas del MER: `categorias`, `insumos`, `recetas`,
      `proveedores`, `compras`, `detalle_compras` (`sql/migracion_002.sql`)
- [x] 5. Agregar columnas pendientes: `productos.id_categoria`,
      `ventas.metodo_pago`, `clientes.email/direccion/puntos`
- [x] 6. Corregir el ENUM `empleados.rol`, que quedó corrupto y hacía que el
      dueño no pudiera ver Reportes (`sql/fix_utf8.sql`)
- [x] 7. Crear la pantalla de Clientes (Conexión 4, marcada como pendiente)
- [x] 8. Crear la pantalla de Productos con búsqueda y edición en línea
- [x] 9. Crear el Dashboard con tarjetas de resumen y accesos rápidos
- [x] 10. Aplicar la paleta documentada a `public/css/style.css`
- [x] 11. Añadir método de pago y cliente al registro de ventas
- [x] 12. Actualizar `README.md` con la estructura y las tablas reales

# Ideas pendientes (no forman parte de las evidencias)

- [ ] Pantalla de compras a proveedores (el esquema ya está listo, falta la UI)
- [ ] Pantalla de insumos y recetas (módulo de producción)
- [ ] Gráfico de barras de ventas por día en el Dashboard
- [ ] Migrar el catálogo HTML/CSS/JS de la evidencia AA4-EV01 a una vista real

# Mejoras de robustez (2026-09-30)

- [x] 1. Dejar de ignorar `/sql/` y `README.md` en `.gitignore`: sin el esquema
      versionado el repositorio no es reproducible
- [x] 2. Quitar `htaccess` del ignore (nunca coincidia con `.htaccess`)
- [x] 3. Anular ventas con devolucion de stock (`anular_venta_action.php`),
      protegido con `SELECT ... FOR UPDATE` y auditoria de quien anulo
- [x] 4. Pantalla de historial de ventas (`historial_ventas.php`)
- [x] 5. Excluir ventas anuladas de dashboard y reportes
- [x] 6. Selector de periodo en reportes (documento de diseno, seccion 3.7)
- [x] 7. Corregir la zona horaria: PHP usaba `Europe/Berlin` y MySQL la hora
      local, con 8 horas de diferencia que rompian los reportes por fecha
      (`date_default_timezone_set` en `config/db.php`)
# Modulo de produccion (2026-09-30)

- [x] 1. Pantalla de insumos con stock, alerta de reposicion e historial
- [x] 2. Pantalla de recetas (la tabla `recetas` estaba vacia y sin interfaz)
- [x] 3. Tabla `movimientos_insumos` para auditar entradas y salidas
- [x] 4. Anulacion de compras con devolucion de insumos y auditoria
- [x] 5. Indice unico en `recetas(id_producto, id_insumo)`
- [x] 6. Migracion `sql/migracion_005.sql`