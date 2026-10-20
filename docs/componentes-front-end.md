# Componentes Front-End - Panadería Don Pan

Evidencias de referencia: `TRA-NK - Establecer los Componentes Front-end...docx`
(GA6-220501096-AA4-EV02) y `TRA-NK - Diseño Front-End - Panadería Don Pan.docx`
(GA6-220501096-AA4-EV03).

Este documento es la guía de estilo del sistema. Los valores están
implementados en `public/css/style.css`.

## 1. Paleta de colores

| Color | Código HEX | Uso |
|---|---|---|
| Marrón | `#8B4513` | Botones principales, menús, encabezados |
| Naranja | `#FF9800` | Botones de acción, enlaces, alertas |
| Crema | `#F5F0E1` | Fondo de pantalla |
| Blanco | `#FFFFFF` | Fondos de tarjetas, tablas |
| Rojo | `#D32F2F` | Botones de peligro, errores |
| Verde | `#4CAF50` | Éxitos, confirmaciones |

Implementadas como variables CSS en `:root`: `--color-pan`, `--color-naranja`,
`--color-crema`, `--color-texto`, `--color-alerta`, `--color-ok`.

## 2. Pantallas del sistema

| # | Pantalla | Propósito | Componentes | Archivo |
|---|---|---|---|---|
| 3.1 | Login | Autenticar al dueño y a los empleados | Campos de texto, botón principal, alertas | `public/index.php` |
| 3.2 | Dashboard | Resumen del negocio | Tarjetas de resumen, accesos rápidos | `public/dashboard.php` |
| 3.3 | Gestión de Productos | Ver, agregar y editar productos | Tabla de datos, campo de búsqueda, botón "Nuevo Producto" | `public/productos.php` |
| 3.4 | Registro de Ventas | Hacer una venta rápida | Campo de búsqueda, tabla de carrito, selector de método de pago, botones "Cobrar"/"Cancelar" | `public/ventas.php` |
| 3.4.b | Historial de Ventas | Corregir ventas ya registradas | Tabla de ventas, botón "Anular" con confirmación | `public/historial_ventas.php` |
| 3.5 | Gestión de Inventario | Ver stock y alertas | Alerta de stock bajo, tabla de inventario, botón "Ingresar" | `public/inventario.php` |
| 3.6 | Gestión de Clientes | Registrar y consultar clientes | Tabla de clientes, campo de búsqueda, botón "Nuevo Cliente" | `public/clientes.php` |
| 3.7 | Generación de Reportes | Ver estadísticas | Resumen numérico, productos más vendidos, alertas de stock | `public/reportes.php` |

## 3. Componentes

### 3.1 Estructurales

- **Contenedor principal** — ancho máximo, centrado, fondo crema.
- **Header** — barra superior marrón con el logo a la izquierda y los datos del
  usuario a la derecha (`includes/header.php`).
- **Footer** — barra inferior con información del negocio
  (`includes/footer.php`).

### 3.2 Navegación

- **Menú superior** con enlaces contextuales: Reportes solo para el rol `dueño`
  (`includes/header.php`).
- El menú se reorganiza solo en pantallas pequeñas mediante `flex-wrap`.

### 3.3 Formularios

- Campos de texto: ancho 100%, borde redondeado.
- Botones: principal (marrón), secundario (naranja), peligro (rojo).
- Checkbox `Recordarme` en la pantalla de login.

### 3.4 Tablas

- Ancho 100%, bordes colapsados.
- Encabezado con fondo marrón y texto blanco.
- Fila con stock bajo resaltada en rojo (`tr.fila-alerta`).

### 3.5 Tarjetas

- Fondo blanco, sombra suave, bordes redondeados, displayed en `flex`.
- Usadas en el Dashboard y en Reportes.

### 3.6 Alertas

| Tipo | Fondo | Color de texto | Clase CSS |
|---|---|---|---|
| Éxito | Verde claro | Verde oscuro | `.alert-ok` |
| Error | Rojo claro | Rojo oscuro | `.alert-error` |
| Advertencia | Amarillo claro | Naranja oscuro | `.alert-warn` |

## 4. Principios de usabilidad aplicados

| Principio | Aplicación en el diseño |
|---|---|
| Facilidad de aprendizaje | Navegación consistente, botones con textos claros |
| Eficiencia | Accesos rápidos desde el Dashboard, menos clics para acciones frecuentes |
| Memorabilidad | Colores consistentes, organización lógica de módulos |
| Prevención de errores | Alertas de confirmación, mensajes de error claros, token CSRF en todos los formularios |
| Satisfacción | Paleta cálida y coherente con la identidad de la panadería |

## 5. Nota sobre el catálogo HTML

La evidencia GA6-220501096-AA4-EV01 incluye un catálogo de productos en HTML,
CSS y JavaScript puro (tarjetas, carrito y notificaciones emergentes). Es un
ejercicio de HTML/CSS/JS independiente, con datos escritos a mano en el
archivo: **no** es parte de la aplicación y no se integró al sistema, que
muestra el stock real de la base de datos.