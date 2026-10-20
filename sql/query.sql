// ============================================================
// BASE DE DATOS: DON PAN
// SISTEMA DE GESTIÓN PARA PANADERÍA
// ============================================================


// ============================================================
// 0. SELECCIONAR BASE DE DATOS
// ============================================================

use don_pan


// ============================================================
// 1. LIMPIAR COLECCIONES ANTERIORES
// ============================================================
// Esto permite ejecutar el script varias veces sin duplicar datos.
// ¡ATENCIÓN! Borra todos los datos existentes de estas colecciones.
// ============================================================

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


// ============================================================
// 2. CREAR COLECCIONES
// ============================================================

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


// ============================================================
// 3. INSERTAR DATOS
// ============================================================


// ============================================================
// 3.1 CLIENTES
// ============================================================

db.clientes.insertMany([
    {
        _id: 1,
        nombre: "Ana Pérez",
        telefono: "3124567890",
        email: "ana@gmail.com",
        direccion: "Calle 123 #45-67",
        puntos: 150
    },
    {
        _id: 2,
        nombre: "Luis Gómez",
        telefono: "3109876543",
        email: "luis@hotmail.com",
        direccion: "Carrera 45 #67-89",
        puntos: 80
    },
    {
        _id: 3,
        nombre: "María Rodríguez",
        telefono: "3151234567",
        email: "maria@yahoo.com",
        direccion: "Avenida 10 #20-30",
        puntos: 200
    },
    {
        _id: 4,
        nombre: "Carlos Martínez",
        telefono: "3005556677",
        email: "carlos@gmail.com",
        direccion: "Calle 80 #12-45",
        puntos: 50
    },
    {
        _id: 5,
        nombre: "Laura Sánchez",
        telefono: "3012223344",
        email: "laura@hotmail.com",
        direccion: "Carrera 15 #30-25",
        puntos: 320
    }
])


// ============================================================
// 3.2 CATEGORÍAS
// ============================================================

db.categorias.insertMany([
    {
        _id: 1,
        nombre: "Panes",
        descripcion: "Panes artesanales y tradicionales"
    },
    {
        _id: 2,
        nombre: "Pastelería",
        descripcion: "Pasteles, tortas y postres"
    },
    {
        _id: 3,
        nombre: "Galletas",
        descripcion: "Galletas dulces y saladas"
    },
    {
        _id: 4,
        nombre: "Bebidas",
        descripcion: "Café, jugos y bebidas calientes"
    }
])


// ============================================================
// 3.3 PRODUCTOS
// ============================================================

db.productos.insertMany([
    {
        _id: 1,
        nombre: "Pan Francés",
        precio: 3500,
        stock: 50,
        idCategoria: 1,
        activo: true
    },
    {
        _id: 2,
        nombre: "Pastel de Fresa",
        precio: 35000,
        stock: 10,
        idCategoria: 2,
        activo: true
    },
    {
        _id: 3,
        nombre: "Galletas de Avena",
        precio: 2000,
        stock: 30,
        idCategoria: 3,
        activo: true
    },
    {
        _id: 4,
        nombre: "Café Americano",
        precio: 4500,
        stock: 100,
        idCategoria: 4,
        activo: true
    },
    {
        _id: 5,
        nombre: "Pan de Chocolate",
        precio: 5000,
        stock: 25,
        idCategoria: 1,
        activo: true
    },
    {
        _id: 6,
        nombre: "Croissant",
        precio: 4500,
        stock: 20,
        idCategoria: 1,
        activo: true
    },
    {
        _id: 7,
        nombre: "Torta de Chocolate",
        precio: 40000,
        stock: 8,
        idCategoria: 2,
        activo: true
    },
    {
        _id: 8,
        nombre: "Galletas de Chocolate",
        precio: 2500,
        stock: 40,
        idCategoria: 3,
        activo: true
    }
])


// ============================================================
// 3.4 INSUMOS
// ============================================================

