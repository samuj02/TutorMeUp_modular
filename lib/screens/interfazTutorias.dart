import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterfazTutorias extends StatefulWidget {
  final int? userId;

  InterfazTutorias([this.userId]);

  @override
  _InterfazTutoriasState createState() => _InterfazTutoriasState();
}

class _InterfazTutoriasState extends State<InterfazTutorias> {
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
        title: Text('Tutorias'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _showRegisterDialog();
              },
              child: Text('Publicar Tutoria'),
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
