import 'package:flutter/material.dart';
import 'package:TutorMeUp/screens/interfazMiPerfil.dart';
import 'package:TutorMeUp/screens/logout.dart';

void showCustomMenu(BuildContext context) {
  String selectedItem = '';

  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      100.0, // X position (ajustar)
      100.0, // Y position (ajustar)
      0.0, // Width offset
      0.0, // Height offset
    ),
    items: <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'profile',
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Material(
              color: Colors.transparent, // Color del fondo del menú
              child: InkWell(
                onTap: () {
                  selectedItem = 'profile';
                  Navigator.pop(context, 'profile');
                  setState(
                      () {}); // Actualiza el estado para reflejar el cambio
                },
                splashColor: Colors.blue.withOpacity(0.3), // Color del splash
                highlightColor:
                    Colors.blue.withOpacity(0.2), // Color del highlight
                child: Container(
                  color: selectedItem == 'profile'
                      ? Colors.blue.withOpacity(
                          0.2) // Color de fondo cuando se selecciona
                      : Colors.transparent, // Color de fondo por defecto
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_2_rounded,
                        color: Colors.black,
                        size: 30.0,
                      ), // Icono para 'Mi Perfil'
                      SizedBox(width: 8), // Espacio entre el icono y el texto
                      Text(
                        'Mi Perfil',
                        style: TextStyle(
                          fontFamily: 'SF-Pro-Text',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      PopupMenuItem<String>(
        value: 'logout',
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Material(
              color: Colors.transparent, // Color del fondo del menú
              child: InkWell(
                onTap: () {
                  selectedItem = 'logout';
                  Navigator.pop(context, 'logout');
                  setState(
                      () {}); // Actualiza el estado para reflejar el cambio
                },
                splashColor: Colors.blue.withOpacity(0.3), // Color del splash
                highlightColor:
                    Colors.blue.withOpacity(0.2), // Color del highlight
                child: Container(
                  color: selectedItem == 'logout'
                      ? Colors.blue.withOpacity(
                          0.2) // Color de fondo cuando se selecciona
                      : Colors.transparent, // Color de fondo por defecto
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.logout_rounded,
                        color: Colors.black,
                        size: 30.0,
                      ), // Icono para Cerrar sesión
                      SizedBox(width: 8), // Espacio entre el icono y el texto
                      Text(
                        'Cerrar sesión',
                        style: TextStyle(
                          fontFamily: 'SF-Pro-Text',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ],
    elevation: 8.0,
    color: Colors.white, // Color de fondo del menú desplegable
  ).then((String? value) {
    if (value != null) {
      if (value == 'profile') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => InterfazMiPerfil()), // Pasa el userId aquí
        );
      } else if (value == 'logout') {
        LogoutService().logout(context);
      }
    }
  });
}
