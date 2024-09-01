import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modular2/screens/interfazMiPerfil.dart';
import 'package:modular2/screens/interfazInicioSesion.dart';
import 'package:modular2/screens/interfazRegistrarse.dart';
import 'package:modular2/screens/interfazTutorias.dart';
import 'package:modular2/screens/interfazMyTutorias.dart';
import 'package:modular2/screens/interfazAgenda.dart';
import 'package:modular2/screens/inicioApp.dart';
import 'package:modular2/screens/interfazMapa.dart';
import 'package:modular2/screens/InterfazIA.dart';
import 'package:modular2/screens/InterfazRegistrarTutoria.dart';

void main() async {
  // Asegúrate de que los Widgets de Flutter estén inicializados antes de Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  runApp(TutorMeUpApp());
}

class TutorMeUpApp extends StatelessWidget {
  const TutorMeUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorMeUp',
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/inicioSesion': (context) => PantallaInicioSesion(),
        '/registrarse': (context) => PantallaRegistrarse(),
        '/inicio': (context) => InicioApp('user_id'), 
        '/tutorias': (context) => InterfazTutorias(),
        '/myTutorias': (context) => InterfazMyTutorias(),
        '/miPerfil': (context) => InterfazMiPerfil(userId: 'user_id'),
        '/agenda': (context) => AgendaScreen(),
        '/mapa': (context) => MapaScreen(),
        '/inteligenciaA': (context) => InterfazIA(),
        '/RegistrarTutoria': (context) => RegistrarTutoria(),

      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Imagen de fondo
          Image.asset(
            'assets/images/fondoInicio.png',
            fit: BoxFit.cover,
          ),
          // Contenido encima de la imagen
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '¡Bienvenido a Tutor Me Up!',
                  style: TextStyle(
                      fontFamily: 'PoetsenOne',
                      fontSize: 50.0,
                      color: const Color.fromARGB(255, 5, 5, 5),
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                            color: Color.fromARGB(128, 0, 0, 0)),
                      ]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 60),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/inicioSesion');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3D75E4),
                          shadowColor: Colors.black, // Color del botón
                          elevation: 20.0,
                        ),
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                              fontFamily: 'SF-Pro-Display',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(128, 0, 0, 0),
                                )
                              ] // Color del texto del botón
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/registrarse');
                        },
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(
                              fontFamily: 'SF-Pro-Display',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Color.fromARGB(128, 0, 0, 0),
                                )
                              ] // Color del texto del botón
                              ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5575A0), // Color del botón
                          shadowColor: Colors.black,
                          elevation: 20.0,
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
    );
  }
}
