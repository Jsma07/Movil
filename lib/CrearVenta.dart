import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:primer_proyecto/Adiciones.dart';
import 'package:primer_proyecto/main.dart';
import 'package:primer_proyecto/Login.dart';
import 'package:intl/intl.dart';
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
      'Subtotal': subtotal,
      'Descuento': descuento,
      'Total': total,
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
  final TextEditingController _descuentoController = TextEditingController();
  final TextEditingController _fechaVentaController = TextEditingController();
  double _total = 0.0;
  double _subtotal = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarClientesYEmpleados();
    _cargarServicios();
    _actualizarFechaVenta();
    _descuentoController.addListener(() {
      _actualizarTotal();
    });
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

  void _actualizarFechaVenta() {
    DateTime ahora = DateTime.now();
    String fechaFormateada =
        '${ahora.day}/${ahora.month}/${ahora.year} ${ahora.hour}:${ahora.minute}';
    _fechaVentaController.text = fechaFormateada;
    _fechaVenta = ahora;
  }

  final formatCurrency = NumberFormat.currency(locale: 'es_CO', symbol: '\$');
Future<void> _guardarVenta(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    // Mostrar alerta de confirmación antes de guardar
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text('¿Estás seguro de que deseas guardar la venta?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (shouldSave == true) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('authToken');
        print('Token recuperado: $token');

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error de autenticación. Intente iniciar sesión de nuevo.'),
            ),
          );
          return;
        }

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
          Uri.parse('https://47f025a5-3539-4402-babd-ba031526efb2-00-xwv8yewbkh7t.kirk.replit.dev/Jackenail/RegistrarVenta'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode(nuevaVenta.toMap()),
        );

        if (response.statusCode == 201) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Éxito'),
                content: const Text('Venta agregada con éxito'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
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
}

  void _actualizarTotal() {
    double subtotal = _calcularSubtotal();
    double descuento = _calcularDescuento(subtotal);
    setState(() {
      _total = subtotal - descuento;
    });
  }

  double _calcularSubtotal() {
    if (_servicioId == null) {
      print('Error: ID del servicio es null');
      return 0.0;
    }

    final servicioSeleccionado = servicios.firstWhere(
      (servicio) => servicio['IdServicio'] == _servicioId,
      orElse: () => {},
    );

    if (servicioSeleccionado.isEmpty) {
      print('Error: No se encontró el servicio con ID $_servicioId');
      return 0.0;
    }

    double precioServicio = 0.0;

   if (servicioSeleccionado.containsKey('Precio_Servicio')) {
    var precio = servicioSeleccionado['Precio_Servicio'];

    if (precio is String) {
      // Si el valor es una cadena, realiza la conversión de formato
      String precioString = precio.replaceAll('.', '').replaceAll(',', '.');
      precioServicio = double.tryParse(precioString) ?? 0.0;
    } else if (precio is int) {
      // Si el valor es un entero, conviértelo a double directamente
      precioServicio = precio.toDouble();
    } else if (precio is double) {
      // Si el valor ya es un double, simplemente asígnalo
      precioServicio = precio;
    } else {
      // Maneja otros tipos o casos de error
      print('Tipo inesperado para Precio_Servicio: ${precio.runtimeType}');
      precioServicio = 0.0;
    }
  }

    print('Subtotal calculado: $precioServicio');
    return precioServicio;
  }

  double _calcularDescuento(double subtotal) {
    String descuentoTexto = _descuentoController.text;
    double descuento = double.tryParse(descuentoTexto) ?? 0.0;

    if (descuento > subtotal) {
      descuento = subtotal;
    }

    print('Descuento aplicado: $descuento');
    return descuento;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
          child: Container(
          
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 132, 241, 255),
                  Color.fromARGB(255, 250, 250, 250),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(58, 68, 68, 68).withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  // Avatar izquierdo
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage('https://i.pinimg.com/736x/d5/8a/f4/d58af48f25d5a8df2854463c83e2f2e8.jpg'),
                  ),
                  // Spacer para empujar el texto hacia la izquierda
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 75.0), // Ajusta el espacio entre el avatar y el texto
                        Text(
                          'Jake Nails',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Avatar derecho (opcional)
                  
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
                          // Nombre del Servicio
                        DropdownButtonFormField<String>(
  decoration: InputDecoration(
    hintText: 'Servicio',
    hintStyle: const TextStyle(fontWeight: FontWeight.w600),
    prefixIcon: const Icon(Icons.local_atm),
    fillColor: Colors.grey.shade200,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25),
    ),
  ),
  items: servicios.where((servicio) =>
    servicio['EstadoServicio'] == 1
  ).map((servicio) {
    return DropdownMenuItem<String>(
      value: servicio['Nombre_Servicio'],
      child: Text(servicio['Nombre_Servicio']),
    );
  }).toList(),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor seleccione el nombre del servicio';
    }
    return null;
  },
  onChanged: (value) {
    setState(() {
      _servicioId = servicios.firstWhere((serv) =>
        serv['Nombre_Servicio'] == value && serv['EstadoServicio'] == 1
      )['IdServicio'];
      _actualizarTotal();
    });
  },
),

                          const SizedBox(height: 25),
                          // Nombre del Empleado
                          DropdownButtonFormField<String>(
  decoration: InputDecoration(
    hintText: 'Manicurista',
    hintStyle: const TextStyle(fontWeight: FontWeight.w600),
    prefixIcon: const Icon(Icons.account_circle),
    fillColor: Colors.grey.shade200,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25),
    ),
  ),
  items: empleados.where((empleado) =>
    empleado['Estado'] == 1 && empleado['IdRol'] == 2
  ).map((empleado) {
    return DropdownMenuItem<String>(
      value: empleado['IdCliente'].toString(),
      child: Text('${empleado['Nombre']} ${empleado['Apellido'] ?? ''}'),
    );
  }).toList(),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor seleccione el nombre del cliente';
    }
    return null;
  },
  onChanged: (value) {
    _clienteId = int.parse(value!);
  },
  onSaved: (value) {
    _clienteId = int.parse(value!);
  },
),

                          const SizedBox(height: 25),
                          // Nombre del Cliente
                        DropdownButtonFormField<String>(
  decoration: InputDecoration(
    hintText: 'Cliente',
    hintStyle: const TextStyle(fontWeight: FontWeight.w600),
    prefixIcon: const Icon(Icons.account_circle),
    fillColor: Colors.grey.shade200,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(25),
    ),
  ),
  items: clientes.where((cliente) =>
    cliente['Estado'] == 1
  ).map((cliente) {
    return DropdownMenuItem<String>(
      value: cliente['IdCliente'].toString(),
      child: Text('${cliente['Nombre']} ${cliente['Apellido'] ?? ''}'),
    );
  }).toList(),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor seleccione el nombre del cliente';
    }
    return null;
  },
  onChanged: (value) {
    _clienteId = int.parse(value!);
  },
  onSaved: (value) {
    _clienteId = int.parse(value!);
  },
),

                          const SizedBox(height: 25),
                          // Campo para Descuento
                          TextFormField(
                            controller: _descuentoController,
                            decoration: InputDecoration(
                              hintText: 'Descuento',
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
                              prefixIcon: const Icon(Icons.percent),
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
                            onChanged: (_) => _actualizarTotal(),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 25),
                          // Fecha de la venta
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Fecha de la venta',
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w600),
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
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            readOnly: true,
                            controller: _fechaVentaController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione la fecha de la venta';
                              }
                              return null;
                            },
                            enabled: false,
                          ),
                          const SizedBox(height: 40),
                          // Botones
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 140,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción del botón
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 12, 12, 12),
                                  ),
                                  child: Text(
                                    'Total: ${formatCurrency.format(_total).split(',')[0]}',
                                    style: const TextStyle(
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
                                    _guardarVenta(context);
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
