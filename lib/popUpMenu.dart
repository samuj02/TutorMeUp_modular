//popUpMenu.dart
import 'package:flutter/material.dart';

void showCustomMenu(BuildContext context) {
  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      100.0, // X position (ajusta según tus necesidades)
      100.0, // Y position (ajusta según tus necesidades)
      0.0, // Width offset
      0.0, // Height offset
    ),
    items: <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'profile',
        child: Row(
          children: <Widget>[
            Icon(Icons.person, color: Colors.black), // Icono para 'Mi Perfil'
            SizedBox(width: 8), // Espacio entre el icono y el texto
            Text('Mi Perfil'),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'logout',
        child: Row(
          children: <Widget>[
            Icon(Icons.logout_rounded,
                color: Colors.black), // Icono para 'Cerrar Sesión'
            SizedBox(width: 8), // Espacio entre el icono y el texto
            Text('Cerrar Sesión'),
          ],
        ),
      ),
    ],
    elevation: 8.0,
  ).then((String? value) {
    if (value != null) {
      if (value == 'profile') {
        // Lógica para 'Mi Perfil'
      } else if (value == 'logout') {
        // Lógica para 'Cerrar Sesión'
      }
    }
  });
}
