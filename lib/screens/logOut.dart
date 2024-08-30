import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Authentication

class LogoutService {
  Future<void> logout(BuildContext context) async {
    try {
      // Cierra la sesión de Firebase
      await FirebaseAuth.instance.signOut();

      // Una vez damos click al Cerrar sesión, nos vamos a la página principal.
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error al cerrar sesión: $e");
      // Mostrar un mensaje de error si es necesario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cerrar sesión. Inténtalo de nuevo.'),
        ),
      );
    }
  }
}
