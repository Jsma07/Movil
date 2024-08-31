import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:primer_proyecto/Adiciones.dart';
import 'package:primer_proyecto/main.dart';
import 'package:primer_proyecto/Login.dart';
import 'Databasehelper.dart' as DBHelper;
import 'package:http/http.dart' as http;

class Venta {
  int empleadoId;
  int clienteId;
  int servicioId;
  DateTime fechaVenta;
  int estadoVenta;
  final double subtotal; 
  final double descuento; 
  final double total; 

  Venta({
    required this.empleadoId,
    required this.clienteId,
    required this.servicioId,
    required this.fechaVenta,
    required this.estadoVenta,
     required this.subtotal, 
    required this.descuento,
    required this.total, 
  });

  Map<String, dynamic> toMap() {
    return {
      'idEmpleado': empleadoId,
      'IdCliente': clienteId,
      'idServicio': servicioId,
      'Fecha': fechaVenta.toIso8601String(),
      'Estado': estadoVenta,
    };
  }
}

class CrearVenta extends StatefulWidget {
  const CrearVenta({Key? key}) : super(key: key);

  @override
  _CrearVentaState createState() => _CrearVentaState();
}

class _CrearVentaState extends State<CrearVenta> {
  int? _empleadoId;
  int? _clienteId;
  int? _servicioId;
  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> empleados = [];
  List<Map<String, dynamic>> servicios = [];
  final _formKey = GlobalKey<FormState>();
  DateTime _fechaVenta = DateTime.now();

  @override
  void initState() {
    super.initState();
    _cargarClientesYEmpleados();
    _cargarServicios();
  }

  Future<void> _cargarClientesYEmpleados() async {
    try {
      final clientesResponse = await DBHelper.DatabaseHelper().getClientes();
      final empleadosResponse = await DBHelper.DatabaseHelper().getEmpleados();

      setState(() {
        clientes = clientesResponse;
        empleados = empleadosResponse;
      });
    } catch (e) {
      print('Error al cargar clientes y empleados: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar clientes y empleados')),
      );
    }
  }

  Future<void> _cargarServicios() async {
    try {
      final serviciosResponse = await DBHelper.DatabaseHelper().getServicios();

      setState(() {
        servicios = serviciosResponse;
      });
    } catch (e) {
      print('Error al cargar servicios: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar servicios')),
      );
    }
  }

void _guardarVenta(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    try {
      // Recupera el token de SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');
      print('Token recuperado: $token');

      if (token == null) {
        print('Error: No se encontró el token');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error de autenticación. Intente iniciar sesión de nuevo.'),
          ),
        );
        return; 
      }

      // Suponiendo que tienes lógicas para calcular Subtotal, Descuento y Total
      double subtotal = _calcularSubtotal();
      double descuento = _calcularDescuento(subtotal);
      double total = subtotal - descuento;

      Venta nuevaVenta = Venta(
        empleadoId: _empleadoId!,
        clienteId: _clienteId!,
        servicioId: _servicioId!,
        fechaVenta: _fechaVenta,
        estadoVenta: 1,
        subtotal: subtotal, 
        descuento: descuento, 
        total: total, 
      );

      final response = await http.post(
        Uri.parse('http://192.168.75.66:5000/Jackenail/RegistrarVenta'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(nuevaVenta.toMap()),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Venta registrada correctamente'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } else {
        throw Exception('Error al registrar la venta');
      }
    } catch (e) {
      print('Error al guardar la venta: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al guardar la venta'),
        ),
      );
    }
  }
}

double _calcularSubtotal() {

  return 100.0; 
}

