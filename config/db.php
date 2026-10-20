<?php
/**
 * Conexión centralizada a la base de datos.
 * Credenciales via variables de entorno; fallback solo para desarrollo local.
 */

ini_set('display_errors', '0');
ini_set('log_errors', '1');
error_reporting(E_ALL);

define('DB_HOST', getenv('DB_HOST') ?: 'localhost');
define('DB_USER', getenv('DB_USER') ?: 'root');
define('DB_PASS', getenv('DB_PASS') ?: '');
define('DB_NAME', getenv('DB_NAME') ?: 'don_pan');

// La zona horaria debe coincidir con la del servidor MySQL (hora local de
// America/Bogota). Sin esto, PHP y MySQL pueden diferir por horas y los
// reportes por fecha mostrarian el dia equivocado.
date_default_timezone_set(getenv('APP_TIMEZONE') ?: 'America/Bogota');

function getConnection(): mysqli
{
    static $conn = null;

    if ($conn === null) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        $conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        $conn->set_charset('utf8mb4');
    }

    return $conn;
}