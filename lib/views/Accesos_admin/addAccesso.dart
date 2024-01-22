import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Importa la librería intl para dar formato a la fecha
import 'package:seguritl/models/Module1/RegistroModel.dart';
import 'package:seguritl/controllers/Module4/ActivitiesController.dart';
import 'package:seguritl/views/Accesos_admin/AccesosScreen.dart';
import 'package:seguritl/views/Accesos_admin/viewAccess.dart';
import 'package:seguritl/views/Module_2/login.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/views/Usuarios/UsersScreen.dart';
import 'package:seguritl/views/Usuarios/addInfoGuardia.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Actividades/ActivitiesScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AgregarAcceso(),
    );
  }
}

class AgregarAcceso extends StatefulWidget {
  @override
  _AgregarAccesoState createState() => _AgregarAccesoState();
}

class _AgregarAccesoState extends State<AgregarAcceso> {
  // variables
  TextEditingController aliasController = TextEditingController();
  TextEditingController asuntoController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  bool isPermanente = false;

  String? classification; // Cambiado a String?

  List<String> clasificaciones = ["Guardia", "Administrador"];
  String? selectedClasificacion = "Administrador";
  String datos = "ad";
  late ActivitiesController controlador;

// Obtener el ID del usuario desde SharedPreferences
Future<String?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}

void obtenerUserId() async {
  String? userId = await getUserId();

  if (userId != null) {
    print('El ID del usuario es: $userId');
    // Realiza las operaciones necesarias con el userId
  } else {
    print('El ID del usuario no está disponible');
  }
}


  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState
    controlador = ActivitiesController();
  }

  Future<void> addUser(String formData) async {
    String? userId = await getUserId();

    print(formData);
    try {
      final response = await http.post(
        Uri.parse(backendUrl + '/api/access/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        // Éxito: Navegar a la pantalla de inicio de sesión

        final Map<String, dynamic> responseData = json.decode(response.body);
        final String QR = responseData['QR'];
        print(QR);
        //construir JSON PARA VISTA
        Map<String, dynamic> jsonObject = {
          "alias": aliasController.text,
          "asunto": asuntoController.text,
          "expiracion": dateController.text,
          "permanente": isPermanente,
          "token": QR
        };

        // Convertir el Map en una cadena JSON
        String RESPUESTA = jsonEncode(jsonObject);
        // Usuario tipo guardia: Navegar a la pantalla guardia
         Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ViewAccess(food: jsonObject )),
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

  String CreateJson(String alias, asunto, fecha, bool permanente, String user_id) {
    //crear el JSON
    Map<String, dynamic> jsonObject = {
      "alias": alias,
      "asunto": asunto,
      "expiracion": fecha,
      "permanente": permanente,
      "user_id": user_id
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
                      'Agregar nuevo acceso al Tecnológico de León',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //input alias
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: aliasController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Alias',
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
                          Icons.person,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  //input asunto
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: asuntoController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Asunto',
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
                          Icons.person,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextFormField(
                      controller: dateController, // Asignar el controlador
                      readOnly: true, // Hacer que el campo sea de solo lectura
                      onTap: () async {
                        // Mostrar el selector de fecha al hacer clic en el campo
                        DateTime? selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        // Actualizar el valor del controlador con la fecha seleccionada
                        if (selectedDate != null &&
                            selectedDate != dateController.text) {
                          dateController.text =
                              selectedDate.toLocal().toString().split(' ')[0];
                        }
                      },
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Fecha',
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
                          Icons.calendar_today,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  //////// combo
                  SizedBox(height: 16.0),
                  // ... Otros widgets antes del formulario
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(
                      children: [
                        Checkbox(
                          value: isPermanente,
                          onChanged: (value) {
                            // Actualizar el estado de la casilla al cambiar
                            setState(() {
                              isPermanente = value!;
                            });
                          },
                        ),
                        Text(
                          'Permanente',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF575757),
                          ),
                        ),
                      ],
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
                      MaterialPageRoute(builder: (context) => AccesosScreen()),
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
                      String nombrePlatillo = aliasController.text;

                      if (asuntoController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, ingresa el asunto.'),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }

                            if (aliasController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, ingresa el alias.'),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }
                            if (dateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, ingresa la fecha.'),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }

                      

String? userId = await getUserId();

                      String formData = CreateJson(
                          aliasController.text,
                          asuntoController.text,
                          dateController.text,
                          isPermanente, userId!);

                      await addUser(formData);
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
    aliasController.dispose();
    super.dispose();
  }
}
