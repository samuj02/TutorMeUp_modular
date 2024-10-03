import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:TutorMeUp/services/storage_service.dart';

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
    //Obtenemos el id del tutor/usuario
    String? tutorIdStoraged = await StorageService.getUserId();
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('solicitudes')
          .where('tutor_id', isEqualTo: tutorIdStoraged)
          .get();

      setState(() {
        _solicitudes = querySnapshot.docs;
      });
    } catch (e) {
      print('Error fetching solicitudes: $e');
    }
  }

  Future<String?> _obtenerNombreUsuario(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['nombre'];  // Aquí asumimos que el campo es "nombre"
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
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
        backgroundColor: Color(0xFF00ADA1),
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
                        color: Color(0xFF00ADA1)),
                    textAlign: TextAlign.center,
                  ))
                : ListView.builder(
                    itemCount: _solicitudes.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<String?>(
                        future: _obtenerNombreUsuario(
                            _solicitudes[index]['user_id']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error al cargar el nombre');
                          } else {
                            return _buildSolicitudCard(
                                _solicitudes[index], snapshot.data);
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudCard(DocumentSnapshot solicitud, String? nombreUsuario) {
    final String titulo = solicitud['titulo'] ?? 'Sin título';
    final String descripcion = solicitud['descripcion'] ?? 'Sin descripción';
    final String userNombre = nombreUsuario ?? 'Usuario desconocido';

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
            // Mostrar el nombre del usuario
            Text(
              'Usuario: $userNombre',
              style: TextStyle(
                fontFamily: 'SF-Pro-Text',
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _rechazarSolicitud(solicitud),
                  child: Text(
                    'Rechazar',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Text', fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFFB000D),
                    foregroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 15.0),
                ElevatedButton(
                  onPressed: () => _aceptarSolicitud(solicitud),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(
                        fontFamily: 'SF-Pro-Text', fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF14D800),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
