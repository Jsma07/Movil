import 'package:flutter/material.dart';
import 'package:primer_proyecto/CancelarVenta.dart';
import 'package:primer_proyecto/CrearVenta.dart';
import 'package:primer_proyecto/CustomBottomNavigationBar.dart';
import 'package:primer_proyecto/Login.dart';
import 'package:primer_proyecto/app_bar.dart';
import 'package:primer_proyecto/detalle_insumo.dart';
import 'package:primer_proyecto/Databasehelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de inicializar Flutter

  // Inicializa la base de datos
  // await DatabaseHelper().initDatabase();

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

  @override
  void initState() {
    super.initState();
    _loadVentas(); // Cargar ventas al iniciar la pantalla
  }

  Future<void> _loadVentas() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper();
      ventas = await databaseHelper.getVentas(); // Obtener ventas desde la API
      setState(() {}); // Actualizar la interfaz después de cargar las ventas
    } catch (e) {
      print('Error al cargar las ventas: $e');
    }
  }

  Future<int> _getTotalVentas() async {
    try {
      // Llamar al método en DatabaseHelper que obtiene el total de ventas
      DatabaseHelper databaseHelper = DatabaseHelper();
      int totalVentas = await databaseHelper.getCountVentas();
      return totalVentas;
    } catch (e) {
      print('Error al obtener el total de ventas: $e');
      return 0;
    }
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
                    height: 138,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Card(
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
                                          return const CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene el total de ventas
                                        } else {
                                          if (snapshot.hasError) {
                                            return const Text(
                                                'Error al cargar las ventas'); // Maneja errores si falla la obtención de datos
                                          } else {
                                            final totalVentas =
                                                snapshot.data ?? 0;
                                            return Column(
                                              children: [
                                                const Text(
                                                  'Ventas realizadas',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
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
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Acción del botón verde
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 147, 206, 189),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            minimumSize: const Size(40, 40),
                                          ),
                                          child: const Icon(
                                            Icons.visibility_off,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Acción del botón amarillo
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 245, 54, 54),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            minimumSize: const Size(40, 40),
                                          ),
                                          child: const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 138,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Center(
                                      child: Text(
                                        'Tecnica mas vendida',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          backgroundImage: NetworkImage(
                                              'https://i.pinimg.com/736x/07/e1/44/07e14409b709e67cac82a1aa87ecca53.jpg'),
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Uñas Acrilicas',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 147, 206, 189),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              minimumSize: const Size(40, 40),
                                            ),
                                            child: const Icon(
                                              Icons.visibility_off,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Acción del botón amarillo
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 245, 54, 54),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              minimumSize: const Size(40, 40),
                                            ),
                                            child: const Icon(
                                              Icons.search,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const CrearVenta()),
                                // );
                              },
                              icon: const Icon(Icons.add),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ventas.length,
                      itemBuilder: (context, index) {
                        final venta = ventas[index];
                        final nombreServicio =
                            venta['servicio']['Nombre_Servicio'] ?? 'Producto';
                        final imageUrl = venta['servicio']['ImgServicio'] ?? '';
                        final precioServicio =
                            venta['servicio']['Precio_Servicio'] ?? '0.00';

                        // Construye la URL completa de la imagen
                        final validImageUrl = imageUrl.isNotEmpty
                            ? 'http://localhost:5000$imageUrl'
                            : 'https://i.pinimg.com/736x/07/e1/44/07e14409b709e67cac82a1aa87ecca53.jpg';

                        return buildSalesListItem(
                          title: nombreServicio,
                          imageWidget: Image.network(
                            validImageUrl,
                            errorBuilder: (context, error, stackTrace) {
                              print(
                                  'Error cargando la imagen: $error'); // Para depuración
                              return Image.network(
                                'https://i.pinimg.com/736x/07/e1/44/07e14409b709e67cac82a1aa87ecca53.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                            fit: BoxFit.cover,
                          ),
                          subtitle: 'Precio: \$${precioServicio}',
                          onVisibilityTap: () {
                            print('Tapped visibility for venta: $venta');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalleInsumo(
                                  imageUrl: validImageUrl,
                                  productName: nombreServicio,
                                ),
                              ),
                            );
                          },
                          onCancelTap: () {
                            _onCancelTap(index);
                          },
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

  void _onCancelTap(int index) async {
    try {
      // Verificar que el índice esté dentro del rango de la lista de ventas
      if (index < 0 || index >= ventas.length) {
        print('Índice de venta fuera de rango');
        return;
      }

      // Obtener el ID de la venta del elemento seleccionado en la lista
      final ventaId = ventas[index]['idVenta'];

      // Llamar al método en DatabaseHelper para eliminar la venta por su ID
      DatabaseHelper databaseHelper = DatabaseHelper();
      await databaseHelper.deleteVenta(ventaId);

      // Actualizar la lista de ventas después de eliminar el registro
      await _loadVentas();
    } catch (e) {
      print('Error al eliminar la venta: $e');
      // Manejar cualquier error que ocurra durante la eliminación
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
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const CrearVenta()),
      // );
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
    required Function() onVisibilityTap,
    required Function() onCancelTap,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          child: ClipOval(
            child: imageWidget, // Envolver la imagen en ClipOval
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
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