db.insumos.insertMany([
    {
        _id: 1,
        nombre: "Harina de trigo",
        unidad: "kg",
        stockMinimo: 20,
        stockActual: 50,
        costoUnitario: 2000
    },
    {
        _id: 2,
        nombre: "Huevos",
        unidad: "unidades",
        stockMinimo: 50,
        stockActual: 120,
        costoUnitario: 1000
    },
    {
        _id: 3,
        nombre: "Levadura",
        unidad: "g",
        stockMinimo: 500,
        stockActual: 1000,
        costoUnitario: 10
    },
    {
        _id: 4,
        nombre: "Azúcar",
        unidad: "kg",
        stockMinimo: 15,
        stockActual: 40,
        costoUnitario: 2500
    },
    {
        _id: 5,
        nombre: "Mantequilla",
        unidad: "kg",
        stockMinimo: 10,
        stockActual: 25,
        costoUnitario: 8000
    },
    {
        _id: 6,
        nombre: "Chocolate",
        unidad: "kg",
        stockMinimo: 8,
        stockActual: 20,
        costoUnitario: 12000
    },
    {
        _id: 7,
        nombre: "Fresas",
        unidad: "kg",
        stockMinimo: 5,
        stockActual: 12,
        costoUnitario: 9000
    },
    {
        _id: 8,
        nombre: "Café",
        unidad: "kg",
        stockMinimo: 5,
        stockActual: 15,
        costoUnitario: 18000
    }
])


// ============================================================
// 3.5 PROVEEDORES
// ============================================================

db.proveedores.insertMany([
    {
        _id: 1,
        nombre: "Harinas del Valle",
        contacto: "Carlos Pérez",
        telefono: "3201234567",
        email: "carlos@harinasdelvalle.com",
        activo: true
    },
    {
        _id: 2,
        nombre: "Lácteos La Granja",
        contacto: "Ana Martínez",
        telefono: "3107654321",
        email: "ana@lacteoslagranja.com",
        activo: true
    },
    {
        _id: 3,
        nombre: "Distribuidora El Trigal",
        contacto: "Pedro López",
        telefono: "3114567890",
        email: "pedro@eltrigal.com",
        activo: true
    },
    {
        _id: 4,
        nombre: "Café Colombiano S.A.S.",
        contacto: "Jorge Ramírez",
        telefono: "3137894561",
        email: "ventas@cafecolombiano.com",
        activo: true
    }
])


// ============================================================
// 3.6 EMPLEADOS
// ============================================================

db.empleados.insertMany([
    {
        _id: 1,
        nombre: "Juan Pérez",
        cargo: "Panadero",
        telefono: "3001112233",
        salario: 1500000,
        activo: true
    },
    {
        _id: 2,
        nombre: "Ana Gómez",
        cargo: "Cajera",
        telefono: "3001122344",
        salario: 1200000,
        activo: true
    },
    {
        _id: 3,
        nombre: "Pedro Rodríguez",
        cargo: "Administrador",
        telefono: "3002233445",
        salario: 2500000,
        activo: true
    },
    {
        _id: 4,
        nombre: "Sofía Martínez",
        cargo: "Panadera",
        telefono: "3003344556",
        salario: 1500000,
        activo: true
    }
])


// ============================================================
// 3.7 RECETAS
// ============================================================
// Relaciona productos con los insumos necesarios.
// ============================================================

db.recetas.insertMany([
    // Pan Francés
    {
        _id: 1,
        idProducto: 1,
        idInsumo: 1,
        cantidad: 0.2,
        unidad: "kg"
    },
    {
        _id: 2,
        idProducto: 1,
        idInsumo: 3,
        cantidad: 10,
        unidad: "g"
    },
    {
        _id: 3,
        idProducto: 1,
        idInsumo: 4,
        cantidad: 0.02,
        unidad: "kg"
    },

    // Pastel de Fresa
    {
        _id: 4,
        idProducto: 2,
        idInsumo: 1,
        cantidad: 0.5,
        unidad: "kg"
    },
    {
        _id: 5,
        idProducto: 2,
        idInsumo: 2,
        cantidad: 6,
        unidad: "unidades"
    },
    {
        _id: 6,
        idProducto: 2,
        idInsumo: 7,
        cantidad: 0.5,
        unidad: "kg"
    },

    // Galletas de Avena
    {
        _id: 7,
        idProducto: 3,
        idInsumo: 1,
        cantidad: 0.1,
        unidad: "kg"
    },
    {
        _id: 8,
        idProducto: 3,
        idInsumo: 2,
        cantidad: 1,
        unidad: "unidades"
    },
    {
        _id: 9,
        idProducto: 3,
        idInsumo: 4,
        cantidad: 0.05,
        unidad: "kg"
    },

    // Pan de Chocolate
    {
        _id: 10,
        idProducto: 5,
        idInsumo: 1,
        cantidad: 0.2,
        unidad: "kg"
    },
    {
        _id: 11,
        idProducto: 5,
        idInsumo: 6,
        cantidad: 0.05,
        unidad: "kg"
    },

    // Croissant
    {
        _id: 12,
        idProducto: 6,
        idInsumo: 1,
        cantidad: 0.15,
        unidad: "kg"
    },
    {
        _id: 13,
        idProducto: 6,
        idInsumo: 5,
        cantidad: 0.05,
        unidad: "kg"
    }
])


