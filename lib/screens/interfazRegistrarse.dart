import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importar Firestore
import 'package:TutorMeUp/screens/customTextField.dart';
import 'package:TutorMeUp/services/storage_service.dart';
import 'package:TutorMeUp/services/validaciones.dart';

class PantallaRegistrarse extends StatefulWidget {
  @override
  _PantallaRegistrarseState createState() => _PantallaRegistrarseState();
}

class _PantallaRegistrarseState extends State<PantallaRegistrarse> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _carreraController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  bool _ocultarPassword = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _register() async {
    try {
      // Crear un nuevo documento en la colección "user"
      DocumentReference docRef = await _firestore.collection('user').add({
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'carrera': _carreraController.text,
        'telefono': int.parse(_telefonoController.text),
        'imagen_perfil': '',
        'user_id': DateTime.now()
            .millisecondsSinceEpoch, // Generar un ID único basado en el tiempo
      });

      // Obtener el ID del documento recién creado
      String userId = docRef.id;

      // Guardar el ID del usuario en SharedPreferences
      await StorageService.saveUserId(userId);
      print("Me registré con: $userId");
      /* SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userId); */

      // Limpiar los campos después del registro exitoso
      _nombreController.clear();
      _apellidoController.clear();
      _emailController.clear();
      _passwordController.clear();
      _carreraController.clear();
      _telefonoController.clear();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registrado exitosamente.',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,
                fontFamily: 'SF-Pro-Rounded',
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0xFF35FF69),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 25.0,
          margin: EdgeInsets.all(12.0),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Retrasar unos segundos para que se mire la SnackBar
      await Future.delayed(Duration(seconds: 3));

      // Navegar a la pantalla de inicio
      Navigator.pushReplacementNamed(context, '/inicio');
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(
          'Ocurrió un error al intentar registrar. Inténtelo de nuevo.');
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
                backgroundColor: Color(0xFF5575A0),
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear cuenta',
            style: TextStyle(
                fontFamily: 'SF-Pro-Rounded',
                fontSize: 26.0,
                fontWeight: FontWeight.w900)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCustomTextField(
                    controller: _nombreController,
                    labelText: 'Nombre(s)',
                    hintText: 'Ingrese su nombre:',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.label_important_rounded,
                    colorTheme: Color(0xFF5575A0)),
                SizedBox(height: 20),
                buildCustomTextField(
                    controller: _apellidoController,
                    labelText: 'Apellido(s)',
                    hintText: 'Ingrese su(s) apellido(s)',
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.label_important_rounded,
                    colorTheme: Color(0xFF5575A0)),
                SizedBox(height: 20),
                buildCustomTextField(
                    controller: _emailController,
                    labelText: 'Correo electrónico',
                    hintText: 'Ingrese su correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.alternate_email_rounded,
                    colorTheme: Color(0xFF5575A0)),
                SizedBox(height: 20),
                buildCustomTextField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  hintText: 'Ingrese su contraseña',
                  prefixIcon: Icons.password_rounded,
                  colorTheme: Color(0xFF5575A0),
                  obscureText: _ocultarPassword,
                  onIconPressed: () {
                    setState(() {
                      _ocultarPassword = !_ocultarPassword;
                    });
                  },
                ),
                SizedBox(height: 20),
                buildCustomTextField(
                    controller: _carreraController,
                    labelText: 'Carrera',
                    hintText: 'Ingrese su carrera universitaria',
                    prefixIcon: Icons.school_rounded,
                    colorTheme: Color(0xFF5575A0)),
                SizedBox(height: 20),
                buildCustomTextField(
                    controller: _telefonoController,
                    labelText: 'Teléfono',
                    hintText: 'Ingrese su número telefónico',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    colorTheme: Color(0xFF5575A0)),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    // Campos a validar
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String nombre = _nombreController.text;
                    String apellido = _apellidoController.text;
                    String carrera = _carreraController.text;
                    String phone = _telefonoController.text;

                    // Validamos todos los campos del registrar
                    if (nombre.isEmpty ||
                        apellido.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty ||
                        carrera.isEmpty ||
                        phone.isEmpty) {
                      _showErrorDialog("Por favor complete todos los campos.");
                      return;
                    }

                    // Validar correo:
                    if (!isValidEmail(email)) {
                      _showErrorDialog(
                          "Por favor ingrese un correo electrónico válido.");
                      return;
                    }
                    if (!isValidPassword(password)) {
                      _showErrorDialog(
                          "La contraseña debe tener al menos 8 caracteres, incluir una letra mayúscula y un símbolo especial.");
                      return;
                    }

                    if (await checkEmailExists(email)) {
                      _showErrorDialog(
                          "El correo electrónico ya está registrado.");
                      return;
                    }

                    if (!isValidPhoneNumber(_telefonoController.text)) {
                      _showErrorDialog(
                          "El número de teléfono debe contener exactamente 10 dígitos numéricos.");
                      return;
                    }

                    // SÍ todo es válido, registramos.
                    _register();
                  },
                  child: Text(
                    'Registrarse',
                    style: TextStyle(color: Colors.white, shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(128, 0, 0, 0),
                      )
                    ]),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5575A0), // Fondo del botón
                    shadowColor: Colors.black,
                    elevation: 8.0,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
    );
  }
}
