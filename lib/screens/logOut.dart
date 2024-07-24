import 'package:flutter/material.dart';
import 'package:modular2/services/storage_service.dart'; // Asegúrate de importar tu servicio de almacenamiento

class LogoutService {
  Future<void> logout(BuildContext context) async {
    // Llamar al método para eliminar el userId guardado
    await StorageService.clearUserId();

    // Una vez damos click al Cerrar sesión, nos vamos a página principal.
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (Route<dynamic> route) => false,
    );
  }
}