// ============================================================
// 3.8 VENTAS
// ============================================================

db.ventas.insertMany([
    {
        _id: 1,
        idCliente: 1,
        idEmpleado: 2,
        fecha: new Date("2026-08-01"),
        total: 7000,
        metodoPago: "Efectivo"
    },
    {
        _id: 2,
        idCliente: 2,
        idEmpleado: 2,
        fecha: new Date("2026-08-02"),
        total: 35000,
        metodoPago: "Tarjeta"
    },
    {
        _id: 3,
        idCliente: 3,
        idEmpleado: 2,
        fecha: new Date("2026-08-03"),
        total: 4000,
        metodoPago: "Nequi"
    },
    {
        _id: 4,
        idCliente: 1,
        idEmpleado: 2,
        fecha: new Date("2026-08-04"),
        total: 13500,
        metodoPago: "Efectivo"
    },
    {
        _id: 5,
        idCliente: 5,
        idEmpleado: 2,
        fecha: new Date("2026-08-05"),
        total: 45000,
        metodoPago: "Tarjeta"
    },
    {
        _id: 6,
        idCliente: 4,
        idEmpleado: 2,
        fecha: new Date("2026-08-06"),
        total: 8000,
        metodoPago: "Nequi"
    },
    {
        _id: 7,
        idCliente: 3,
        idEmpleado: 2,
        fecha: new Date("2026-08-07"),
        total: 50000,
        metodoPago: "Tarjeta"
    },
    {
        _id: 8,
        idCliente: 5,
        idEmpleado: 2,
        fecha: new Date("2026-08-08"),
        total: 9000,
        metodoPago: "Efectivo"
    }
])


// ============================================================
// 3.9 DETALLES DE VENTA
// ============================================================

db.detallesVenta.insertMany([
    {
        _id: 1,
        idVenta: 1,
        idProducto: 1,
        cantidad: 2,
        precioUnitario: 3500,
        subtotal: 7000
    },
    {
        _id: 2,
        idVenta: 2,
        idProducto: 2,
        cantidad: 1,
        precioUnitario: 35000,
        subtotal: 35000
    },
    {
        _id: 3,
        idVenta: 3,
        idProducto: 3,
        cantidad: 2,
        precioUnitario: 2000,
        subtotal: 4000
    },
    {
        _id: 4,
        idVenta: 4,
        idProducto: 1,
        cantidad: 1,
        precioUnitario: 3500,
        subtotal: 3500
    },
    {
        _id: 5,
        idVenta: 4,
        idProducto: 4,
        cantidad: 1,
        precioUnitario: 4500,
        subtotal: 4500
    },
    {
        _id: 6,
        idVenta: 4,
        idProducto: 3,
        cantidad: 1,
        precioUnitario: 2000,
        subtotal: 2000
    },
    {
        _id: 7,
        idVenta: 5,
        idProducto: 5,
        cantidad: 1,
        precioUnitario: 5000,
        subtotal: 5000
    },
    {
        _id: 8,
        idVenta: 5,
        idProducto: 6,
        cantidad: 2,
        precioUnitario: 4500,
        subtotal: 9000
    },
    {
        _id: 9,
        idVenta: 5,
        idProducto: 2,
        cantidad: 1,
        precioUnitario: 35000,
        subtotal: 35000
    },
    {
        _id: 10,
        idVenta: 6,
        idProducto: 8,
        cantidad: 2,
        precioUnitario: 2500,
        subtotal: 5000
    },
    {
        _id: 11,
        idVenta: 6,
        idProducto: 1,
        cantidad: 1,
        precioUnitario: 3500,
        subtotal: 3500
    },
    {
        _id: 12,
        idVenta: 7,
        idProducto: 7,
        cantidad: 1,
        precioUnitario: 40000,
        subtotal: 40000
    },
    {
        _id: 13,
        idVenta: 7,
        idProducto: 4,
        cantidad: 1,
        precioUnitario: 4500,
        subtotal: 4500
    },
    {
        _id: 14,
        idVenta: 7,
        idProducto: 3,
        cantidad: 2,
        precioUnitario: 2000,
        subtotal: 4000
    },
    {
        _id: 15,
        idVenta: 8,
        idProducto: 4,
        cantidad: 2,
        precioUnitario: 4500,
        subtotal: 9000
    }
])