double _calcularDescuento(double subtotal) {
  
  return 10.0; 
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromARGB(230, 98, 196, 221),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(
                        0, 3), // cambios de posición de la sombra en el eje y
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/564x/85/53/5e/85535e2d471e0f036ae4492327581c3e.jpg'),
                    ),
                    Text(
                      'Jacke Nail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(
                          'https://i.pinimg.com/236x/1e/56/aa/1e56aa733e30dc0fd59a72182c8a7df9.jpg'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://i.pinimg.com/736x/71/7d/ce/717dce3d21e998822a3ca37065b932d3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Registrar ventas',
                  style: TextStyle(
                    color: Color.fromARGB(255, 87, 153, 214),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              // Acción del primer botón
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Info venta',
                              style: TextStyle(
                                color: Color.fromARGB(255, 244, 245, 246),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Adiciones()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 252, 253, 254),
                            ),
                            child: const Text('Adiciones'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        height:
                            30), //realizo el espacio entre los botones y los selects

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Nombre del empleado',
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              prefixIcon: const Icon(Icons.business),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            items: empleados.map((empleado) {
                              return DropdownMenuItem<String>(
                                value: empleado['Nombre'] ?? '',
                                child: Text(empleado['Nombre'] ?? ''),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione el nombre del empleado';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _empleadoId = empleados.firstWhere((emp) =>
                                    emp['Nombre'] == value)['IdEmpleado'];
                              });
                            },
                            onSaved: (value) {
                              _empleadoId = empleados.firstWhere((emp) =>
                                  emp['Nombre'] == value)['IdEmpleado'];
                            },
                          ),
                          const SizedBox(height: 25),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Nombre del Cliente',
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              prefixIcon: const Icon(Icons.account_circle),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            items: clientes.map((cliente) {
                              return DropdownMenuItem<String>(
                                value: cliente['IdCliente'].toString(),
                                child: Text(cliente['Nombre'] ?? ''),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione el nombre del cliente';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _clienteId = int.parse(
                                  value!); 
                            },
                            onSaved: (value) {
                              _clienteId = int.parse(
                                  value!); 
                            },
                          ),
                          const SizedBox(height: 25),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Nombre del Servicio',
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              prefixIcon: const Icon(Icons.local_atm),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            items: servicios.map((servicios) {
                              return DropdownMenuItem<String>(
                                value: servicios['Nombre_Servicio'],
                                child: Text(servicios['Nombre_Servicio']),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione el nombre del empleado';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _servicioId = servicios.firstWhere((serv) =>
                                    serv['Nombre_Servicio'] ==
                                    value)['IdServicio'];
                              });
                            },
                          ),
                          const SizedBox(height: 25),
                          TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Fecha de la venta',
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                prefixIcon: const Icon(Icons.calendar_today),
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              readOnly: true,
                              onTap: () async {
                                final DateTime currentDate = DateTime.now();
                                final DateTime firstSelectableDate =
                                    currentDate.subtract(const Duration(
                                        days:
                                            15)); // 15 días antes de la fecha actual
                                final DateTime lastSelectableDate =
                                    currentDate; // La fecha actual como fecha máxima

                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: _fechaVenta,
                                  firstDate: firstSelectableDate,
                                  lastDate: lastSelectableDate,
                                  builder:
                                      (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: const ColorScheme.light(
                                          background: Colors.purple,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );

                                if (pickedDate != null &&
                                    pickedDate != _fechaVenta) {
                                  setState(() {
                                    _fechaVenta = pickedDate;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor seleccione la fecha de la venta';
                                }
                                return null;
                              },
                              controller: TextEditingController(
                                text:
                                    '${_fechaVenta.day}/${_fechaVenta.month}/${_fechaVenta.year}',
                              )),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción del primer botón
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 12, 12, 12),
                                  ),
                                  child: const Text(
                                    'Total: ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 244, 245, 246),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _guardarVenta(
                                        context); 
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text(
                                    'Guardar',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 244, 245, 246),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'cerrar sesion',
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CrearVenta()),
              );
            case 2:
              Login.destroySession(context);

              break;
            // Agrega más casos según la cantidad de elementos en tu BottomNavigationBar
          }
        },
      ),
    );
  }
}
