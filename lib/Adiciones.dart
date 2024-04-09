import 'package:flutter/material.dart';
import 'package:primer_proyecto/CrearVenta.dart';
import 'package:primer_proyecto/main.dart';
import 'CustomBottomNavigationBar.dart';
import 'package:primer_proyecto/Databasehelper.dart'
    as DBHelper; // Importa tu clase DatabaseHelper para realizar consultas

class Adiciones extends StatefulWidget {
  @override
  _AdicionesState createState() => _AdicionesState();
}

class _AdicionesState extends State<Adiciones> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> adiciones =
      []; // Lista para almacenar las adiciones

  @override
  void initState() {
    super.initState();
    _loadAdiciones(); // Cargar adiciones al iniciar la pantalla
  }

  Future<void> _loadAdiciones() async {
    try {
      DBHelper.DatabaseHelper databaseHelper =
          DBHelper.DatabaseHelper(); // Use DBHelper prefix
      adiciones = await databaseHelper
          .getAdiciones(); // Obtener adiciones desde la base de datos
      setState(() {}); // Actualizar la interfaz después de cargar las adiciones
    } catch (e) {
      print('Error al cargar las adiciones: $e');
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
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CrearVenta()),
        );
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://i.pinimg.com/736x/48/4c/32/484c3283a34c9db7df7ead32d138bf3f.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 125.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    itemCount: adiciones.length,
                    itemBuilder: (BuildContext context, int index) {
                      String imageUrl =
                          (adiciones[index]['imagenInsumo'] ?? '').trim();
                      print('URL de la imagen: $imageUrl');

                      String nombreInsumo =
                          adiciones[index]['nombreInsumo'] ?? '';

                      return CustomCard(
                        key: UniqueKey(),
                        imageUrl: imageUrl,
                        title: nombreInsumo,
                        subtitle:
                            'Cantidad: ${adiciones[index]['cantidadInsumo']}',
                        usos:
                            'Usos disponibles: ${adiciones[index]['usosDisponibles']}',
                        buttonText: 'Seleccionar',
                        onPressed: () {
                          // Acción cuando se presiona el botón de adición
                          // Aquí puedes implementar la lógica para seleccionar la adición
                        },
                      );
                    },
                  ),
                ),
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
}

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}

class CustomCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String usos;
  final String buttonText;
  final VoidCallback onPressed;

  const CustomCard({
    required Key key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
    required this.usos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Container(
        width:
            200, // Anchura de la Card (puedes ajustar este valor si lo deseas)
        height:
            300, // Altura de la Card (puedes ajustar este valor para hacerla más grande)
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(230, 166, 201,
                  235), // Color en la parte superior (azul aclarado)
              Color.fromARGB(184, 189, 220, 227), // Color en el 40%
              Color.fromARGB(255, 234, 236, 236), // Color en el 20%
            ],
            stops: [0.0, 0.5, 0.8], // Paradas de los colores
          ),
        ),

        padding: EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Container(
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
                    child: ClipOval(
                      child: Image.network(
                        imageUrl, // URL de la imagen
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Manejo de errores si la carga de la imagen falla
                          return const Icon(Icons.people);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5), // Espacio entre la imagen y el texto
                Text(
                  title, // Título de la tarjeta
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  subtitle, // Subtítulo de la tarjeta
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10), // Espacio entre el precio y el botón
                SizedBox(
                  width: double
                      .infinity, // Ajustar el ancho del contenedor al ancho de la tarjeta
                  child: ElevatedButton(
                    onPressed: onPressed, // Función al presionar el botón
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20), // Ajustar el padding del botón
                    ),
                    child: Text(
                      buttonText, // Texto del botón
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.white, // Cambiar el color del texto a blanco
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
