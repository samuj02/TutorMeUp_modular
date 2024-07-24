// inicioApp.dart
/* import 'package:flutter/material.dart';
import 'interfazMyTutorias.dart';
import 'interfazTutorias.dart';
import 'interfazAgenda.dart';
import 'popUpMenu.dart';

class InicioApp extends StatelessWidget {
  final int? userId;

  InicioApp([this.userId]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Inicio',
            style: TextStyle(
                fontFamily: 'SF-Pro-Rounded',
                fontSize: 26.0,
                fontWeight: FontWeight.w900)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.person_2_rounded),
              iconSize: 45.0,
              tooltip: 'Mi perfil',
              color: Colors.black,
              onPressed: () {
                showCustomMenu(context);
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InterfazMiPerfil())); */
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Número de columnas en la cuadrícula
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: <Widget>[
            _buildGridButton(context, 'Tutorias   Disponibles', Icons.school,
                Color(0xFF0082AD), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InterfazTutorias()),
              );
            }),
            _buildGridButton(
                context, 'Mi Agenda', Icons.calendar_today, Color(0xFF3A6CAD),
                () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgendaScreen()),
              );
            }),
            _buildGridButton(context, 'Solicitudes Pendientes',
                Icons.safety_divider, Color(0xFF00ADA1), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgendaScreen()),
              );
            }),
            _buildGridButton(
                context, 'Mis Tutorias', Icons.book, Color(0xFF004BAD), () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InterfazMyTutorias()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 50.0),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontFamily: 'SF-Pro-Rounded',
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
 */
// inicioApp.dart
import 'package:flutter/material.dart';
import 'interfazMyTutorias.dart';
import 'interfazTutorias.dart';
import 'interfazAgenda.dart';
import 'popUpMenu.dart';

class InicioApp extends StatelessWidget {
  final int? userId;

  InicioApp([this.userId]);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Ocultar la flecha de retroceso
          title: const Text('Inicio',
              style: TextStyle(
                  fontFamily: 'SF-Pro-Rounded',
                  fontSize: 26.0,
                  fontWeight: FontWeight.w900)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.person_2_rounded),
                iconSize: 45.0,
                tooltip: 'Mi perfil',
                color: Colors.black,
                onPressed: () {
                  showCustomMenu(context);
                  /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InterfazMiPerfil())); */
                },
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2, // Número de columnas en la cuadrícula
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: <Widget>[
              _buildGridButton(context, 'Tutorias   Disponibles', Icons.school,
                  Color(0xFF0082AD), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterfazTutorias()),
                );
              }),
              _buildGridButton(
                  context, 'Mi Agenda', Icons.calendar_today, Color(0xFF3A6CAD),
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgendaScreen()),
                );
              }),
              _buildGridButton(context, 'Solicitudes Pendientes',
                  Icons.safety_divider, Color(0xFF00ADA1), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgendaScreen()),
                );
              }),
              _buildGridButton(
                  context, 'Mis Tutorias', Icons.book, Color(0xFF004BAD), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InterfazMyTutorias()),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: Colors.white, size: 50.0),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontFamily: 'SF-Pro-Rounded',
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
