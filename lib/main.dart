import 'package:flutter/material.dart';

void main() {
  runApp(TutorMeUpApp());
}

class TutorMeUpApp extends StatelessWidget {
  const TutorMeUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorMeUp',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TutorMeUp'),
        ),
        backgroundColor: Colors.blue, // Cambia el color de fondo aquí
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Alinea verticalmente al centro
            children: <Widget>[
              Text(
                '¡Bienvenido!',
                style: TextStyle(fontSize: 40.0),
              ),
              SizedBox(height: 100), // Agrega un espacio entre el texto y los botones
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Alinea horizontalmente al centro
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Agrega aquí la lógica para manejar el botón
                    },
                    child: const Text('Iniciar Sesion'),
                  ),
                  SizedBox(width: 20), // Agrega un espacio entre los botones
                  ElevatedButton(
                    onPressed: () {
                      // Agrega aquí la lógica para manejar el botón
                    },
                    child: const Text('Registrarse'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
