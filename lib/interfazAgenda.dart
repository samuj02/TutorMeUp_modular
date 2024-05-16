import 'package:flutter/material.dart';

class AgendaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Agenda'),
      ),
      body: Center(
        child: Text(
          'Poner la agenda del alumno',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