// ============================================================
// 3.10 COMPRAS
// ============================================================

db.compras.insertMany([
    {
        _id: 1,
        idProveedor: 1,
        idEmpleado: 1,
        fecha: new Date("2026-07-28"),
        total: 150000,
        metodoPago: "Transferencia"
    },
    {
        _id: 2,
        idProveedor: 2,
        idEmpleado: 3,
        fecha: new Date("2026-07-29"),
        total: 120000,
        metodoPago: "Efectivo"
    },
    {
        _id: 3,
        idProveedor: 3,
        idEmpleado: 1,
        fecha: new Date("2026-07-30"),
        total: 95000,
        metodoPago: "Transferencia"
    },
    {
        _id: 4,
        idProveedor: 4,
        idEmpleado: 3,
        fecha: new Date("2026-07-31"),
        total: 180000,
        metodoPago: "Transferencia"
    }
])


// ============================================================
// 3.11 DETALLES DE COMPRA
// ============================================================

db.detallesCompra.insertMany([
    {
        _id: 1,
        idCompra: 1,
        idInsumo: 1,
        cantidad: 50,
        precioUnitario: 2000,
        subtotal: 100000
    },
    {
        _id: 2,
        idCompra: 1,
        idInsumo: 3,
        cantidad: 5000,
        precioUnitario: 10,
        subtotal: 50000
    },
    {
        _id: 3,
        idCompra: 2,
        idInsumo: 2,
        cantidad: 120,
        precioUnitario: 1000,
        subtotal: 120000
    },
    {
        _id: 4,
        idCompra: 3,
        idInsumo: 4,
        cantidad: 30,
        precioUnitario: 2500,
        subtotal: 75000
    },
    {
        _id: 5,
        idCompra: 3,
        idInsumo: 5,
        cantidad: 2.5,
        precioUnitario: 8000,
        subtotal: 20000
    },
    {
        _id: 6,
        idCompra: 4,
        idInsumo: 8,
        cantidad: 10,
        precioUnitario: 18000,
        subtotal: 180000
    }
])


// ============================================================
// 3.12 USUARIOS
// ============================================================

db.usuarios.insertMany([
    {
        _id: 1,
        username: "admin",
        password: "admin123",
        rol: "Administrador",
        idEmpleado: 3,
        activo: true
    },
    {
        _id: 2,
        username: "cajera",
        password: "cajera123",
        rol: "Cajero",
        idEmpleado: 2,
        activo: true
    },
    {
        _id: 3,
        username: "panadero",
        password: "panadero123",
        rol: "Panadero",
        idEmpleado: 1,
        activo: true
    }
])


// ============================================================
// 4. CONSULTAS BÁSICAS
// ============================================================


// 1. Mostrar todos los clientes

db.clientes.find()


// 2. Mostrar todos los productos

db.productos.find()


// 3. Mostrar todos los empleados

db.empleados.find()


// 4. Mostrar todos los proveedores

db.proveedores.find()


// 5. Clientes con más de 100 puntos

db.clientes.find({
    puntos: {
        $gt: 100
    }
})


// 6. Clientes con menos de 100 puntos

db.clientes.find({
    puntos: {
        $lt: 100
    }
})


// 7. Productos con precio menor a 5000

db.productos.find({
    precio: {
        $lt: 5000
    }
})


// 8. Productos con precio mayor o igual a 10000

db.productos.find({
    precio: {
        $gte: 10000
    }
})


// 9. Productos con stock menor a 20

db.productos.find({
    stock: {
        $lt: 20
    }
})


// 10. Productos de la categoría Panes

db.productos.find({
    idCategoria: 1
})


