import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InterfazMiPerfil extends StatefulWidget {
  final String userId;

  InterfazMiPerfil(this.userId);

  @override
  _InterfazMiPerfilState createState() => _InterfazMiPerfilState();
}

class _InterfazMiPerfilState extends State<InterfazMiPerfil> {
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
      setState(() {
        userData = {};
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: userData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nombre: ${userData['nombre'] ?? 'No disponible'} ${userData['apellido'] ?? 'No disponible'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Carrera: ${userData['carrera'] ?? 'No disponible'}',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'User ID: ${widget.userId}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
      ),
    );
  }
}
