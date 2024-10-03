import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TutorMeUp/services/storage_service.dart';

class InterfazTutorias extends StatefulWidget {
  final String? userId;

  InterfazTutorias([this.userId]);

  @override
  _InterfazTutoriasState createState() => _InterfazTutoriasState();
}

class _InterfazTutoriasState extends State<InterfazTutorias> {
  List<DocumentSnapshot> _tutorias = [];

  @override
  void initState() {
    super.initState();
    _fetchTutorias();
  }

  Future<void> _fetchTutorias() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('tutorias').get();

      setState(() {
        _tutorias = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching tutorias: $e');
    }
  }

  Future<void> _solicitarTutoria(DocumentSnapshot tutoria) async {
    //Obtenemos el id del tutor/usuario
    String? userIdStoraged = await StorageService.getUserId();
    try {
      await FirebaseFirestore.instance.collection('solicitudes').add({
        'user_id': userIdStoraged,
        'tutoria_id': tutoria.id,
        'tutor_id': tutoria['user_id'], // ID del tutor
        'titulo': tutoria['titulo'],
        'descripcion': tutoria['descripcion'],
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Solicitud enviada con éxito!')),
      );
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar la solicitud')),
      );
    }
  }

  void _mostrarDetallesTutoria(BuildContext context, DocumentSnapshot tutoria) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tutoria['titulo']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Descripción:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(tutoria['descripcion']),
              SizedBox(height: 16),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar",
                  style: TextStyle(
                      fontFamily: 'SF-Pro-Text', fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Solicitar",
                  style: TextStyle(
                      fontFamily: 'SF-Pro-Text', fontWeight: FontWeight.w600)),
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFFFB400),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await _solicitarTutoria(tutoria);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todas las Tutorías',
          style: TextStyle(
              fontFamily: 'SF-Pro-Rounded',
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800),
        ),
        backgroundColor: Color(0xFF0082AD),
      ),
      body: Column(
        children: [
          Expanded(
            child: _tutorias.isEmpty
                ? Center(
                    child: Text(
                    '¡No hay tutorías disponibles! 🤔',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0082AD)),
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
                    itemCount: _tutorias.length,
                    itemBuilder: (context, index) {
                      return _buildTutoriaCard(_tutorias[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutoriaCard(DocumentSnapshot tutoria) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _mostrarDetallesTutoria(context, tutoria),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tutoria['titulo'],
                style: TextStyle(
                  fontFamily: 'SF-Pro-Rounded',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0082AD),
                ),
              ),
              SizedBox(height: 8),
              Text(
                tutoria['descripcion'],
                style: TextStyle(
                  fontFamily: 'SF-Pro-Text',
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