// 11. Productos activos

db.productos.find({
    activo: true
})


// 12. Clientes que tienen teléfono o email

db.clientes.find({
    $or: [
        {
            telefono: {
                $exists: true
            }
        },
        {
            email: {
                $exists: true
            }
        }
    ]
})


// 13. Clientes con más de 100 puntos y email Gmail

db.clientes.find({
    puntos: {
        $gt: 100
    },
    email: {
        $regex: "@gmail.com$",
        $options: "i"
    }
})


// 14. Productos entre $2.000 y $10.000

db.productos.find({
    precio: {
        $gte: 2000,
        $lte: 10000
    }
})


// ============================================================
// 5. PROYECCIONES
// ============================================================


// 15. Mostrar solo nombre y precio de productos

db.productos.find(
    {},
    {
        nombre: 1,
        precio: 1
    }
)


// 16. Mostrar nombre y teléfono de clientes sin _id

db.clientes.find(
    {},
    {
        nombre: 1,
        telefono: 1,
        _id: 0
    }
)


// 17. Mostrar nombre y salario de empleados

db.empleados.find(
    {},
    {
        nombre: 1,
        salario: 1,
        _id: 0
    }
)


// ============================================================
// 6. ORDENAMIENTO
// ============================================================


// 18. Productos por precio ascendente

db.productos.find().sort({
    precio: 1
})


// 19. Productos por precio descendente

db.productos.find().sort({
    precio: -1
})


// 20. Clientes por puntos de mayor a menor

db.clientes.find().sort({
    puntos: -1
})


// 21. Empleados por salario de mayor a menor

db.empleados.find().sort({
    salario: -1
})


// ============================================================
// 7. LIMIT
// ============================================================


// 22. Los 3 productos más baratos

db.productos.find()
    .sort({
        precio: 1
    })
    .limit(3)


// 23. Los 5 clientes con más puntos

db.clientes.find()
    .sort({
        puntos: -1
    })
    .limit(5)


// 24. Los 3 productos con menor stock

db.productos.find()
    .sort({
        stock: 1
    })
    .limit(3)


// ============================================================
// 8. CONTADORES
// ============================================================


// 25. Cantidad de clientes

db.clientes.countDocuments()


// 26. Cantidad de productos

db.productos.countDocuments()


// 27. Cantidad de empleados

db.empleados.countDocuments()


// 28. Cantidad de ventas

db.ventas.countDocuments()


// 29. Cantidad de proveedores

db.proveedores.countDocuments()


// ============================================================
// 9. AGGREGATE - CATEGORÍAS
// ============================================================


// 30. Contar productos por categoría

db.productos.aggregate([
    {
        $group: {
            _id: "$idCategoria",
            totalProductos: {
                $sum: 1
            }
        }
    }
])


// 31. Precio promedio de productos

db.productos.aggregate([
    {
        $group: {
            _id: null,
            precioPromedio: {
                $avg: "$precio"
            }
        }
    }
])


// 32. Precio máximo

db.productos.aggregate([
    {
        $group: {
            _id: null,
            precioMaximo: {
                $max: "$precio"
            }
        }
    }
])


// 33. Precio mínimo

db.productos.aggregate([
    {
        $group: {
            _id: null,
            precioMinimo: {
                $min: "$precio"
            }
        }
    }
])


// 34. Stock total de productos

db.productos.aggregate([
    {
        $group: {
            _id: null,
            stockTotal: {
                $sum: "$stock"
            }
        }
    }
])


// ============================================================
// 10. AGGREGATE - VENTAS
// ============================================================


// 35. Total de ventas

db.ventas.aggregate([
    {
        $group: {
            _id: null,
            totalVendido: {
                $sum: "$total"
            }
        }
    }
])


// 36. Total de ventas por método de pago

db.ventas.aggregate([
    {
        $group: {
            _id: "$metodoPago",
            cantidadVentas: {
                $sum: 1
            },
            totalVendido: {
                $sum: "$total"
            }
        }
    }
])


// 37. Ventas ordenadas por total

db.ventas.aggregate([
    {
        $sort: {
            total: -1
        }
    }
])


// 38. Promedio de venta

db.ventas.aggregate([
    {
        $group: {
            _id: null,
            promedioVenta: {
                $avg: "$total"
            }
        }
    }
])


