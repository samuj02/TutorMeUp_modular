import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class InterfazMiPerfil extends StatefulWidget {
  final String userId;
  InterfazMiPerfil({required this.userId});

  @override
  State<InterfazMiPerfil> createState() => _InterfazMiPerfil();
}

class _InterfazMiPerfil extends State<InterfazMiPerfil> {
  Map<String, dynamic> userData = {};
  File? _imagen;
  bool _isLoading = true;
  bool _isEditing = false;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .get();

      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      } else {
        throw Exception('Usuario no encontrado');
      }
    } catch (e) {
      print('Error al cargar los datos del usuario: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _escogerImagen() async {
    // Código para seleccionar la imagen desde la galería
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagen = File(pickedFile.path);
      });
      _cargarImagen(_imagen!);
    }
  }

  Future<void> _cargarImagen(File image) async {
    try {
      String fileName = 'profile_pictures/${widget.userId}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(image);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .update({'imagen_perfil': downloadUrl});

      setState(() {
        userData['imagen_perfil'] = downloadUrl;
      });
    } catch (e) {
      print('Error al cargar la imagen: $e');
    }
  }

  void _enableEditing() {
    setState(() {
      _isEditing = true;
      _nombreController.text = userData['nombre'] ?? '';
      _apellidoController.text = userData['apellido'] ?? '';
      _emailController.text = userData['email'] ?? '';
      _carreraController.text = userData['carrera'] ?? '';
      _telefonoController.text = userData['telefono'] ?? '';
    });
  }

  void _saveChanges() async {
    Map<String, dynamic> updatedData = {
      'nombre': _nombreController.text,
      'apellido': _apellidoController.text,
      'email': _emailController.text,
      'carrera': _carreraController.text,
      'telefono': _telefonoController.text,
    };

    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.userId)
          .update(updatedData);

      setState(() {
        userData = updatedData;
        _isEditing = false;
      });

      print("Datos actualizados: $userData");
    } catch (e) {
      print('Error al actualizar los datos en Firestore: $e');
    }
  }

  Widget _buildTextField(
      IconData icon, String label, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label),
          ),
        ),
      ],
    );
  }

  Widget _buildUserDataRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '$label: $value',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_perfil.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    title: Text(
                      'Mi perfil',
                      style: TextStyle(
                        fontFamily: 'SF-Pro-Rounded',
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.all(20.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 32.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Color(0xFFAAC2E3),
                                            radius: 80.0,
                                            backgroundImage: userData[
                                                        'imagen_perfil'] !=
                                                    null
                                                ? CachedNetworkImageProvider(
                                                    userData['imagen_perfil']
                                                        as String,
                                                  )
                                                : null,
                                            child: userData['imagen_perfil'] ==
                                                    null
                                                ? Icon(
                                                    Icons.person_2_rounded,
                                                    size: 70.0,
                                                    color: Colors.black,
                                                  )
                                                : null,
                                          ),
                                          Positioned(
                                            bottom: 0.0,
                                            right: 0.0,
                                            child: GestureDetector(
                                              onTap: _escogerImagen,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 2),
                                                ),
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.edit_rounded,
                                                  color: Colors.black,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20.0),
                                      Text(
                                        "${userData['nombre'] ?? ''} ${userData['apellido'] ?? ''}",
                                        style: TextStyle(
                                          fontFamily: 'SF-Pro-Display',
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 50.0),
                              Container(
                                padding: const EdgeInsets.all(20.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3),
                                      )
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Mis datos',
                                        style: TextStyle(
                                          fontFamily: 'SF-Pro-Rounded',
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    _isEditing
                                        ? Column(
                                            children: [
                                              _buildTextField(
                                                  Icons.person_2_rounded,
                                                  "Nombre(s)",
                                                  _nombreController),
                                              _buildTextField(
                                                  Icons.person_2_outlined,
                                                  "Apellido(s)",
                                                  _apellidoController),
                                              _buildTextField(Icons.email_rounded,
                                                  "Correo", _emailController),
                                              _buildTextField(
                                                  Icons.school_rounded,
                                                  "Carrera",
                                                  _carreraController),
                                              _buildTextField(
                                                  Icons.phone_rounded,
                                                  "Teléfono",
                                                  _telefonoController),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: _saveChanges,
                                                    child: Text(
                                                      'Guardar cambios',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SF-Pro-Text',
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFFFFE74C),
                                                            shadowColor: Colors
                                                                .black,
                                                            elevation: 20.0,
                                                            foregroundColor:
                                                                Colors.black),
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isEditing = false;
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Color(
                                                                    0xFFFF934F),
                                                            shadowColor: Colors
                                                                .black,
                                                            elevation: 20.0,
                                                            foregroundColor:
                                                                Colors.white),
                                                    child: Text('Cancelar',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'SF-Pro-Text',
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              _buildUserDataRow(
                                                  Icons.person_2_rounded,
                                                  "Nombre(s)",
                                                  userData['nombre']
                                                      as String?),
                                              _buildUserDataRow(
                                                  Icons.person_2_outlined,
                                                  "Apellido(s)",
                                                  userData['apellido']
                                                      as String?),
                                              _buildUserDataRow(
                                                  Icons.email_rounded,
                                                  "Correo",
                                                  userData['email'] as String?),
                                              _buildUserDataRow(
                                                  Icons.school_rounded,
                                                  "Carrera",
                                                  userData['carrera']
                                                      as String?),
                                              _buildUserDataRow(
                                                  Icons.phone_rounded,
                                                  "Teléfono",
                                                  userData['telefono']
                                                      as String?),
                                              SizedBox(height: 5.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _isEditing = true;
                                                        _nombreController.text =
                                                            userData['nombre']
                                                                as String? ??
                                                                '';
                                                        _apellidoController.text =
                                                            userData['apellido']
                                                                as String? ??
                                                                '';
                                                        _emailController.text =
                                                            userData['email']
                                                                as String? ??
                                                                '';
                                                        _carreraController.text =
                                                            userData['carrera']
                                                                as String? ??
                                                                '';
                                                        _telefonoController
                                                                .text =
                                                            userData['telefono']
                                                                as String? ??
                                                                '';
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Color(0xFF3D75E4),
                                                      shadowColor: Colors
                                                          .black,
                                                      elevation: 20.0,
                                                      foregroundColor:
                                                          Colors.white,
                                                    ),
                                                    child: Text(
                                                      'Editar datos',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'SF-Pro-Text',
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                ],
                              ),
                              ),
                            ],
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
