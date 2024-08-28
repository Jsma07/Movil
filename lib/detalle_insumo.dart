import 'package:flutter/material.dart';
import 'CrearVenta.dart';
import 'package:primer_proyecto/main.dart';
import 'fondo_pantalla.dart'; // Asegúrate de tener este import correcto
import 'cards_detalles.dart';
import 'CustomBottomNavigationBar.dart'; // Asegúrate de tener este import correcto
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetalleInsumo extends StatefulWidget {
  final String imageUrl;
  final String productName;

  const DetalleInsumo({
    super.key,
    required this.imageUrl,
    required this.productName,
  });

  @override
  _DetalleInsumoState createState() => _DetalleInsumoState();
}

class _DetalleInsumoState extends State<DetalleInsumo> {
  bool _isLoading = false;
  int _currentIndex = 0;
  Map<String, dynamic>? _detalleVenta;

  final String baseUrl =
      'http://192.168.100.44:5000'; // Asegúrate de que la URL sea correcta

  @override
  void initState() {
    super.initState();
    _fetchDetalleVenta(28); // Reemplaza 28 con el ID correcto si es necesario
  }

  Future<void> _fetchDetalleVenta(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Buscardetalle/$id'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _detalleVenta = data[0];
          });
        }
      } else {
        print('Error al obtener el detalle de la venta: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MyHomePage()), // Pasa los parámetros necesarios
        );
        break;
      case 1:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           const CrearVenta()), // Reemplaza CrearVenta con la página de destino correcta
        // );
        break;
      case 2:
        // Agrega el código para la tercera página si es necesario
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> images = [
      'https://www.cosmeticosghelic.com/wp-content/uploads/2020/09/coleccion-pastel.jpeg',
      'https://http2.mlstatic.com/D_NQ_NP_780729-MCO45480256626_042021-O.webp',
      'https://down-co.img.susercontent.com/file/f6b75a7d1c4a1423d685c7836a1b42b1',
      'https://bplus.com.co/wp-content/uploads/2021/05/LIMP.jpg'
    ];

    List<String> texts = ['Esmaltes', 'Limas', 'Gel', 'Desinfectante'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de ${widget.productName}'),
      ),
      body: Stack(
        children: [
          const FondoPantalla(
            imageUrl:
                'https://i.pinimg.com/736x/71/7d/ce/717dce3d21e998822a3ca37065b932d3.jpg',
          ),
          Positioned(
            top: 30, // Baja la posición
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60, // Reducir el tamaño de la imagen
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                const SizedBox(height: 10), // Ajusta el espacio
                Text(
                  widget.productName,
                  style: const TextStyle(
                    fontSize:
                        20, // Aumenta el tamaño de la fuente si es necesario
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20), // Espacio para nuevo contenido
                if (_detalleVenta != null) ...[
                  // Mostrar detalles de la venta
                  Text(
                    'Cliente: ${_detalleVenta!['venta']['cliente']['Nombre']} ${_detalleVenta!['venta']['cliente']['Apellido']}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Empleado: ${_detalleVenta!['venta']['empleado']['Nombre']} ${_detalleVenta!['venta']['empleado']['Apellido']}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Subtotal: ${_detalleVenta!['venta']['Subtotal']}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    'Total: ${_detalleVenta!['venta']['Total']}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ] else ...[
                  const Text(
                    'Cargando detalles...',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 350,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 209,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(width: 7),
                    ...images.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mantener presionado'),
                              duration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        onLongPress: () {
                          if (!_isLoading) {
                            setState(() {
                              _isLoading = true;
                            });

                            Future.delayed(const Duration(seconds: 1), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetalleInsumo(
                                    imageUrl: entry.value,
                                    productName: texts[entry.key],
                                  ),
                                ),
                              ).then((_) {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            });
                          }
                        },
                        child: ProductCard(
                          imageUrl: entry.value,
                          productName: texts[entry.key],
                          price: '\$40.000',
                          units: '1',
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DetalleInsumo(
      imageUrl: 'URL_DE_LA_IMAGEN',
      productName: 'NOMBRE_DEL_PRODUCTO',
    ),
  ));
}
