import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modular2/screens/customTextField.dart';
import 'package:modular2/screens/interfazAddChooseMateria.dart';
import 'package:modular2/services/storage_service.dart';

class RegistrarTutoria extends StatefulWidget {
  final String?
      userId; // Cambié int? a String? porque los IDs en Firestore suelen ser cadenas
  RegistrarTutoria([this.userId]);

  @override
  _RegistrarTutoriaState createState() => _RegistrarTutoriaState();
}

class _RegistrarTutoriaState extends State<RegistrarTutoria> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _aulaController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  void _continuarRegistro() async {
    if (_nombreController.text.isEmpty ||
        _aulaController.text.isEmpty ||
        _descripcionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete todos los campos.'),
        ),
      );
    } else {
      // Obtenemos el id del documento del usuario, para referenciar la tutoria
      String? storedUserId = await StorageService.getUserId();
      // Preparar los datos de la tutoría para guardarlos en Firestore
      Map<String, dynamic> datosTutoria = {
        'user_id': storedUserId,
        'titulo': _nombreController.text,
        'aula': _aulaController.text,
        'descripcion': _descripcionController.text,
        'timestamp': Timestamp.now(), // Agrega la fecha de creación
      };

      // Navegar a la pantalla de agregar/escoger materia
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddChooseMateria(datosTutoria),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Registrar tutoría',
          style: TextStyle(
            fontFamily: 'SF-Pro-Rounded',
            fontSize: 26.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  buildCustomTextField(
                    controller: _nombreController,
                    labelText: 'Título',
                    hintText: 'Ingrese el título de la tutoría:',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.title_rounded,
                  ),
                  SizedBox(height: 20),
                  buildCustomTextField(
                    controller: _aulaController,
                    labelText: 'Aula',
                    hintText: 'Ingrese el aula:',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.meeting_room,
                  ),
                  SizedBox(height: 20),
                  buildCustomTextField(
                    controller: _descripcionController,
                    labelText: 'Descripción',
                    hintText: 'Describa su tutoría:',
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 4,
                    prefixIcon: Icons.description_rounded,
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _continuarRegistro,
                    child: Text(
                      'Continuar',
                      style: TextStyle(color: Colors.white, shadows: [
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(128, 0, 0, 0),
                        )
                      ]),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF004AAD), // Fondo del botón
                      shadowColor: Colors.black,
                      elevation: 8.0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
