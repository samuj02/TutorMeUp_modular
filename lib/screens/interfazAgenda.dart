import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'interfazTutorias.dart'; // Asegúrate de importar la interfazTutorias.dart

class AgendaScreen extends StatefulWidget {
  final String? userId; // Cambié a String ya que los IDs de Firestore suelen ser cadenas

  AgendaScreen({this.userId});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<DocumentSnapshot> _agendadas = [];

  @override
  void initState() {
    super.initState();
    _fetchAgendadas();
  }

  Future<void> _fetchAgendadas() async {
    try {
      // Obtener las tutorías agendadas para el usuario actual en Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('agendas')
          .where('user_id', isEqualTo: widget.userId)
          .get();

      setState(() {
        _agendadas = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching agendadas: $e');
    }
  }

  Future<void> _cancelarTutoria(String tutoriaId) async {
    try {
      // Eliminar la tutoría agendada de Firestore
      await FirebaseFirestore.instance.collection('agendas').doc(tutoriaId).delete();
      // Volver a cargar las tutorías agendadas
      _fetchAgendadas();
    } catch (e) {
      print('Error canceling tutoria: $e');
    }
  }

  void _mostrarDialogoCancelar(String tutoriaId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('¿Estás seguro que quieres cancelar la tutoría?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _cancelarTutoria(tutoriaId);
                Navigator.of(context).pop();
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToBuscarTutorias() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InterfazTutorias(userId: widget.userId, materiaBuscada: 'Matemáticas'),
      ),
    );
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
            child: _agendadas.isEmpty
                ? Center(
                    child: Text(
                    '¡No tienes tutorías agendadas! 🤔',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A6CAD)),
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
                    itemCount: _agendadas.length,
                    itemBuilder: (context, index) {
                      return _buildAgendadaCard(_agendadas[index]);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _navigateToBuscarTutorias,
              child: Text('Buscar Tutoría'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3A6CAD),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(
                  fontFamily: 'SF-Pro-Text',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgendadaCard(DocumentSnapshot agendada) {
    final String titulo = agendada['titulo'] ?? 'Sin título';
    final String descripcion = agendada['descripcion'] ?? 'Sin descripción';
    final String tutoriaId = agendada.id;

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
            Text(
              'Fecha y hora: ${agendada['timestamp'].toDate().toString()}',
              style: TextStyle(
                fontFamily: 'SF-Pro-Text',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _mostrarDialogoCancelar(tutoriaId),
                child: Text('Cancelar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontFamily: 'SF-Pro-Text',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
