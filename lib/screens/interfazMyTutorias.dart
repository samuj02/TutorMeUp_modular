import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterfazMyTutorias extends StatefulWidget {
  final String? userId; // Cambié a String para usar IDs de Firestore

  InterfazMyTutorias([this.userId]);

  @override
  _InterfazMyTutoriasState createState() => _InterfazMyTutoriasState();
}

class _InterfazMyTutoriasState extends State<InterfazMyTutorias> {
  List<DocumentSnapshot> _myTutorias = [];

  @override
  void initState() {
    super.initState();
    _fetchMyTutorias();
  }

  Future<void> _fetchMyTutorias() async {
    try {
      // Consultar las tutorías del usuario actual en Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tutorias')
          .where('user_id', isEqualTo: widget.userId)
          .get();

      setState(() {
        _myTutorias = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching tutorias: $e');
    }
  }

  Future<void> _registrarMiTutoria(String titulo, String descripcion) async {
    try {
      // Registrar una nueva tutoría en Firestore
      await FirebaseFirestore.instance.collection('tutorias').add({
        'user_id': widget.userId,
        'titulo': titulo,
        'descripcion': descripcion,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar la lista de tutorías después de registrar una nueva
      _fetchMyTutorias();
    } catch (e) {
      print('Error registering tutoria: $e');
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
                      return _buildTutoriaCard(_myTutorias[index]);
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

  Widget _buildTutoriaCard(DocumentSnapshot tutoria) {
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
              tutoria['titulo'],
              style: TextStyle(
                fontFamily: 'SF-Pro-Rounded',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3A6CAD),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Horario: ${tutoria['timestamp'].toDate().toString()}',
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