// 39. Venta más alta

db.ventas.aggregate([
    {
        $group: {
            _id: null,
            ventaMaxima: {
                $max: "$total"
            }
        }
    }
])


// 40. Total comprado por cada cliente

db.ventas.aggregate([
    {
        $group: {
            _id: "$idCliente",
            cantidadVentas: {
                $sum: 1
            },
            totalComprado: {
                $sum: "$total"
            }
        }
    },
    {
        $sort: {
            totalComprado: -1
        }
    }
])


// ============================================================
// 11. LOOKUP
// ============================================================


// 41. Productos con nombre de categoría

db.productos.aggregate([
    {
        $lookup: {
            from: "categorias",
            localField: "idCategoria",
            foreignField: "_id",
            as: "categoria"
        }
    },
    {
        $unwind: "$categoria"
    },
    {
        $project: {
            _id: 1,
            nombre: 1,
            precio: 1,
            stock: 1,
            categoria: "$categoria.nombre"
        }
    }
])


// 42. Ventas con información del cliente

db.ventas.aggregate([
    {
        $lookup: {
            from: "clientes",
            localField: "idCliente",
            foreignField: "_id",
            as: "cliente"
        }
    },
    {
        $unwind: "$cliente"
    },
    {
        $project: {
            _id: 1,
            fecha: 1,
            total: 1,
            metodoPago: 1,
            cliente: "$cliente.nombre"
        }
    }
])


// 43. Ventas con cliente y empleado

db.ventas.aggregate([
    {
        $lookup: {
            from: "clientes",
            localField: "idCliente",
            foreignField: "_id",
            as: "cliente"
        }
    },
    {
        $lookup: {
            from: "empleados",
            localField: "idEmpleado",
            foreignField: "_id",
            as: "empleado"
        }
    },
    {
        $unwind: "$cliente"
    },
    {
        $unwind: "$empleado"
    },
    {
        $project: {
            fecha: 1,
            total: 1,
            metodoPago: 1,
            cliente: "$cliente.nombre",
            empleado: "$empleado.nombre"
        }
    }
])


// 44. Detalles de venta con nombre del producto

db.detallesVenta.aggregate([
    {
        $lookup: {
            from: "productos",
            localField: "idProducto",
            foreignField: "_id",
            as: "producto"
        }
    },
    {
        $unwind: "$producto"
    },
    {
        $project: {
            idVenta: 1,
            cantidad: 1,
            precioUnitario: 1,
            subtotal: 1,
            producto: "$producto.nombre"
        }
    }
])


// 45. Compras con información del proveedor

db.compras.aggregate([
    {
        $lookup: {
            from: "proveedores",
            localField: "idProveedor",
            foreignField: "_id",
            as: "proveedor"
        }
    },
    {
        $unwind: "$proveedor"
    },
    {
        $project: {
            fecha: 1,
            total: 1,
            metodoPago: 1,
            proveedor: "$proveedor.nombre"
        }
    }
])


// ============================================================
// 12. PRODUCTOS MÁS VENDIDOS
// ============================================================


// 46. Cantidad vendida por producto

db.detallesVenta.aggregate([
    {
        $group: {
            _id: "$idProducto",
            cantidadVendida: {
                $sum: "$cantidad"
            },
            ingresos: {
                $sum: "$subtotal"
            }
        }
    },
    {
        $sort: {
            cantidadVendida: -1
        }
    }
])


// 47. Producto más vendido

db.detallesVenta.aggregate([
    {
        $group: {
            _id: "$idProducto",
            cantidadVendida: {
                $sum: "$cantidad"
            }
        }
    },
    {
        $sort: {
            cantidadVendida: -1
        }
    },
    {
        $limit: 1
    },
    {
        $lookup: {
            from: "productos",
            localField: "_id",
            foreignField: "_id",
            as: "producto"
        }
    },
    {
        $unwind: "$producto"
    },
    {
        $project: {
            producto: "$producto.nombre",
            cantidadVendida: 1
        }
    }
])


// ============================================================
// 13. INVENTARIO
// ============================================================


// 48. Valor del inventario por producto

db.productos.aggregate([
    {
        $project: {
            nombre: 1,
            precio: 1,
            stock: 1,
            valorInventario: {
                $multiply: [
                    "$precio",
                    "$stock"
                ]
            }
        }
    }
])


