import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:modular2/services/storage_service.dart';
import 'package:modular2/services/validaciones.dart';

class PantallaInicioSesion extends StatefulWidget {
  @override
  _PantallaInicioSesionState createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _ocultarPassword = true;
  bool _continueRegister = false;

  Future<void> _signIn() async {
    try {
      // Validamos si hay campos vacios
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        if (!isValidEmail(_emailController.text)) {
          _showErrorDialog("Formato de correo electrónico inválido.");
          return;
        } else {
          _continueRegister = true;
        }
      } else {
        _showErrorDialog("Por favor, llene todos los campos.");
      }
      if (_continueRegister) {
        // Intentar encontrar un documento en la colección "user" que tenga el mismo email
        QuerySnapshot querySnapshot = await _firestore
            .collection('user')
            .where('email', isEqualTo: _emailController.text)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // El usuario fue encontrado, ahora verificar la contraseña
          DocumentSnapshot userDoc = querySnapshot.docs.first;
          String storedPassword = userDoc['password'];

          if (storedPassword == _passwordController.text) {
            // Contraseña correcta, guardar el user_id en SharedPreferences
            String userId = userDoc.id; // ID del documento como user_id
            await StorageService.saveUserId(userId);
            print("Inicie sesión: $userId");
            /* SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('user_id', userId); */

            // Navegar a la pantalla de inicio
            Navigator.pushReplacementNamed(context, '/inicio');
          } else {
            _showErrorDialog('Contraseña incorrecta.');
          }
        } else {
          print("Email not founded.");
          _showErrorDialog('Correo electrónico no encontrado.');
        }
      }
    } catch (e) {
      _showErrorDialog('Ocurrió un error inesperado. Inténtelo de nuevo.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Error',
          style: TextStyle(
              fontFamily: 'SF-Pro-Display',
              fontSize: 24.0,
              fontWeight: FontWeight.w600),
        ),
        content: Text(
          message,
          style: TextStyle(
              fontFamily: 'SF-Pro-Text',
              fontSize: 20.0,
              fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                  fontFamily: 'SF-Pro-Text',
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF004AAD),
                foregroundColor: Colors.white,
                elevation: 16.0,
                shadowColor: Color.fromARGB(128, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Color(0xFF3A6CAD)),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/fondoInicioSesion.png',
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 100), // Añadido espacio superior
                        Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontFamily: 'SF-Pro-Display',
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 80),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            labelStyle: TextStyle(
                                fontFamily: 'SF-Pro-Text',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF004AAD)),
                            hintText: 'Ingrese su correo electrónico',
                            filled: true,
                            fillColor: Colors.transparent,
                            prefixIcon: Icon(
                              Icons.alternate_email_rounded,
                              size: 35.0,
                              color: Color(0xFF004AAD),
                            ),
                            contentPadding: EdgeInsets.only(
                                left: 30.0, top: 24.0, bottom: 20.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(128, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF004AAD)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'SF-Pro-Text',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: _passwordController,
                          obscureText: _ocultarPassword,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                                fontFamily: 'SF-Pro-Text',
                                fontSize: 20.0,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF004AAD)),
                            hintText: 'Ingrese su contraseña',
                            filled: true,
                            fillColor: Colors.transparent,
                            prefixIcon: Icon(
                              Icons.password_rounded,
                              size: 35.0,
                              color: Color(0xFF004AAD),
                            ),
                            suffixIcon: IconButton(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 12.0),
                                onPressed: () {
                                  setState(() {
                                    _ocultarPassword = !_ocultarPassword;
                                  });
                                },
                                icon: _ocultarPassword
                                    ? const Icon(
                                        Icons.visibility_rounded,
                                        size: 35.0,
                                        color: Color(0xFF004AAD),
                                      )
                                    : const Icon(
                                        Icons.visibility_off_rounded,
                                        size: 35.0,
                                        color: Color(0xFF004AAD),
                                      )),
                            contentPadding: EdgeInsets.only(
                                left: 30.0, top: 24.0, bottom: 20.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(128, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF004AAD)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: TextStyle(
                              fontFamily: 'SF-Pro-Text',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: _signIn,
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                                fontFamily: 'SF-Pro-Display',
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(128, 0, 0, 0),
                                  )
                                ]),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004AAD),
                            shadowColor: Colors.black,
                            elevation: 20.0,
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
