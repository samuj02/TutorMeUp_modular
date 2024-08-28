import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PantallaInicioSesion extends StatefulWidget {
  @override
  _PantallaInicioSesionState createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost/tutormeup/login.php'),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      print(
          'Response body: ${response.body}'); // Añadir esta línea para ver la respuesta en la consola

      // Obtenemos la respuesta de PHP
      // y decodificamos en formato json
      final responseData = json.decode(response.body);

      if (responseData['estado'] == 'exitoso') {
        final int userId = responseData['user_id'];

        //Guardamos el ID logeado
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', userId);

        Navigator.pushReplacementNamed(context, '/inicio'
            //MaterialPageRoute(builder: (context) => InicioApp()),
            );
      } else if (responseData['estado'] == 'errorIncorrectPass') {
        // Credenciales incorrectas
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
              'Usuario y/o contraseña son incorrectos',
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
      } else if (responseData['estado'] == 'errorDatosMal') {
        // Incorrecto el usuario en este caso el email xd XD
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
              'Usuario y/o contraseña son incorrectos',
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
      } else {
        // Incorrecto el usuario en este caso el email xd XD
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Faltan datos',
              style: TextStyle(
                  fontFamily: 'SF-Pro-Display',
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Por favor, ingrese correo y contraseña',
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
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Ocurrió un error al intentar iniciar sesión.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Imagen de fondo
          Image.asset(
            'assets/images/fondoInicioSesion.png',
            fit: BoxFit.cover,
          ),
          // Contenido encima de la imagen
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0), //16
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontFamily: 'SF-Pro-Display',
                            fontSize: 40.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.black, // Color del texto
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

                            // Borde del TextField
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            // Borde cuando no está enfocado
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(128, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            // Borde cuando está enfocado
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
                        SizedBox(height: 20.0), //20.0
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
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
                            contentPadding: EdgeInsets.only(
                                left: 30.0, top: 24.0, bottom: 20.0),
                            floatingLabelBehavior: FloatingLabelBehavior.always,

                            // Borde del TextField
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            // Borde cuando no está enfocado
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(128, 0, 0, 0)),
                              borderRadius: BorderRadius.circular(10.0),
                            ),

                            // Borde cuando está enfocado
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
                                ] // Color del texto del botón
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF004AAD),
                            shadowColor: Colors.black, // Color del botón
                            elevation: 20.0, // Color del texto del botón
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
