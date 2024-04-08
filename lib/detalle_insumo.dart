import 'package:flutter/material.dart';
import 'CrearVenta.dart';
import 'package:primer_proyecto/main.dart';
import 'fondo_pantalla.dart'; // Asegúrate de tener este import correcto
import 'cards_detalles.dart';
import 'CustomBottomNavigationBar.dart'; // Asegúrate de tener este import correcto

class DetalleInsumo extends StatefulWidget {
  final String imageUrl;
  final String productName;

  const DetalleInsumo({
    required this.imageUrl,
    required this.productName,
  });

  @override
  _DetalleInsumoState createState() => _DetalleInsumoState();
}

class _DetalleInsumoState extends State<DetalleInsumo> {
  bool _isLoading = false;
  int _currentIndex = 0;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CrearVenta()), // Reemplaza CrearVenta con la página de destino correcta
        );
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
            top: 20, // Ajusta esta posición según tu preferencia
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.productName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
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

                            Future.delayed(Duration(seconds: 1), () {
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
            Center(
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
