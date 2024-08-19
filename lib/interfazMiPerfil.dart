//interfazMiPerfil.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterfazMiPerfil extends StatefulWidget {
  final int? userId;
  InterfazMiPerfil([this.userId]);

  @override
  State<InterfazMiPerfil> createState() => _InterfazMiPerfil();
}

class _InterfazMiPerfil extends State<InterfazMiPerfil> {
  //Almacenar los datos del get de la base de datos
  Map<String, String> userData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData(widget.userId);
  }

  Future<void> _fetchUserData(user_id) async {
    final response = await http.get(
      Uri.parse(
          'http//localhost/tutormeup/obtener_datosUsuario.php?user_id=${widget.userId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        userData = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar los datos del usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi perfil',
          style: TextStyle(
              fontFamily: 'SF-Pro-Rounded',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Ajusta el padding según tus necesidades
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mis datos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Espacio entre el título y los datos
            Text('Nombre: Juan Pérez'),
            Text('Correo: juan.perez@example.com'),
            Text('Edad: 30'),
            // Agrega más datos según sea necesario
          ],
        ),
      ),
    );
  }
}
//class InterfazMiPerfil extends State
