<?php
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../config/db.php';
requireOwner();

$conn = getConnection();

$ventasHoy = $conn->query(
    "SELECT COUNT(*) AS total_ventas, COALESCE(SUM(total),0) AS total_dinero
     FROM ventas WHERE DATE(fecha_hora) = CURDATE()"
)->fetch_assoc();

$topProductos = $conn->query(
    "SELECT p.nombre, SUM(dv.cantidad) AS unidades_vendidas
     FROM detalle_ventas dv
     JOIN productos p ON p.id_producto = dv.id_producto
     JOIN ventas v ON v.id_venta = dv.id_venta
     WHERE DATE(v.fecha_hora) = CURDATE()
     GROUP BY p.id_producto
     ORDER BY unidades_vendidas DESC
     LIMIT 5"
);

$stockBajo = $conn->query(
    'SELECT nombre, stock_actual, stock_minimo FROM productos WHERE stock_actual <= stock_minimo'
);

$pageTitle = 'Reportes';
require __DIR__ . '/../includes/header.php';
?>

<h1>Reportes en tiempo real</h1>

<section class="tarjetas">
    <div class="tarjeta">
        <h2><?= $ventasHoy['total_ventas'] ?></h2>
        <p>Ventas hoy</p>
    </div>
    <div class="tarjeta">
        <h2>$<?= number_format($ventasHoy['total_dinero'], 2) ?></h2>
        <p>Ingresos hoy</p>
    </div>
</section>

<h2>Productos más vendidos hoy</h2>
<ul>
    <?php while ($p = $topProductos->fetch_assoc()): ?>
        <li><?= htmlspecialchars($p['nombre']) ?> — <?= $p['unidades_vendidas'] ?> unidades</li>
    <?php endwhile; ?>
</ul>

<h2>⚠️ Alertas de stock bajo</h2>
<ul>
    <?php while ($p = $stockBajo->fetch_assoc()): ?>
        <li><?= htmlspecialchars($p['nombre']) ?>: <?= $p['stock_actual'] ?> / mínimo <?= $p['stock_minimo'] ?></li>
    <?php endwhile; ?>
</ul>

<?php require __DIR__ . '/../includes/footer.php'; ?>
