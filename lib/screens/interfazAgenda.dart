import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:modular2/screens/interfazTutorias.dart'; // Asegúrate de que esta importación sea correcta según la estructura de tu proyecto

class AgendaScreen extends StatefulWidget {
  final String? userId; // Cambié a String ya que los IDs de Firestore suelen ser cadenas

  AgendaScreen({this.userId});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<DocumentSnapshot> _tutorias = [];

  @override
  void initState() {
    super.initState();
    _fetchTutorias();
  }

  Future<void> _fetchTutorias() async {
    try {
      // Obtener todas las tutorías de la colección 'tutorias' en Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tutorias')
          .get();

      setState(() {
        _tutorias = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching tutorias: $e');
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
                      return _buildTutoriaCard(_tutorias[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
              onPressed: () {
                _navigateToBuscarTutorias();
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
                    Icons.search,
                    size: 30,
                  ),
                  SizedBox(width: 8),
                  Text('Buscar Tutorías'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutoriaCard(DocumentSnapshot tutoria) {
    // Asegúrate de que los campos existen y no son nulos
    final String titulo = tutoria['titulo'] ?? 'Sin título';
    final String descripcion = tutoria['descripcion'] ?? 'Sin descripción';
    final String userId = tutoria['user_id'] ?? 'Usuario desconocido';

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontFamily: 'SF-Pro-Rounded',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A6CAD),
              ),
            ),
            SizedBox(height: 8),
            Text(
              descripcion,
              style: TextStyle(
                fontFamily: 'SF-Pro-Text',
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Publicado por: $userId',
                  style: TextStyle(
                    fontFamily: 'SF-Pro-Text',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToBuscarTutorias() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InterfazTutorias(widget.userId), // Parámetro posicional
      ),
    );
  }
}
