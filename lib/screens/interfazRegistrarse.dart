import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modular2/screens/customTextField.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _register() async {
    final response = await http.post(
      Uri.parse('http://localhost/tutormeup/register.php'),
      body: {
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'carrera': _carreraController.text,
        'telefono': _telefonoController.text,
      },
    );

    /* if (response.body == "Se ha registrado exitosamente") { */
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData['estado'] == 'exitoso') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', responseData['user_id']);
        // Limpiamos campos:
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
              'Registrado exitosamente. ID: ${responseData['user_id']}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: 'SF-Pro-Roneded',
                  fontWeight: FontWeight.w400),
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

        // Nos vamos a la screen de inicio.
        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
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
              responseData['mensaje'],
              style: TextStyle(
                  fontFamily: 'SF-Pro-Text',
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal),
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
    } else {
      print('Error: ${response.body}');
    }
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
                ),
                SizedBox(height: 20),
                buildCustomTextField(
                  controller: _apellidoController,
                  labelText: 'Apellido',
                  hintText: 'Ingrese su(s) apellido(s)',
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.label_important_rounded,
                ),
                SizedBox(height: 20),
                buildCustomTextField(
                  controller: _emailController,
                  labelText: 'Correo electrónico',
                  hintText: 'Ingrese su correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.alternate_email_rounded,
                ),
                SizedBox(height: 20),
                buildCustomTextField(
                  controller: _passwordController,
                  labelText: 'Contraseña',
                  hintText: 'Ingrese su contraseña',
                  prefixIcon: Icons.password_rounded,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                buildCustomTextField(
                  controller: _carreraController,
                  labelText: 'Carrera',
                  hintText: 'Ingrese su carrera universitaria',
                  prefixIcon: Icons.school_rounded,
                ),
                SizedBox(height: 20),
                buildCustomTextField(
                  controller: _telefonoController,
                  labelText: 'Teléfono',
                  hintText: 'Ingrese su número telefónico',
                  prefixIcon: Icons.phone,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _register,
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
                    backgroundColor: Color(0xFF004AAD), // Fondo del botón
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

  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Cuenta'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildCustomTextField(
                  controller: _nombreController,
                  labelText: 'Nombres(s)',
                  hintText: 'Ingrese su nombre:',
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.label_important_rounded),
              SizedBox(height: 20),
              buildCustomTextField(
                  controller: _apellidoController,
                  labelText: 'Apellido',
                  hintText: 'Ingrese su(s) apellido(s)',
                  keyboardType: TextInputType.name,
                  prefixIcon: Icons.label_important_rounded),
              SizedBox(height: 20),
              buildCustomTextField(
                  controller: _emailController,
                  labelText: 'Correo electrónico',
                  hintText: 'Ingrese su correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.alternate_email_rounded),
              SizedBox(height: 20),
              buildCustomTextField(
                controller: _passwordController,
                labelText: 'Contraseña',
                hintText: 'Ingrese su contraseña',
                prefixIcon: Icons.password_rounded,
                obscureText: true,
              ),
              SizedBox(height: 20),
              buildCustomTextField(
                controller: _carreraController,
                labelText: 'Carrera',
                hintText: 'Ingrese su carrera universitaria',
                prefixIcon: Icons.school_rounded,
              ),
              SizedBox(height: 20),
              buildCustomTextField(
                controller: _telefonoController,
                labelText: 'Teléfono',
                hintText: 'Ingrese su número telefónico',
                prefixIcon: Icons.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  } */
}


/* import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/tutormeup/register.php'),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey('userId')) {
        final userId = data['userId'];
        // Guarda el ID en shared_preferences
        await StorageService.saveUserId(userId);
        // Navega a la vista de inicio o perfil
        Navigator.pushReplacementNamed(context, '/inicio');
      } else {
        // Maneja el error
        print('Error: ${data['error']}');
      }
    } else {
      // Maneja el error
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: registerUser,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
 */