<?php
/**
 * Conexión centralizada a MongoDB.
 * URI y nombre de base de datos via variables de entorno; fallback solo para desarrollo local.
 */

require_once __DIR__ . '/../vendor/autoload.php';

define('MONGO_URI', getenv('MONGO_URI') ?: 'mongodb://localhost:27017');
define('MONGO_DB_NAME', getenv('MONGO_DB_NAME') ?: 'don_pan');

/**
 * Devuelve una instancia única (singleton) del cliente de MongoDB.
 */
function getMongoClient(): MongoDB\Client
{
    static $client = null;

    if ($client === null) {
        $client = new MongoDB\Client(MONGO_URI);
    }

    return $client;
}

/**
 * Devuelve la base de datos configurada (don_pan por defecto).
 */
function getMongoDatabase(): MongoDB\Database
{
    return getMongoClient()->selectDatabase(MONGO_DB_NAME);
}
