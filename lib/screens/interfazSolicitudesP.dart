import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterfazSolicitudesP extends StatefulWidget {
  final String? tutorId;

  InterfazSolicitudesP({this.tutorId});

  @override
  _InterfazSolicitudesPState createState() => _InterfazSolicitudesPState();
}

class _InterfazSolicitudesPState extends State<InterfazSolicitudesP> {
  List<DocumentSnapshot> _solicitudes = [];

  @override
  void initState() {
    super.initState();
    _fetchSolicitudes();
  }

  Future<void> _fetchSolicitudes() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('solicitudes')
          .where('tutor_id', isEqualTo: widget.tutorId)
          .get();

      setState(() {
        _solicitudes = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching solicitudes: $e');
    }
  }

  Future<void> _aceptarSolicitud(DocumentSnapshot solicitud) async {
    try {
      // Mover la solicitud a la colección 'agendas'
      await FirebaseFirestore.instance.collection('agendas').add({
        'user_id': solicitud['user_id'],
        'tutoria_id': solicitud['tutoria_id'],
        'titulo': solicitud['titulo'],
        'descripcion': solicitud['descripcion'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Eliminar la solicitud de la colección 'solicitudes'
      await FirebaseFirestore.instance
          .collection('solicitudes')
          .doc(solicitud.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Tutoría aceptada con éxito!')),
      );

      // Recargar solicitudes
      _fetchSolicitudes();
    } catch (e) {
      print('Error al aceptar la solicitud: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al aceptar la solicitud')),
      );
    }
  }

  Future<void> _rechazarSolicitud(DocumentSnapshot solicitud) async {
    try {
      // Eliminar la solicitud de la colección 'solicitudes'
      await FirebaseFirestore.instance
          .collection('solicitudes')
          .doc(solicitud.id)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Solicitud rechazada')),
      );

      // Recargar solicitudes
      _fetchSolicitudes();
    } catch (e) {
      print('Error al rechazar la solicitud: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al rechazar la solicitud')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Solicitudes de Tutorías',
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
            child: _solicitudes.isEmpty
                ? Center(
                    child: Text(
                    'No tienes solicitudes pendientes 🤔',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0082AD)),
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
                    itemCount: _solicitudes.length,
                    itemBuilder: (context, index) {
                      return _buildSolicitudCard(_solicitudes[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudCard(DocumentSnapshot solicitud) {
    final String titulo = solicitud['titulo'] ?? 'Sin título';
    final String descripcion = solicitud['descripcion'] ?? 'Sin descripción';

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
                color: Color(0xFF0082AD),
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
                TextButton(
                  onPressed: () => _rechazarSolicitud(solicitud),
                  child: Text('Rechazar'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _aceptarSolicitud(solicitud),
                  child: Text('Aceptar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