// 49. Valor total del inventario

db.productos.aggregate([
    {
        $group: {
            _id: null,
            valorTotalInventario: {
                $sum: {
                    $multiply: [
                        "$precio",
                        "$stock"
                    ]
                }
            }
        }
    }
])


// 50. Productos con stock bajo

db.productos.find({
    stock: {
        $lt: 20
    }
})


// 51. Insumos por debajo del stock mínimo

db.insumos.find({
    $expr: {
        $lt: [
            "$stockActual",
            "$stockMinimo"
        ]
    }
])


// ============================================================
// 14. RECETAS
// ============================================================


// 52. Mostrar recetas

db.recetas.find()


// 53. Recetas con producto e insumo

db.recetas.aggregate([
    {
        $lookup: {
            from: "productos",
            localField: "idProducto",
            foreignField: "_id",
            as: "producto"
        }
    },
    {
        $lookup: {
            from: "insumos",
            localField: "idInsumo",
            foreignField: "_id",
            as: "insumo"
        }
    },
    {
        $unwind: "$producto"
    },
    {
        $unwind: "$insumo"
    },
    {
        $project: {
            producto: "$producto.nombre",
            insumo: "$insumo.nombre",
            cantidad: 1,
            unidad: 1
        }
    }
])


// ============================================================
// 15. COMPRAS
// ============================================================


// 54. Total gastado en compras

db.compras.aggregate([
    {
        $group: {
            _id: null,
            totalCompras: {
                $sum: "$total"
            }
        }
    }
])


// 55. Compras por método de pago

db.compras.aggregate([
    {
        $group: {
            _id: "$metodoPago",
            cantidadCompras: {
                $sum: 1
            },
            totalGastado: {
                $sum: "$total"
            }
        }
    }
])


// 56. Compra más costosa

db.compras.aggregate([
    {
        $group: {
            _id: null,
            compraMaxima: {
                $max: "$total"
            }
        }
    }
])


// ============================================================
// 16. ACTUALIZACIONES
// ============================================================


// 57. Aumentar puntos de un cliente

db.clientes.updateOne(
    {
        _id: 1
    },
    {
        $inc: {
            puntos: 50
        }
    }
)


// 58. Actualizar teléfono

db.clientes.updateOne(
    {
        _id: 1
    },
    {
        $set: {
            telefono: "3005556677"
        }
    }
)


// 59. Actualizar precio de un producto

db.productos.updateOne(
    {
        _id: 1
    },
    {
        $set: {
            precio: 4000
        }
    }
)


// 60. Aumentar stock de un producto

db.productos.updateOne(
    {
        _id: 1
    },
    {
        $inc: {
            stock: 20
        }
    }
)


// 61. Actualizar salario de un empleado

db.empleados.updateOne(
    {
        _id: 1
    },
    {
        $set: {
            salario: 1600000
        }
    }
)


// 62. Desactivar usuario

db.usuarios.updateOne(
    {
        _id: 3
    },
    {
        $set: {
            activo: false
        }
    }
)


// ============================================================
// 17. ELIMINACIONES
// ============================================================


// 63. Eliminar un usuario específico

// db.usuarios.deleteOne({
//     _id: 3
// })


// 64. Eliminar productos inactivos

// db.productos.deleteMany({
//     activo: false
// })


// ============================================================
// 18. ÍNDICES
// ============================================================


// 65. Índice para buscar clientes por email

db.clientes.createIndex({
    email: 1
})


// 66. Índice para buscar productos por nombre

db.productos.createIndex({
    nombre: 1
})


// 67. Índice para ventas por fecha

db.ventas.createIndex({
    fecha: -1
})


// 68. Índice para ventas por cliente

db.ventas.createIndex({
    idCliente: 1
})


// 69. Índice para productos por categoría

db.productos.createIndex({
    idCategoria: 1
})


// 70. Índice único para username

db.usuarios.createIndex(
    {
        username: 1
    },
    {
        unique: true
    }
)


// ============================================================
// 19. VER ÍNDICES
// ============================================================

db.clientes.getIndexes()

db.productos.getIndexes()

db.ventas.getIndexes()

db.usuarios.getIndexes()


// ============================================================
// 20. CONSULTAS ADICIONALES
// ============================================================


// 71. Buscar cliente por nombre usando regex

