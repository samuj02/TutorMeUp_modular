import 'package:flutter/material.dart';
import 'interfazInicioSesion.dart'; // Importa la interfaz de inicio de sesión
import 'interfazRegistrarse.dart'; // Importar la interfaz de Registro

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
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TutorMeUp'),
      ),
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '¡Bienvenido!',
              style: TextStyle(fontSize: 40.0),
            ),
            SizedBox(height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/inicioSesion');
                    },
                    child: const Text('Iniciar Sesión'),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registrarse');
                    },
                    child: const Text('Registrarse'),
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
