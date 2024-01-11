import 'package:flutter/material.dart';
import 'package:seguritl/views/Module_3/home.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/configBackend.dart';
import 'package:seguritl/tools/password_hash.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:seguritl/views/Module_3/home_admin.dart';

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
        Uri.parse(backendUrl + '/api/users/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('user')) {
        final Map<String, dynamic> userData = responseData['user'];

        // Verificar el tipo de usuario
        if (userData.containsKey('tipo')) {
          final String userType = userData['tipo'];

          final String userId = userData['id'];
final String emailUser = userData['email'];
          // Almacenar el ID del usuario en SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', userId);
          prefs.setString('emailUser', emailUser);


          if (userType == 'Guardia') {
            // Usuario tipo guardia: Navegar a la pantalla HomeScreen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (userType == 'Administrador') {
            // Usuario tipo admin: Navegar a otra pantalla
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreenAdmin()),
            );
          }
        }
      }
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
            content: Text('Error del servidor: ' + backendUrl),
          ),
        );
      }
    } catch (e) {
      print('Error al enviar los datos al backend: $e');
      // Mostrar un SnackBar con el mensaje de error de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No se pudo conectar al backend. Verifica tu conexión de red o inténtalo más tarde. ' +
                  backendUrl +
                  '\n' +
                  '$e'),
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
      "email": email,
      "password": pass,
    };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);
    return formData;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Image.asset(
            'lib/assets/fondoLog.png', // Ruta de la imagen de fondo
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),

          // Logo en el centro
          // Logo en el centro
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[],
            ),
          ),
          // Contenedor con bordes redondeados y sombreado
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: MediaQuery.of(context).size.height *
                    0.55, // Altura del 30% de la pantalla
                width: MediaQuery.of(context)
                    .size
                    .width, // Ancho del 100% de la pantalla
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 233, 233, 233),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0.0),
                    topRight: Radius.circular(0.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.25), // Color del sombreado
                      spreadRadius: 5, // Radio de difusión
                      blurRadius: 7, // Radio de desenfoque
                      offset: Offset(0, 3), // Desplazamiento en X y Y
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      'Inicia Sesión',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(
                            255, 41, 41, 41), // Color de la línea
                        fontWeight: FontWeight.w600, // Fuente Extra Light
                      ),
                      textAlign: TextAlign.justify, // Justificar el texto
                    ),
                    SizedBox(height: 30), // Espacio entre el texto y la línea
                    Divider(
                      height: 1, // Altura de la línea
                      color:
                          Color.fromARGB(255, 41, 41, 41), // Color de la línea
                    ),
                    SizedBox(height: 25),
                    Text(
                      'Welcome to SEGURITL',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(
                            255, 41, 41, 41), // Color de la línea
                        fontWeight: FontWeight.w300, // Fuente Extra Light
                      ),
                      textAlign: TextAlign.justify, // Justificar el texto
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: _emailController, // Asignar el controlador
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 41, 41, 41),
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          hintText: 'example@example.com',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 41, 41, 41),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 212, 212, 212),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 41, 41, 41),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person_outlined,
                            color: Color.fromARGB(255, 41, 41, 41),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller:
                            _passwordController, // Asignar el controlador
                        obscureText: true,
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 41, 41, 41),
                          letterSpacing: 0.5,
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          hintText: '**********',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 41, 41, 41),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 212, 212, 212),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 41, 41, 41),
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.person_outlined,
                            color: Color.fromARGB(255, 41, 41, 41),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30), // Espacio entre el texto y la línea
                    Divider(
                      height: 1, // Altura de la línea
                      color:
                          Color.fromARGB(255, 41, 41, 41), // Color de la línea
                    ),
                    SizedBox(
                        height: 30), // Espacio entre la línea y los botones
                    ElevatedButton(
                      onPressed: () async {
                        String formData = CrearJSON(
                            _emailController.text, _passwordController.text);
                        //hacer el login
                        await Login(formData);
                      },
                      child: Text('Iniciar sesión'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(
                            57, 91, 163, 1), // Color de fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Radio de esquinas de 15
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width *
                              0.8, // Ancho del 70% de la pantalla
                          43, // Altura de 43
                        ),
                      ),
                    ),
                  ],
                )),
          ),

          // Texto en la parte inferior
        ],
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