db.clientes.find({
    nombre: {
        $regex: "Ana",
        $options: "i"
    }
})


// 72. Buscar productos que contengan "Pan"

db.productos.find({
    nombre: {
        $regex: "Pan",
        $options: "i"
    }
})


// 73. Empleados que ganan más de $1.400.000

db.empleados.find({
    salario: {
        $gt: 1400000
    }
})


// 74. Proveedores activos

db.proveedores.find({
    activo: true
})


// 75. Usuarios activos

db.usuarios.find({
    activo: true
})


// 76. Ventas realizadas después del 3 de agosto

db.ventas.find({
    fecha: {
        $gt: new Date("2026-08-03")
    }
})


// 77. Ventas entre dos fechas

db.ventas.find({
    fecha: {
        $gte: new Date("2026-08-01"),
        $lte: new Date("2026-08-08")
    }
})


// ============================================================
// 21. REPORTE GENERAL DE PRODUCTOS
// ============================================================


// 78. Producto + categoría + precio + stock

db.productos.aggregate([
    {
        $lookup: {
            from: "categorias",
            localField: "idCategoria",
            foreignField: "_id",
            as: "categoria"
        }
    },
    {
        $unwind: "$categoria"
    },
    {
        $project: {
            _id: 1,
            producto: "$nombre",
            categoria: "$categoria.nombre",
            precio: 1,
            stock: 1,
            activo: 1
        }
    },
    {
        $sort: {
            categoria: 1,
            producto: 1
        }
    }
])


// ============================================================
// 22. REPORTE GENERAL DE VENTAS
// ============================================================


// 79. Cliente + fecha + productos + total

db.ventas.aggregate([
    {
        $lookup: {
            from: "clientes",
            localField: "idCliente",
            foreignField: "_id",
            as: "cliente"
        }
    },
    {
        $unwind: "$cliente"
    },
    {
        $lookup: {
            from: "detallesVenta",
            localField: "_id",
            foreignField: "idVenta",
            as: "detalles"
        }
    },
    {
        $project: {
            fecha: 1,
            cliente: "$cliente.nombre",
            metodoPago: 1,
            total: 1,
            detalles: 1
        }
    },
    {
        $sort: {
            fecha: 1
        }
    }
])


// ============================================================
// 23. REPORTE DE RENTABILIDAD BÁSICO
// ============================================================


// 80. Comparar ingresos de ventas contra gastos de compras

db.ventas.aggregate([
    {
        $group: {
            _id: null,
            ingresos: {
                $sum: "$total"
            }
        }
    },
    {
        $lookup: {
            from: "compras",
            pipeline: [
                {
                    $group: {
                        _id: null,
                        gastos: {
                            $sum: "$total"
                        }
                    }
                }
            ],
            as: "compras"
        }
    },
    {
        $unwind: "$compras"
    },
    {
        $project: {
            ingresos: 1,
            gastos: "$compras.gastos",
            diferencia: {
                $subtract: [
                    "$ingresos",
                    "$compras.gastos"
                ]
            }
        }
    }
])


// ============================================================
// 24. INFORMACIÓN DE LA BASE DE DATOS
// ============================================================


// Mostrar colecciones

show collections


// Mostrar bases de datos

show dbs


// Contar documentos de cada colección

db.clientes.countDocuments()

db.ventas.countDocuments()

db.detallesVenta.countDocuments()

db.productos.countDocuments()

db.categorias.countDocuments()

db.insumos.countDocuments()

db.recetas.countDocuments()

db.proveedores.countDocuments()

db.compras.countDocuments()

db.detallesCompra.countDocuments()

db.empleados.countDocuments()

db.usuarios.countDocuments()


// ============================================================
// 25. PRUEBA DE CONEXIÓN
// ============================================================

db.runCommand({
    ping: 1
})


// ============================================================
// FIN DEL SCRIPT
// ============================================================

print("============================================================")
print(" BASE DE DATOS DON_PAN CREADA CORRECTAMENTE")
print("============================================================")
print("Colecciones:")
print(" - clientes")
print(" - ventas")
print(" - detallesVenta")
print(" - productos")
print(" - categorias")
print(" - insumos")
print(" - recetas")
print(" - proveedores")
print(" - compras")
print(" - detallesCompra")
print(" - empleados")
print(" - usuarios")
print("============================================================")