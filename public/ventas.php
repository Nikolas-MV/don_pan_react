<?php
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../config/db.php';
require_once __DIR__ . '/../includes/csrf.php';
requireLogin();

$conn = getConnection();
$productos = $conn->query('SELECT id_producto, nombre, precio, stock_actual FROM productos ORDER BY nombre');

$pageTitle = 'Ventas';
require __DIR__ . '/../includes/header.php';
?>

<h1>Registrar venta</h1>

<form action="../actions/venta_action.php" method="POST" id="form-venta">
    <?= csrfField() ?>
    <table class="tabla-venta">
        <thead>
            <tr>
                <th>Producto</th>
                <th>Precio</th>
                <th>Stock</th>
                <th>Cantidad</th>
            </tr>
        </thead>
        <tbody>
        <?php while ($p = $productos->fetch_assoc()): ?>
            <tr>
                <td><?= htmlspecialchars($p['nombre']) ?></td>
                <td>$<?= number_format($p['precio'], 2) ?></td>
                <td><?= $p['stock_actual'] ?></td>
                <td>
                    <input type="number" min="0" max="<?= $p['stock_actual'] ?>"
                           name="cantidad[<?= $p['id_producto'] ?>]" value="0">
                </td>
            </tr>
        <?php endwhile; ?>
        </tbody>
    </table>

    <button type="submit">Cobrar</button>
</form>

<?php require __DIR__ . '/../includes/footer.php'; ?>
