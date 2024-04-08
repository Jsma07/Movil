import 'package:flutter/material.dart';
import 'package:primer_proyecto/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Iniciar la animación cuando se complete la construcción inicial del widget
    _animationController.forward().then((_) {
      // Redirigir a la página principal luego de completar la animación
      Navigator.pushReplacement(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => const Principal()),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _animationController.drive(
            CurveTween(curve: Curves.easeInOut),
          ),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey, // Color del borde
                width: 2, // Grosor del borde
              ),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pinimg.com/736x/f7/ce/e0/f7cee01bc6f7ebb3b40db04ed2d33904.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'salon_manicura.db'),
      version: 1,
    );
  }

  Future<bool> _validateCredentials(String email, String password) async {
    try {
      if (_database == null) return false;

      final List<Map<String, dynamic>> results = await _database!.query(
        'Administrador',
        where: 'correo = ? AND contrasena = ?',
        whereArgs: [email, password],
      );

      print('Resultados de la consulta: $results');

      return results.isNotEmpty;
    } catch (e) {
      print('Error al ejecutar la consulta: $e');
      return false;
    }
  }

  bool validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return false; // Uno o ambos campos están vacíos
    }
    return true; // Ambos campos tienen datos
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                'https://i.pinimg.com/474x/1a/3a/2c/1a3a2c61595912ba6458a7f4428a2683.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 52, 177, 239),
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://i.pinimg.com/736x/f7/ce/e0/f7cee01bc6f7ebb3b40db04ed2d33904.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: 310,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 26, 23, 23)
                                  .withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 52, 177, 239),
                                  disabledBackgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 70,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 10,
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 26),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: 'Correo Electrónico',
                                  prefixIcon: Icon(Icons.email),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  prefixIcon: Icon(Icons.lock),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Roboto',
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                ),
                              ),
                              const SizedBox(height: 50),
                              ElevatedButton(
                                onPressed: () async {
                                  if (validateInputs()) {
                                    final String email =
                                        emailController.text.trim();
                                    final String password =
                                        passwordController.text.trim();

                                    final bool isValid =
                                        await _validateCredentials(
                                            email, password);

                                    if (isValid) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyHomePage()),
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Error'),
                                            content: Text(
                                                'Credenciales incorrectas. Por favor, inténtalo de nuevo.'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cerrar'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text(
                                              'Por favor, completa todos los campos.'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cerrar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 66, 195, 241),
                                  disabledBackgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 70,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 10,
                                ),
                                child: const Text(
                                  'Iniciar sesión',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '¿Olvidó su contraseña? ',
                                  ),
                                  Text(
                                    'Recuperar',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duración de la animación
    )..repeat(
        reverse:
            true); // Repetir la animación en un bucle hacia adelante y hacia atrás
  }

  @override
  void dispose() {
    _animationController.dispose(); // Liberar recursos
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://i.pinimg.com/474x/61/a8/ac/61a8ac947b4fe201e4dcec10d66f5680.jpg',
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Manicure Bienvenido',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    'https://i.pinimg.com/736x/f7/ce/e0/f7cee01bc6f7ebb3b40db04ed2d33904.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 60,
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        0.0,
                        10.0 *
                            _animationController
                                .value), // Mover el botón verticalmente
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        disabledBackgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 30),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Iniciar Sesión',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
