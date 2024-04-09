import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Si _database es null, inicializar la base de datos
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'salon_manicura.db');
      Database db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          // Crear tablas
          await _createTables(db);

          // Insertar datos iniciales
          await _insertInitialData(db);
        },
      );

      return db;
    } catch (e) {
      print('Error al inicializar la base de datos: $e');
      throw 'Error al inicializar la base de datos';
    }
  }

  Future<void> _createTables(Database db) async {
    // Crear tabla Venta
    await db.execute('''
      CREATE TABLE Venta (
        idVenta INTEGER PRIMARY KEY AUTOINCREMENT,
        empleadoId INTEGER,
        clienteId INTEGER,
        servicioId INTEGER,
       
        horaServicio TEXT,
        precio REAL,
        fechaVenta TEXT,
        estadoVenta INTEGER
      )
    ''');
    await db.execute('''
          CREATE TABLE DetalleVenta (
            idDetalle INTEGER PRIMARY KEY,
            ventaId INTEGER,
            insumoId TEXT,
            precioUnitario REAL,
            cantidadInsumo INTEGER
          )
        ''');

    // Crear tabla Servicio
    await db.execute('''
          CREATE TABLE Servicio (
            idServicio INTEGER PRIMARY KEY,
            nombreServicio TEXT,
            precioServicio REAL,
            tiempoServicio TEXT,
            imgServicio TEXT,
            estadoServicio INTEGER
          )
        ''');

    // Crear tabla Insumo
    await db.execute('''
          CREATE TABLE Insumo (
            idInsumo INTEGER PRIMARY KEY,
            nombreInsumo TEXT,
            imagenInsumo TEXT,
            cantidadInsumo INTEGER,
            usosDisponibles INTEGER,
            estadoInsumo INTEGER
          )
        ''');

    // Crear tabla InsumoXServicio
    await db.execute('''
          CREATE TABLE InsumoXServicio (
            idInsumoXServicio INTEGER PRIMARY KEY,
            servicioId INTEGER,
            cantidad INTEGER,
            insumoId INTEGER,
            FOREIGN KEY (servicioId) REFERENCES Servicio(idServicio),
            FOREIGN KEY (insumoId) REFERENCES Insumo(idInsumo)
          )
        ''');

    // Crear tabla Cliente
    await db.execute('''
          CREATE TABLE Cliente (
            idCliente INTEGER PRIMARY KEY,
            nombre TEXT,
            apellido TEXT,
            correo TEXT,
            telefono TEXT,
            contrasena TEXT,
            estado INTEGER
          )
        ''');

    // Crear tabla Empleado
    await db.execute('''
          CREATE TABLE Empleado (
            idEmpleado INTEGER PRIMARY KEY,
            nombre TEXT,
            apellido TEXT,
            correo TEXT,
            telefono TEXT,
            contrasena TEXT,
            estado INTEGER
          )
        ''');
    await db.execute('''
          CREATE TABLE Administrador (
            idAdministrador INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT,
            apellido TEXT,
            correo TEXT,
            telefono TEXT,
            contrasena TEXT,
            estado INTEGER
          )
        ''');
  }

  Future<void> _insertInitialData(Database db) async {
    // Insertar datos de ejemplo en la tabla Cliente
    await db.insert('Cliente', {
      'idCliente': 1,
      'nombre': 'María',
      'apellido': 'García',
      'correo': 'maria@gmail.com',
      'telefono': '302546213',
      'contrasena': 'maria123',
      'estado': 1,
    });
    await db.insert('Cliente', {
      'idCliente': 2,
      'nombre': 'Juan',
      'apellido': 'Pérez',
      'correo': 'juan@gmail.com',
      'telefono': '30264516',
      'contrasena': 'juan123',
      'estado': 1,
    });
    await db.insert('Cliente', {
      'idCliente': 3,
      'nombre': 'Juan',
      'apellido': 'garcia',
      'correo': 'juangarcia@gmail.com',
      'telefono': '301123454',
      'contrasena': 'garcia123',
      'estado': 1,
    });

    // Insertar datos de ejemplo en la tabla Empleado
    await db.insert('Empleado', {
      'idEmpleado': 1,
      'nombre': 'Jackeline',
      'apellido': 'Pérez',
      'correo': 'jacke@gmail.com',
      'telefono': '30654123',
      'contrasena': 'contraseña123',
      'estado': 1,
    });
    await db.insert('Empleado', {
      'idEmpleado': 2,
      'nombre': 'Monica',
      'apellido': 'Pérez',
      'correo': 'monica@gmail.com',
      'telefono': '30265495',
      'contrasena': 'monica123',
      'estado': 1,
    });
    await db.insert('Administrador', {
      'idAdministrador': 1,
      'nombre': 'Jackeline',
      'apellido': 'arroyave',
      'correo': 'jackelinee@gmail.com',
      'telefono': '30215645',
      'contrasena': 'jackeline123',
      'estado': 1,
    });
    await db.insert('Administrador', {
      'idAdministrador': 2,
      'nombre': 'Moni',
      'apellido': 'garcia',
      'correo': 'Mon123@gmail.com',
      'telefono': '320231',
      'contrasena': 'Moni1234',
      'estado': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 1,
      'nombreServicio': 'Uñas esculpidas',
      'precioServicio': 90000.0,
      'tiempoServicio': '3 hora',
      'imgServicio':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo8hUlWcwbXkr83oNIgRryvgjhrfAKHpeKBg&s',
      'estadoServicio': 1,
    });

    await db.insert('Servicio', {
      'idServicio': 2,
      'nombreServicio': 'Uñas acrilicas',
      'precioServicio': 70000.0,
      'tiempoServicio': '4 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 3,
      'nombreServicio': 'Uñas 3D',
      'precioServicio': 100000.0,
      'tiempoServicio': '3 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 4,
      'nombreServicio': 'Uñas press on',
      'precioServicio': 50000.0,
      'tiempoServicio': '5 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 5,
      'nombreServicio': 'Uñas permanentes',
      'precioServicio': 70000.0,
      'tiempoServicio': '4 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });
    await db.insert('Servicio', {
      'idServicio': 6,
      'nombreServicio': 'Uñas Semipermanentes',
      'precioServicio': 60000.0,
      'tiempoServicio': '3 horas',
      'imgServicio': '',
      'estadoServicio': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 1,
      'nombreInsumo': 'Esmalte rojo',
      'imagenInsumo':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo8hUlWcwbXkr83oNIgRryvgjhrfAKHpeKBg&s',
      'cantidadInsumo': 20,
      'usosDisponibles': 15,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 2,
      'nombreInsumo': 'Removedor de cutícula',
      'imagenInsumo': '',
      'cantidadInsumo': 15,
      'usosDisponibles': 12,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 3,
      'nombreInsumo': 'Crema hidratante',
      'imagenInsumo': '',
      'cantidadInsumo': 30,
      'usosDisponibles': 25,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 4,
      'nombreInsumo': 'Lima para uñas',
      'imagenInsumo': '',
      'cantidadInsumo': 50,
      'usosDisponibles': 45,
      'estadoInsumo': 1,
    });

    await db.insert('Insumo', {
      'idInsumo': 5,
      'nombreInsumo': 'Aceite para cutículas',
      'imagenInsumo': '.',
      'cantidadInsumo': 25,
      'usosDisponibles': 20,
      'estadoInsumo': 1,
    });
    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 1,
      'servicioId': 1,
      'cantidad': 1,
      'insumoId': 1,
    });

    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 2,
      'servicioId': 1,
      'cantidad': 1,
      'insumoId': 2,
    });

    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 3,
      'servicioId': 2,
      'cantidad': 1,
      'insumoId': 3,
    });

    await db.insert('InsumoXServicio', {
      'idInsumoXServicio': 4,
      'servicioId': 2,
      'cantidad': 1,
      'insumoId': 4,
    });

    // Insertar más datos de ejemplo en otras tablas según sea necesario
    // ...
  }

  Future<List<Map<String, dynamic>>> getAdiciones() async {
    Database db = await database;
    return await db.query('Insumo');
  }

  // Future<List<Map<String, dynamic>>> getVentas() async {
  //   Database db = await database;
  //   return await db.rawQuery('''
  //   SELECT V.idVenta, V.idServicio, S.nombre AS nombreServicio, S.imageUrl AS imageUrl, V.cantidad, V.total
  //   FROM Venta V
  //   INNER JOIN Servicio S ON V.idServicio = S.idServicio
  // ''');
  // }

  Future<int> getCountVentas() async {
    Database db = await database;
    List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT COUNT(*) FROM Venta');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }

  Future<int> insertVenta(Map<String, dynamic> ventaData) async {
    Database db = await database;
    return await db.insert('Venta', ventaData);
  }

  Future<List<Map<String, dynamic>>> getVentas() async {
    Database db = await database;
    return await db.rawQuery('''
  SELECT V.idVenta, V.empleadoId, V.clienteId, V.servicioId, V.horaServicio, V.fechaVenta, V.estadoVenta,
       S.nombreServicio AS nombreServicio, S.imgServicio AS imageUrl, S.precioServicio AS precioServicio
FROM Venta V
INNER JOIN Servicio S ON V.servicioId = S.idServicio

  ''');
  }

  Future<void> deleteVenta(int idVenta) async {
    try {
      Database db = await database;
      int rowsAffected = await db.delete(
        'Venta', // Nombre de la tabla de la cual eliminar registros
        where:
            'idVenta = ?', // Condición para identificar el registro a eliminar
        whereArgs: [idVenta], // Valor del ID de la venta a eliminar
      );

      if (rowsAffected > 0) {
        print('Venta eliminada exitosamente');
      } else {
        print('No se encontró ninguna venta con el ID especificado');
      }
    } catch (e) {
      print('Error al eliminar la venta: $e');
      throw Exception('Error al eliminar la venta');
    }
  }
}
