//interfazMyTutorias.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterfazMyTutorias extends StatefulWidget {
  final int? userId;

  InterfazMyTutorias([this.userId]);

  @override
  _InterfazMyTutoriasState createState() => _InterfazMyTutoriasState();
}

class _InterfazMyTutoriasState extends State<InterfazMyTutorias> {
  List _myTutorias = [];

  @override
  void initState() {
    super.initState();
    _fetchMyTutorias();
  }

  Future<void> _fetchMyTutorias() async {
    final response = await http.get(Uri.parse(
        'http//localhost/tutormeup/obtener_misTutorias.php?user_id=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        _myTutorias = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load my tutorias');
    }
  }

  Future<void> _registrarMiTutoria(String horario, String aula) async {
    final response = await http.post(
        Uri.parse(
            'http://localhost/tutormeup/registrar_miTutoria.php?user_id=${widget.userId}'),
        body: {
          'user_id': widget.userId.toString(),
          'horario': horario,
          'aula': aula,
        });

    if (response.body == 'Su tutoria ha sido registrada') {
      // Actualizamos la lista de tutorias.
      _fetchMyTutorias();
    } else {
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mis tutorias',
          style: TextStyle(
              fontFamily: 'SF-Pro-Rounded',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xFF004BAD),
      ),
      body: Column(
        children: [
          Expanded(
            child: _myTutorias.isEmpty
                ? Center(
                    child: Text(
                    '¡Aún no tienes ninguna tutoría publicada! 🤔',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004BAD)),
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
                    itemCount: _myTutorias.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_myTutorias[index]['nombre']),
                        subtitle: Text(_myTutorias[index]['descripcion']),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              onPressed: () {
                _showRegisterDialog();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF004BAD),
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                      fontSize: 25,
                      fontFamily: 'SF-Pro-Text',
                      fontWeight: FontWeight.w600)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_rounded,
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text('Publicar tutoría'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog() {
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Registrar Tutoria'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _registrarMiTutoria(
                    tituloController.text, descripcionController.text);
                Navigator.of(context).pop();
              },
              child: Text('Registrar'),
            ),
          ],
        );
      },
    );
  }
}
