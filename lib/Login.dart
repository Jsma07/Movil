import 'package:flutter/material.dart';
import 'package:primer_proyecto/main.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:primer_proyecto/Databasehelper.dart'; // Ruta correcta a tu archivo Databasehelper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();

  static void destroySession(BuildContext context) {
    _LoginState()._destroySession(context);
  }
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _destroySession(BuildContext context) {
    // Limpiar los controladores de texto
    print('Sesión cerrada');
    emailController.clear();
    passwordController.clear();

    // Redirigir a la página 'Principal' al cerrar sesión
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const Principal()), // Asegúrate de que 'Principal' sea la clase correcta
      (Route<dynamic> route) => false, // Eliminar todas las demás rutas
    );
  }

  bool validateInputs() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  Future<void> _login() async {
    if (validateInputs()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final String? token = await _databaseHelper.login(email, password);

      if (token != null) {
        print('Token recibido, redirigiendo a MyHomePage.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const MyHomePage()), // Redirige a MyHomePage
        );
      } else {
        print('Credenciales incorrectas.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Credenciales incorrectas.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print('Campos vacíos.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Por favor, completa todos los campos.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          );
        },
      );
    }
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
                            'https://i.pinimg.com/736x/d5/8a/f4/d58af48f25d5a8df2854463c83e2f2e8.jpg',
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
                              TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
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
                                decoration: const InputDecoration(
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
                                  await _login(); // Llamar al método _login
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
                              const Row(
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

  void _destroySession(BuildContext context) {
    // Limpiar los controladores de texto

    print('sesion cerrada');

    // Redirigir a la página 'Principal' al cerrar sesión
    Navigator.pushReplacement(
      context as BuildContext,
      MaterialPageRoute(builder: (context) => const Principal()),
    );
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
                    'https://i.pinimg.com/736x/d5/8a/f4/d58af48f25d5a8df2854463c83e2f2e8.jpg',
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
                        // Destruir la sesión al presionar el botón
                        _destroySession(context);
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
