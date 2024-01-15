import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seguritl/views/Module_3/home.dart';
import 'package:intl/intl.dart'; // Importa la librería intl para dar formato a la fecha
import 'package:seguritl/models/Module1/RegistroModel.dart';
import 'package:seguritl/controllers/Module4/ActivitiesController.dart';
import 'package:seguritl/views/Module_2/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Actividades/ActivitiesScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AgregarIncidencia(),
    );
  }
}

class AgregarIncidencia extends StatefulWidget {
  @override
  _AgregarIncidenciaState createState() => _AgregarIncidenciaState();
}

class _AgregarIncidenciaState extends State<AgregarIncidencia> {
  TextEditingController comentarioController = TextEditingController();
  String? classification; // Cambiado a String?

  String? selectedClasificacion = "Ejercicio";
  String datos = "ad";
  late ActivitiesController controlador;

  String? selectedTipo = "Infraestructura";
  String? selectedSubtipo = "Eléctrico";

  List<String> tipos = [
    "Infraestructura",
    "Siniestros o contingencia",
    "Seguridad",
    "Otro"
  ];

  // Mapa de subtipos para cada tipo
  Map<String, List<String>> subtipos = {
    "Infraestructura": [
      "Eléctrico",
      "Hidráulico",
      "Infraestructura (ej. reportar daños de alguna instalación o deterioro)",
      "Hidrosanitario"
    ],
    "Siniestros o contingencia": [
      "Incendio",
      "Fenómenos hidrometeorológicos",
      "Temblor o terremoto",
      "Sanitaria (pandemia, plagas)"
    ],
    "Seguridad": ["Robo", "Asaltos", "Drogas", "Alcoholismo", "Violencia"],
    "Otro": ["Otro"]
  };

  File? _image;

  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState
    controlador = ActivitiesController();
  }

String AddActJSON(String tipo, subtipo, comentario, user_id) {
  // Crear el JSON
  Map<String, dynamic> jsonObject = {
    "tipo": tipo,
    "subtipo": subtipo,
    "comentario": comentario,
    "foto": _image != null ? base64Encode(_image!.readAsBytesSync()) : "",
    "user_id": user_id,
    "fecha": DateTime.now().toString(),
  };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);

    return formData;
  }

  Future<void> _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  Future<void> addIncidencia(String formData) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl + '/api/incidencias/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 201) {
        // Éxito: Navegar a la pantalla de inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Agregado con éxito'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
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
                        Text('SEGURITL'),
                        SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 2,
                          color: const Color.fromARGB(255, 57, 54, 244),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Crear nueva incidencia',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 59, 121, 255),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    child: Text(
                      '¿Qué tipo de incidencia es?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.0),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: selectedTipo,
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF777777),
                      ),
                      items: tipos.map((String tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Center(
                            child: Text(tipo),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTipo = newValue;
                          selectedSubtipo = subtipos[selectedTipo!]![
                              0]; // Establecer el primer subtipo por defecto
                        });
                      },
                      underline: Container(),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Container(
                    width: double.infinity,
                    child: Text(
                      '¿Qué subtipo de incidencia es?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: selectedSubtipo,
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF777777),
                      ),
                      items: subtipos[selectedTipo!]!.map((String subtipo) {
                        return DropdownMenuItem<String>(
                          value: subtipo,
                          child: Center(
                            child: Text(subtipo),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSubtipo = newValue;
                        });
                      },
                      underline: Container(),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller:
                          comentarioController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Comentario',
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
                            color: Color(0xFFFF3B3B),
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.comment,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // ... Otros widgets antes del formulario
SizedBox(height: 16.0),
// Vista previa de la imagen
Container(
  width: MediaQuery.of(context).size.width * 0.8,
  height: MediaQuery.of(context).size.width * 0.8, // Ajusta la altura según tus necesidades
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 3.0,
        spreadRadius: 2.0,
        offset: Offset(0, 0),
      ),
    ],
  ),
  child: _image != null
      ? Image.file(
          _image!,
          fit: BoxFit.cover,
        )
      : Center(
          child: Text('Vista previa de la imagen'),
        ),
),
SizedBox(height: 16.0),
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
                      MaterialPageRoute(builder: (context) => HomeScreen()),
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
                  onPressed: _takePicture,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 48, 130, 224),
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      Text(
                        ' Tomar Foto',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
                      String comentario = comentarioController.text;

                      if (comentario.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, ingresa el comentario.'),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }

                      if (_image == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, tomar una fotografía'),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }

// Obtener el valor almacenado del ID del usuario desde SharedPreferences
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String? userId = prefs.getString('userId');

                      String formData = AddActJSON(
                          selectedTipo.toString(),
                          selectedSubtipo.toString(),
                          comentario,
                          userId);

                      await addIncidencia(formData);
                    } catch (e, stackTrace) {
                      print('Error en el botón: $e');
                      print('Stack Trace: $stackTrace');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 48, 48, 48),
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
    comentarioController.dispose();
    super.dispose();
  }
}
