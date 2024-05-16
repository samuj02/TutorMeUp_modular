import 'package:flutter/material.dart';
import 'interfazInicioSesion.dart'; // Importa la interfaz de inicio de sesión
import 'interfazRegistrarse.dart'; // Importar la interfaz de Registro
import 'inicioApp.dart'; 

void main() {
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
        '/inicioSesion': (context) => PantallaInicioSesion(),
        '/registrarse': (context) => PantallaRegistrarse(),
        '/home': (context) => TutorMeUpApp(),
        '/inicio': (context) => InicioApp(),
        //'/tutorias': (context) => TutoriasScreen(),
        //'/agenda': (context) => AgendaScreen(),
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
                  '¡TutorMeApp!',
                  style: TextStyle(
                    fontSize: 40.0,
                    color: const Color.fromARGB(255, 5, 5, 5),
                    fontWeight: FontWeight.bold,
                  ),
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
                        child: const Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Colors.black, // Color del texto del botón
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Color del botón
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
                            color: Colors.black, // Color del texto del botón
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Color del botón
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