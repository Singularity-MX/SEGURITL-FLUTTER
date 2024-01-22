import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Importa la librería intl para dar formato a la fecha
import 'package:seguritl/models/Module1/RegistroModel.dart';
import 'package:seguritl/controllers/Module4/ActivitiesController.dart';
import 'package:seguritl/views/Module_2/login.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/views/Usuarios/UsersScreen.dart';
import 'package:seguritl/views/Usuarios/addInfoGuardia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Actividades/ActivitiesScreen.dart';



class ModifyUsersAdmin extends StatefulWidget {
      final dynamic informacion;

  ModifyUsersAdmin({required this.informacion});

  @override
  _ModifyUsersAdminState createState() => _ModifyUsersAdminState();
}

class _ModifyUsersAdminState extends State<ModifyUsersAdmin> {
  TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
  String? classification; // Cambiado a String?

  List<String> clasificaciones = [
    "Guardia",
    "Administrador"
  ];
  String? selectedClasificacion = "Administrador";
  String datos = "ad";
  late ActivitiesController controlador;

  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState
    controlador = ActivitiesController();
    emailController.text = widget.informacion['email'];
    passwordController.text = widget.informacion['password'];
    
  }

  Future<void> modifyAdmin(String formData) async {
    print(formData);
    print(widget.informacion['id'].toString());
    try {
      final response = await http.put(
        Uri.parse(backendUrl + '/api/users/edit/'+widget.informacion['id'].toString()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        // Éxito: Navegar a la pantalla de inicio de sesión
       Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsersScreen()),
            );
      
        
          
      } else {
        // Error: Mostrar un SnackBar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de servidor: ${response.statusCode}'),
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


  String CreateJson(String email, pass, type) {
    //crear el JSON
    Map<String, dynamic> jsonObject = {
      "tipo": type,
      "email": email,
      "password": pass
    };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);

    return formData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1E1E1),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 3.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 0),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.only(
                        top: 50), // Iniciar desde la parte superior
                    child: Column(
                      children: [
                        Image.asset(
                          'lib/assets/logoHeader.png',
                          width: 170,
                          height: 32,
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 2,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                   Container(
                    width: double.infinity,
                    child: Text(
                      'Modificar la información',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //input 1
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller:
                          emailController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Color(0xFF575757),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(88, 148, 245, 1),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),
                  
                  //input 2
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller:
                          passwordController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Color(0xFF575757),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromRGBO(88, 148, 245, 1),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),
                  
                  
                  
                  
            // ... Otros widgets después del formulario
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UsersScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: const Color.fromARGB(255, 24, 24, 24),
                      ),
                      Text(
                        ' Regresar',
                        style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 27, 27, 27)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String nombrePlatillo = emailController.text;

                      if (nombrePlatillo.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, ingresa el nombre de la actividad.'),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }

                
                      String formData = CreateJson(
                        emailController.text,
                        passwordController.text,
                        selectedClasificacion,
                      );
                   
                      await modifyAdmin(formData);
                    } catch (e, stackTrace) {
                      print('Error en el botón: $e');
                      print('Stack Trace: $stackTrace');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(31, 52, 87, 1),
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      Text(
                        ' Aceptar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
