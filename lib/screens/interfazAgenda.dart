import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AgendaScreen extends StatefulWidget {
  final int? userId;

  AgendaScreen({this.userId});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List _tutorias = [];

  @override
  void initState() {
    super.initState();
    _fetchTutorias();
  }

  Future<void> _fetchTutorias() async {
    final response = await http.get(Uri.parse(
        'http://189.203.149.247/tutormeup/obtener_tutorias.php?user_id=${widget.userId}'));

    if (response.statusCode == 200) {
      setState(() {
        _tutorias = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load tutorias');
    }
  }

  Future<void> _registerTutoria(String titulo, String descripcion) async {
    final response = await http.post(
      Uri.parse('http://189.203.149.247/tutormeup/registrar_tutoria.php'),
      body: {
        'user_id': widget.userId.toString(),
        'titulo': titulo,
        'descripcion': descripcion,
      },
    );

    if (response.body == 'Tutoria registrada') {
      _fetchTutorias(); // Refresh the list
    } else {
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mi Agenda',
          style: TextStyle(
              fontFamily: 'SF-Pro-Rounded',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xFF3A6CAD),
      ),
      body: Column(
        children: [
          Expanded(
            child: _tutorias.isEmpty
                ? Center(
                    child: Text(
                    '¡Aún no tienes ninguna tutoría publicada! 🤔',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A6CAD)),
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
              itemCount: _tutorias.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_tutorias[index]['titulo']),
                  subtitle: Text(_tutorias[index]['descripcion']),
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
                  backgroundColor: Color(0xFF3A6CAD),
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
                _registerTutoria(
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
