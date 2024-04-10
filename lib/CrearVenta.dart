import 'package:flutter/material.dart';
import 'package:primer_proyecto/Adiciones.dart';
import 'package:primer_proyecto/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:primer_proyecto/Login.dart';

import 'Databasehelper.dart' as DBHelper;

class Venta {
  int empleadoId;
  int clienteId;
  int servicioId;
  DateTime horaServicio;
  DateTime fechaVenta;
  int estadoVenta;

  Venta({
    required this.empleadoId,
    required this.clienteId,
    required this.servicioId,
    required this.horaServicio,
    required this.fechaVenta,
    required this.estadoVenta,
  });

  Map<String, dynamic> toMap() {
    return {
      'empleadoId': empleadoId,
      'clienteId': clienteId,
      'servicioId': servicioId,
      'horaServicio': horaServicio.toIso8601String(),
      'fechaVenta': fechaVenta.toIso8601String(),
      'estadoVenta': estadoVenta,
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
  List<Map<String, dynamic>> adiciones = [];
  List<Map<String, dynamic>> ventas = [];

  final _formKey = GlobalKey<FormState>();
  DateTime _fechaVenta = DateTime.now();
  DBHelper.DatabaseHelper _databaseHelper = DBHelper.DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _cargarClientesYEmpleados();
    _cargarServicios();
  }

  Future<void> _cargarClientesYEmpleados() async {
    Database db = await _databaseHelper.database;
    List<Map<String, dynamic>> clientesList = await db.query('Cliente');
    List<Map<String, dynamic>> empleadosList = await db.query('Empleado');

    // Actualizar el estado del widget con los datos recuperados
    setState(() {
      clientes = clientesList;
      empleados = empleadosList;
    });
  }

  Future<void> _loadVentas() async {
    try {
      DBHelper.DatabaseHelper databaseHelper = DBHelper.DatabaseHelper();
      List<Map<String, dynamic>> ventasData = await databaseHelper.getVentas();
      setState(() {
        ventas = ventasData;
      });
    } catch (e) {
      print('Error al cargar las ventas: $e');
    }
  }

  Future<void> _cargarServicios() async {
    try {
      Database db = await _databaseHelper.database;
      List<Map<String, dynamic>> serviciosList = await db.query('Servicio');

      setState(() {
        servicios = serviciosList;
      });
    } catch (e) {
      print('Error al cargar servicios: $e');
    }
  }

  void _guardarVenta(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        Venta nuevaVenta = Venta(
          // El ID se asignará automáticamente en la base de datos
          empleadoId: _empleadoId!,
          clienteId: _clienteId!,
          servicioId: _servicioId!,
          horaServicio: _fechaVenta,
          fechaVenta: _fechaVenta,
          estadoVenta: 1,
        );

        await _databaseHelper.insertVenta(nuevaVenta.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Venta registrada correctamente'),
          ),
        );

        // Redirigir solo si la inserción fue exitosa
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        ).then((_) {
          // Actualizar la lista de ventas al volver a MyHomePage
          _loadVentas();
        });
      } catch (e) {
        print('Error al guardar la venta: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la venta'),
          ),
        );
      }
    }
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
                                value: empleado['nombre'] ?? '',
                                child: Text(empleado['nombre'] ?? ''),
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
                                    emp['nombre'] == value)['idEmpleado'];
                              });
                            },
                            onSaved: (value) {
                              _empleadoId = empleados.firstWhere((emp) =>
                                  emp['nombre'] == value)['idEmpleado'];
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
                                value: cliente['idCliente'].toString(),
                                child: Text(cliente['nombre'] ?? ''),
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
                                  value!); // Convierte el valor seleccionado de String a int
                            },
                            onSaved: (value) {
                              _clienteId = int.parse(
                                  value!); // Convierte el valor seleccionado de String a int
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
                                value: servicios['nombreServicio'],
                                child: Text(servicios['nombreServicio']),
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
                                    serv['nombreServicio'] ==
                                    value)['idServicio'];
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
                                        context); // Llama directamente a la función _guardarVenta con el contexto actual
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
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrearVenta()),
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
