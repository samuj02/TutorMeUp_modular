import 'package:flutter/material.dart';

class TutoriasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorias'),
      ),
      body: Center(
        child: Text(
          'Poner tabla de tutorias disponibles',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
