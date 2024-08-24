import 'package:flutter/material.dart';
import 'package:primer_proyecto/Adiciones.dart';
import 'package:primer_proyecto/CrearVenta.dart';
import 'package:primer_proyecto/CustomBottomNavigationBar.dart';
import 'package:primer_proyecto/detalle_insumo.dart';
import 'package:primer_proyecto/main.dart';

class SaleItem {
  final String title;
  final String price;
  final String imageUrl;
  int quantity;

  SaleItem({
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class ListarAdiciones extends StatefulWidget {
  final List<Map<String, dynamic>> adiciones;

  const ListarAdiciones({Key? key, required this.adiciones}) : super(key: key);

  @override
  _ListarAdicionesState createState() => _ListarAdicionesState();
}

class _ListarAdicionesState extends State<ListarAdiciones> {
  int _currentIndex = 0;

  late List<SaleItem> saleItems;

  @override
  void initState() {
    super.initState();
    saleItems = [
      SaleItem(
        title: 'Figuras 3D',
        price: '\$4.000',
        imageUrl:
            'https://i.pinimg.com/736x/a3/29/93/a3299364b40279d7d5769edecfe11352.jpg',
      ),
      SaleItem(
        title: 'Priedrerias',
        price: '\$1.000',
        imageUrl:
            'https://th.bing.com/th/id/OIP.rmp4wAbXA3tDJTo6IKV0xwAAAA?w=465&h=537&rs=1&pid=ImgDetMain',
      ),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
        break;
      case 1:
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const CrearVenta()),
        // );
        break;
      case 2:
        // Agrega el código para la tercera página si es necesario
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
                    offset: const Offset(0, 3),
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
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://i.pinimg.com/736x/48/4c/32/484c3283a34c9db7df7ead32d138bf3f.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            top: 180, // Ajusta la posición relativa a la parte superior
            left: 88,
            child: Text(
              'Registrar ventas',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 225),
              Padding(
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
                              backgroundColor:
                                  const Color.fromARGB(255, 244, 245, 246),
                            ),
                            child: const Text('Info venta'),
                          ),
                        ),
                        const SizedBox(width: 20),
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
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'Adiciones',
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
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.shopping_cart),
                    const Text(
                      'Agregar Adiciones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(112, 185, 244, 1),
                        borderRadius: BorderRadius.circular(20),
                      ),
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
                  ],
                ),
              ),
              const SizedBox(
                  height: 2), // Espacio entre el botón y las tarjetas
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  itemCount: saleItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: buildSalesListItem(saleItems[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget buildSalesListItem(SaleItem saleItem) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(25), // Ajusta el radio de borde aquí
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(saleItem.imageUrl),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                saleItem.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              saleItem.price,
              style: const TextStyle(
                  color: Colors.blue), // Color azul para el precio
            ),
          ],
        ),
        subtitle: Row(
          children: [
            IconButton(
              onPressed: () {
                // Decrementar la cantidad
                setState(() {
                  if (saleItem.quantity > 1) {
                    saleItem.quantity--;
                  }
                });
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              saleItem.quantity.toString(),
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              onPressed: () {
                // Incrementar la cantidad
                setState(() {
                  saleItem.quantity++;
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        trailing: const SizedBox(), // Elimina los botones de la parte derecha
      ),
    );
  }
}
