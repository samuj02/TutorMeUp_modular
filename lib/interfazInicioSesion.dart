import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PantallaInicioSesion extends StatefulWidget {
  @override
  _PantallaInicioSesionState createState() => _PantallaInicioSesionState();
}

class _PantallaInicioSesionState extends State<PantallaInicioSesion> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    final response = await http.post(
      Uri.parse('http://localhost/tutormeup/login.php'),
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.body == 'Login successful') {
      Navigator.pushReplacementNamed(context, '/inicio');
    } else {
      print('Error: ${response.body}');
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
            children: <Widget>[
              // AppBar transparente
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Contenido principal
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 150), // Espacio ajustado
                        Center(
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800], // Color del texto
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo Electrónico',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 50),
                        Center(
                          child: ElevatedButton(
                            onPressed: _signIn,
                            child: Text('Iniciar Sesión'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[800], // Color del botón
                              foregroundColor: Colors.white, // Color del texto del botón
                            ),
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
