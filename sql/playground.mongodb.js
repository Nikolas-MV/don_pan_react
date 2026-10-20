// ============================================================================
// PLAYGROUND DE MONGODB — EVIDENCIA "ELABORACIÓN DE LAS BASES DE DATOS"
// ============================================================================
// La extensión "MongoDB for VS Code" reconoce los archivos .mongodb.js como
// playgrounds. Este archivo contiene el código del PASO 2 del guion del video
// más un bloque 0 de limpieza para poder practicar sin duplicar datos.
//
// CÓMO USARLO:
//   1. Instalar la extensión "MongoDB for VS Code" en VS Code.
//   2. Tener MongoDB corriendo en localhost:27017 (Community Server).
//   3. Abrir este archivo → en el enlace "Click here to add connection" del
//      CodeLens superior escribir: mongodb://localhost:27017
//   4. Ejecutar bloque por bloque con el enlace "MongoDB: Run" del CodeLens,
//      o seleccionar varias líneas y usar "Run Selected Lines from Playground".
//   5. Los resultados aparecen en el panel derecho.
//   6. El bloque 0 limpia todo: se puede practicar cuantas veces se quiera.
// ============================================================================


// ============================================================================
// 0. SELECCIONAR BASE DE DATOS Y LIMPIAR EJECUCIONES ANTERIORES
// ============================================================================
// Equivale a la sección "LIMPIAR COLECCIONES ANTERIORES" del script grande
// (query.sql). Evita errores "NamespaceExists" y datos duplicados al practicar.
// ============================================================================

use("don_pan")

db.clientes.drop()
db.ventas.drop()
db.detallesVenta.drop()
db.productos.drop()
db.categorias.drop()
db.insumos.drop()
db.recetas.drop()
db.proveedores.drop()
db.compras.drop()
db.detallesCompra.drop()
db.empleados.drop()
db.usuarios.drop()


// ============================================================================
// 1. CREAR COLECCIONES (TABLAS)
// ============================================================================

db.createCollection("clientes")
db.createCollection("ventas")
db.createCollection("detallesVenta")
db.createCollection("productos")
db.createCollection("categorias")
db.createCollection("insumos")
db.createCollection("recetas")
db.createCollection("proveedores")
db.createCollection("compras")
db.createCollection("detallesCompra")
db.createCollection("empleados")
db.createCollection("usuarios")


// ============================================================================
// 2. INSERTAR DATOS
// ============================================================================

// 2.1 CLIENTES
db.clientes.insertOne({
    nombre: "Ana Pérez",
    telefono: "3124567890",
    email: "ana@gmail.com",
    direccion: "Calle 123 #45-67",
    puntos: 150
})

db.clientes.insertMany([
    { nombre: "Luis Gómez", telefono: "3109876543", email: "luis@hotmail.com", direccion: "Carrera 45 #67-89", puntos: 80 },
    { nombre: "María Rodríguez", telefono: "3151234567", email: "maria@yahoo.com", direccion: "Avenida 10 #20-30", puntos: 200 }
])

// 2.2 CATEGORIAS
db.categorias.insertMany([
    { nombre: "Panes", descripcion: "Panes artesanales y tradicionales" },
    { nombre: "Pastelería", descripcion: "Pasteles, tortas y postres" },
    { nombre: "Galletas", descripcion: "Galletas dulces y saladas" },
    { nombre: "Bebidas", descripcion: "Café, jugos y bebidas calientes" }
])

// 2.3 PRODUCTOS
db.productos.insertMany([
    { nombre: "Pan Francés", precio: 3500, stock: 50, idCategoria: 1 },
    { nombre: "Pastel de Fresa", precio: 35000, stock: 10, idCategoria: 2 },
    { nombre: "Galletas de Avena", precio: 2000, stock: 30, idCategoria: 3 }
])

// 2.4 INSUMOS
db.insumos.insertMany([
    { nombre: "Harina de trigo", unidad: "kg", stockMinimo: 20, stockActual: 50 },
    { nombre: "Huevos", unidad: "unidades", stockMinimo: 50, stockActual: 120 },
    { nombre: "Levadura", unidad: "g", stockMinimo: 500, stockActual: 1000 }
])

// 2.5 PROVEEDORES
db.proveedores.insertMany([
    { nombre: "Harinas del Valle", contacto: "Carlos Pérez", telefono: "3201234567", email: "carlos@harinasdelvalle.com" },
    { nombre: "Lácteos La Granja", contacto: "Ana Martínez", telefono: "3107654321", email: "ana@lacteoslagranja.com" }
])

// 2.6 EMPLEADOS
db.empleados.insertMany([
    { nombre: "Juan Pérez", cargo: "Panadero", telefono: "3001112233", salario: 1500000 },
    { nombre: "Ana Gómez", cargo: "Cajera", telefono: "3001122344", salario: 1200000 }
])


// ============================================================================
// 3. CONSULTAS
// ============================================================================

// 3.1 MOSTRAR TODOS LOS CLIENTES
db.clientes.find().pretty()

// 3.2 CLIENTES CON MÁS DE 100 PUNTOS
db.clientes.find({ puntos: { $gt: 100 } }).pretty()

// 3.3 PRODUCTOS CON PRECIO MENOR A 5000
db.productos.find({ precio: { $lt: 5000 } }).pretty()

// 3.4 PRODUCTOS CON STOCK BAJO (MENOS DE 20)
db.productos.find({ stock: { $lt: 20 } }).pretty()

// 3.5 PRODUCTOS DE LA CATEGORÍA 1 (PANES)
db.productos.find({ idCategoria: 1 }).pretty()

// 3.6 MOSTRAR SOLO NOMBRE Y PRECIO DE LOS PRODUCTOS
db.productos.find({}, { nombre: 1, precio: 1, _id: 0 })

// 3.7 ORDENAR PRODUCTOS POR PRECIO (ASCENDENTE)
db.productos.find().sort({ precio: 1 }).pretty()

// 3.8 ORDENAR PRODUCTOS POR PRECIO (DESCENDENTE)
db.productos.find().sort({ precio: -1 }).pretty()

// 3.9 CONTAR CUÁNTOS PRODUCTOS HAY EN CADA CATEGORÍA
db.productos.aggregate([
    { $group: { _id: "$idCategoria", total: { $sum: 1 } } }
])

// 3.10 CALCULAR EL PRECIO PROMEDIO DE LOS PRODUCTOS
db.productos.aggregate([
    { $group: { _id: null, promedio: { $avg: "$precio" } } }
])
