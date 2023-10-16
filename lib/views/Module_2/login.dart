import 'package:flutter/material.dart';
import 'package:glucontrol_app/views/Module_3/home.dart';
import 'package:http/http.dart' as http;
import 'package:glucontrol_app/configBackend.dart';
import 'package:glucontrol_app/tools/password_hash.dart';
import 'dart:convert';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String backendUrl = ApiConfig.backendUrl;

//login
  Future<void> Login(String formData) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl + '/api/Module2/Login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        // Éxito: Navegar a la pantalla de inicio de sesión
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
      if (response.statusCode == 401) {
        // Éxito: Navegar a la pantalla de inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contraseña incorrecta'),
          ),
        );
      }
      if (response.statusCode == 404) {
        // Éxito: Navegar a la pantalla de inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('El usuario no existe'),
          ),
        );
      }
      if (response.statusCode == 500) {
        // Éxito: Navegar a la pantalla de inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error del servidor'),
          ),
        );
      }
    } catch (e) {
      print('Error al enviar los datos al backend: $e');
      // Mostrar un SnackBar con el mensaje de error de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No se pudo conectar al backend. Verifica tu conexión de red o inténtalo más tarde.'),
        ),
      );
    }
  }

//crear json
  String CrearJSON(String email, String pass) {
    //hashea la contraseña
    String salt = "GlucontrolHash"; // Cambia esto por un valor secreto y único
    String hashedPassword = hashPassword(pass!, salt);

    //crear el JSON
    Map<String, dynamic> jsonObject = {
      "Email": email,
      "Password": hashedPassword,
    };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);
    return formData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: ()  async {
                String formData =
                    CrearJSON(_emailController.text, _passwordController.text);
                //hacer el login
                await Login(formData);
              },
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpia los controladores cuando se destruye el widget para liberar recursos.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
