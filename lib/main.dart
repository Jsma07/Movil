import 'package:flutter/material.dart';
import 'package:primer_proyecto/CrearVenta.dart';
import 'package:primer_proyecto/CustomBottomNavigationBar.dart';
import 'package:primer_proyecto/Login.dart';
import 'package:primer_proyecto/app_bar.dart';
import 'package:primer_proyecto/detalle_insumo.dart';
import 'package:primer_proyecto/Databasehelper.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Principal(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> ventas = [];
  List<Map<String, dynamic>> filteredVentas = [];
  String searchQuery = '';
  Map<String, dynamic>? topService;

  @override
  void initState() {
    super.initState();
    _loadVentas();
    _loadTopService(); 
  }

Future<void> _loadVentas() async {
  try {
    DatabaseHelper databaseHelper = DatabaseHelper();
    ventas = await databaseHelper.getVentas();
    filteredVentas = ventas; 
    setState(() {});
  } catch (e) {
    print('Error al cargar las ventas: $e');
  }
}


Future<void> _loadTopService() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper();
      final service = await databaseHelper.getTopService();
      setState(() {
        topService = service;
      });
    } catch (e) {
      print('Error al cargar el servicio: $e');
    }
}

  Future<int> _getTotalVentas() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper();
      int totalVentas = await databaseHelper.getCountVentas();
      return totalVentas;
    } catch (e) {
      print('Error al obtener el total de ventas: $e');
      return 0;
    }
  }

  void _filterVentas(String query) {
    setState(() {
      searchQuery = query;
      filteredVentas = ventas
          .where((venta) =>
              venta['servicio']['Nombre_Servicio']
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  Widget estadoWidget(int estado) {
    Color backgroundColor;
    Color textColor;
    String estadoTexto;

    switch (estado) {
      case 1:
        backgroundColor = const Color.fromARGB(255, 111, 190, 114);
        textColor = Colors.white;
        estadoTexto = 'Vendido';
        break;
      case 2:
        backgroundColor = const Color.fromRGBO(112, 185, 244, 1);
        textColor = Colors.white;
        estadoTexto = 'En proceso';
        break;
      case 3:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        estadoTexto = 'Anulada';
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.black;
        estadoTexto = 'Desconocido';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        estadoTexto,
        style: TextStyle(color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 25),
        child: ventas.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.white, // Color de fondo del contenedor
                              borderRadius: BorderRadius.circular(
                                  15), // Bordes redondeados
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Color de la sombra
                                  spreadRadius:
                                      2, // Radio de expansión de la sombra
                                  blurRadius: 5, // Difuminado de la sombra
                                  offset: const Offset(
                                      0, 3), // Desplazamiento de la sombra
                                ),
                              ],
                            ),
                            child: Card(
                              elevation:
                                  0, // Desactiva la sombra predeterminada del Card
                              margin:
                                  EdgeInsets.zero, // Elimina el margen del Card
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: FutureBuilder<int>(
                                        future: _getTotalVentas(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else {
                                            if (snapshot.hasError) {
                                              return const Text(
                                                  'Error al cargar las ventas');
                                            } else {
                                              final totalVentas =
                                                  snapshot.data ?? 0;
                                              return Column(
                                                children: [
                                                  const Text(
                                                    'Ventas realizadas',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.attach_money,
                                                        color: Colors.black,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        '${totalVentas}',
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                       Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: topService == null
                              ? const Center(child: CircularProgressIndicator())
                              : Card(
                                  elevation: 0,
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Center(
                                          child: Text(
                                            'Técnica más vendida',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 15,
                                              backgroundImage: NetworkImage(topService!['ImgServicio']),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                topService!['Nombre_Servicio'] ?? 'Nombre del servicio',
                                                style: const TextStyle(fontSize: 17),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2, // Permite hasta dos líneas de texto
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text(
                      'Lista de ventas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(112, 185, 244, 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const CrearVenta()),
                                );
                              },
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Barra de búsqueda
                   Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.blue),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                        ),
                        hintText: 'Buscar ventas...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      onChanged: _filterVentas,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredVentas.length,
                      itemBuilder: (context, index) {
                        final venta = filteredVentas[index];
                        final nombreServicio =
                            venta['servicio']['Nombre_Servicio'] ?? 'Producto';
                        final imageUrl = venta['servicio']['ImgServicio'] ?? '';
                        final total = venta['Total'] ?? '0.00';
                        final estadoVenta = venta['Estado'];

                        // Formatear el total a pesos colombianos y sin decimales
                        final formatCurrency = NumberFormat.currency(
                            locale: 'es_CO', symbol: '\$');
                        final totalFormatted =
                            formatCurrency.format(total).split(',')[0];

                        // Construye la URL completa de la imagen
                        final validImageUrl = imageUrl.isNotEmpty
                            ? 'https://47f025a5-3539-4402-babd-ba031526efb2-00-xwv8yewbkh7t.kirk.replit.dev$imageUrl'
                            : 'https://i.pinimg.com/736x/07/e1/44/07e14409b709e67cac82a1aa87ecca53.jpg';

                        return buildSalesListItem(
                          title: nombreServicio,
                          imageWidget: Image.network(
                            validImageUrl,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error cargando la imagen: $error');
                              return Image.network(
                                'https://i.pinimg.com/736x/07/e1/44/07e14409b709e67cac82a1aa87ecca53.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                          subtitle: 'Total: \$$totalFormatted',
                          estado: estadoWidget(estadoVenta),
                          onVisibilityTap: () async {
                            int? ventaId = venta['idVentas'];

                            if (ventaId != null) {
                              print('Id detalle venta: $ventaId');

                              try {
                                final detalleVenta = await DatabaseHelper()
                                    .getDetalleVenta(ventaId);

                                if (detalleVenta != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalleInsumo(
                                        imageUrl: validImageUrl,
                                        productName: nombreServicio,
                                        detallesVenta: detalleVenta,
                                      ),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'No se encontraron detalles de la venta.'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                print('Error obteniendo detalles de venta: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Error al conectar con el servidor.'),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ID de venta no válido.'),
                                ),
                              );
                            }
                          },

                          // Mostrar el botón de anular solo si la venta no está anulada
                          onCancelTap: estadoVenta != 3
                              ? () {
                                  _onCancelTap(context, index);
                                }
                              : null,
                          showCancelButton: estadoVenta != 3,
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  void _onCancelTap(BuildContext context, int index) async {
    try {
      if (index < 0 || index >= ventas.length) {
        print('Índice de venta fuera de rango');
        return;
      }

      final ventaId = ventas[index]['idVentas'];

      if (ventaId == null) {
        print('El ID de la venta es nulo');
        return;
      }

      DatabaseHelper databaseHelper = DatabaseHelper();

      // Verifica si la venta puede ser anulada
      try {
        await databaseHelper.anularVenta(ventaId);
      } catch (e) {
        if (e.toString() == 'Exception: 403') {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('No se puede anular'),
                content: const Text(
                    'Lo siento, no se puede anular porque ya pasó el tiempo permitido.'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Aceptar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        } else {
          print('Error al anular la venta: $e');
          return;
        }
      }

      final shouldCancel = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmar anulación'),
            content:
                const Text('¿Estás segura de que quieres anular esta venta?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );

      if (shouldCancel == true) {
        setState(() {
          ventas[index]['Estado'] = 3;
        });
        await _loadVentas();
      }
    } catch (e) {
      print('Error al anular la venta: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

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
  }

  Widget buildSalesListItem({
    required String title,
    required Widget imageWidget,
    required String subtitle,
    required Widget estado,
    required Function() onVisibilityTap,
    Function()? onCancelTap,
    bool showCancelButton = true,
  }) {
    return Card(
      child: ListTile(
        leading: SizedBox(
          width: 50,
          height: 50,
          child: ClipOval(
            child: imageWidget,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            const SizedBox(height: 4),
            estado,
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onVisibilityTap,
              child: Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(112, 185, 244, 1),
                ),
                child: const Icon(
                  Icons.visibility,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (showCancelButton)
              GestureDetector(
                onTap: onCancelTap,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(112, 185, 244, 1),
                  ),
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
