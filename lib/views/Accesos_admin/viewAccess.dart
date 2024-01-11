import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import 'package:seguritl/views/Accesos_admin/AccesosScreen.dart';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Actividades/ActivitiesScreen.dart';
import 'package:seguritl/controllers/Module4/ActivitiesController.dart';

class ViewAccess extends StatefulWidget {
  final Map<String, dynamic> food; // Datos del alimento a editar

  ViewAccess({required this.food});

  @override
  _ViewAccessState createState() => _ViewAccessState();
}

class _ViewAccessState extends State<ViewAccess> {
   int _counter = 0;
  late Uint8List _imageFile;
   ScreenshotController screenshotController = ScreenshotController(); 
  // Controladores para los campos de edición
  TextEditingController foodNameController = TextEditingController();
  TextEditingController classificationController = TextEditingController();
  String? classification; // Cambiado a String?
  List<String> clasificaciones = [
    "Trabajo",
    "Ejercicio",
    "Deporte",
    "Reposo",
    "Tareas del Hogar",
    "Conducción",
    "Estudio",
    "Actividades al Aire Libre",
    "Actividades Sociales"
  ];
  String? selectedClasificacion = "Ejercicio";
  late ActivitiesController controlador;
  String aid = "";

  late String alias, asunto, expiracion, tokenQR, permanente = "";

  @override
  void initState() {
    super.initState();
    controlador = ActivitiesController();

    //inicio de la funcion
    alias = widget.food['alias'];
    asunto = widget.food['asunto'];
    tokenQR = widget.food['token'];
    expiracion = widget.food['expiracion'];
    permanente = widget.food['permanente'].toString();
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
                    child: Center(
                      child: Text(
                        'Vista del acceso',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 59, 95, 255),
                        ),
                      ),
                    ),
                  ),

                  ///infooo del acceso
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Alias:  ' + alias,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 6, 6, 6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Asunto:  ' + asunto,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 6, 6, 6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Expiración:  ' + expiracion,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 6, 6, 6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                 

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Permanente:  ' + permanente,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 6, 6, 6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Center(
                      child: QrImageView(
                        data: tokenQR,
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                    ),
                  ),
                  
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
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
