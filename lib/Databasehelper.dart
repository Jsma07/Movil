import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  final String baseUrl = 'http://192.168.137.1:5000';

  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/iniciarSesion'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'correo': email, 'contrasena': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];

        if (responseData['user'] != null &&
            responseData['user']['id'] != null) {
          // Guardar el token en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', token);
          print('Token guardado: $token');

          return token;
        } else {
          print('Usuario no encontrado en la tabla usuarios');
          return null;
        }
      } else {
        print('Error al iniciar sesión: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getVentas() async {
    final response =
        await http.get(Uri.parse('$baseUrl/Jackenail/Listarventas'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar las ventas');
    }
  }

  Future<List<Map<String, dynamic>>> getClientes() async {
    final response =
        await http.get(Uri.parse('$baseUrl/jackenail/Listar_Clientes'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar los clientes');
    }
  }

  Future<List<Map<String, dynamic>>> getEmpleados() async {
    final response =
        await http.get(Uri.parse('$baseUrl/jackenail/Listar_Empleados'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar los empleados');
    }
  }

  Future<List<Map<String, dynamic>>> getServicios() async {
    final response = await http.get(Uri.parse('$baseUrl/api/servicios'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Error al cargar los servicios');
    }
  }

  Future<Map<String, dynamic>> insertVenta(
      Map<String, dynamic> ventaData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Jackenail/RegistrarVenta'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(ventaData),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al registrar la venta');
    }
  }

  // Obtener adiciones desde la API
  Future<List<Map<String, dynamic>>> getAdiciones() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/Jackenail/Listarventas/adiciones'));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        // Convertir la lista de mapas dinámicos en una lista de mapas con tipo específico
        return jsonResponse
            .map((item) => item as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Error al obtener las adiciones');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error al obtener las adiciones');
    }
  }

  Future<void> anularVenta(int id) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Jackenail/CambiarEstado/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'Estado': 3,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 403) {
      throw Exception('403');
    } else {
      throw Exception('Error al anular la venta');
    }
  }

  Future<int> getCountVentas() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/totalventas'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // Obtén el valor de totalVentas y conviértelo a entero
        final int count = data['totalVentas'] as int;
        return count;
      } else {
        throw Exception(
            'Error al cargar las ventas: Estado ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al procesar la respuesta de las ventas: $e');
    }
  }

  // Método para obtener el detalle de una venta por su ID
  Future<Map<String, dynamic>?> getDetalleVenta(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Buscardetalle/$id'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> detalleVenta = json.decode(response.body);
        return detalleVenta;
      } else {
        print('Error al obtener el detalle de la venta: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}

  // Future<void> _createTables(Database db) async {
  //   await db.execute('''
  //         CREATE TABLE DetalleVenta (
  //           idDetalle INTEGER PRIMARY KEY,
  //           ventaId INTEGER,
  //           insumoId TEXT,
  //           precioUnitario REAL,
  //           cantidadInsumo INTEGER
  //         )
  //       ''');

  //   // Crear tabla Servicio
  //   await db.execute('''
  //         CREATE TABLE Servicio (
  //           idServicio INTEGER PRIMARY KEY,
  //           nombreServicio TEXT,
  //           precioServicio REAL,
  //           tiempoServicio TEXT,
  //           imgServicio TEXT,
  //           estadoServicio INTEGER
  //         )
  //       ''');

  //   // Crear tabla Insumo
  //   await db.execute('''
  //         CREATE TABLE Insumo (
  //           idInsumo INTEGER PRIMARY KEY,
  //           nombreInsumo TEXT,
  //           imagenInsumo TEXT,
  //           cantidadInsumo INTEGER,
  //           usosDisponibles INTEGER,
  //           estadoInsumo INTEGER
  //         )
  //       ''');

  //   // Crear tabla InsumoXServicio
  //   await db.execute('''
  //         CREATE TABLE InsumoXServicio (
  //           idInsumoXServicio INTEGER PRIMARY KEY,
  //           servicioId INTEGER,
  //           cantidad INTEGER,
  //           insumoId INTEGER,
  //           FOREIGN KEY (servicioId) REFERENCES Servicio(idServicio),
  //           FOREIGN KEY (insumoId) REFERENCES Insumo(idInsumo)
  //         )
  //       ''');

  //   // Crear tabla Cliente
  //   await db.execute('''
  //         CREATE TABLE Cliente (
  //           idCliente INTEGER PRIMARY KEY,
  //           nombre TEXT,
  //           apellido TEXT,
  //           correo TEXT,
  //           telefono TEXT,
  //           contrasena TEXT,
  //           estado INTEGER
  //         )
  //       ''');

  //   // Crear tabla Empleado
  //   await db.execute('''
  //         CREATE TABLE Empleado (
  //           idEmpleado INTEGER PRIMARY KEY,
  //           nombre TEXT,
  //           apellido TEXT,
  //           correo TEXT,
  //           telefono TEXT,
  //           contrasena TEXT,
  //           estado INTEGER
  //         )
  //       ''');
  //   await db.execute('''
  //         CREATE TABLE Administrador (
  //           idAdministrador INTEGER PRIMARY KEY AUTOINCREMENT,
  //           nombre TEXT,
  //           apellido TEXT,
  //           correo TEXT,
  //           telefono TEXT,
  //           contrasena TEXT,
  //           estado INTEGER
  //         )
  //       ''');
  // }

  
