<?php
/** Header + navegación reutilizable. Requiere que auth.php ya haya corrido antes. */
?>
<!DOCTYPE html>
<html lang="es-419">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= $pageTitle ?? 'Panadería Don Pan' ?></title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<header class="topbar">
    <div class="brand">
        <img src="img/logo.png" alt="Logo Panadería Don Pan">
        <span class="brand-text">Panadería <em>Don Pan</em></span>
    </div>
    <?php if (isLoggedIn()): ?>
        <nav>
            <a href="ventas.php">Ventas</a>
            <a href="inventario.php">Inventario</a>
            <?php if (isOwner()): ?>
                <a href="reportes.php">Reportes</a>
            <?php endif; ?>
            <a href="logout.php">Salir (<?= htmlspecialchars($_SESSION['nombre']) ?>)</a>
        </nav>
    <?php endif; ?>
</header>
<main class="container">
