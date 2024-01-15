import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Importa la librería intl para dar formato a la fecha
import 'package:seguritl/models/Module1/RegistroModel.dart';
import 'package:seguritl/controllers/Module4/ActivitiesController.dart';
import 'package:seguritl/views/Incidencias/InicenciasScreen.dart';
import 'package:seguritl/views/Module_2/login.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/views/Module_3/home_admin.dart';
import 'package:seguritl/views/Usuarios/UsersScreen.dart';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Actividades/ActivitiesScreen.dart';

class VistaIncidencia extends StatefulWidget {
  final dynamic informacion;

  VistaIncidencia({required this.informacion});

  @override
  _VistaIncidenciaState createState() => _VistaIncidenciaState();
}

class _VistaIncidenciaState extends State<VistaIncidencia> {
  File? _image1;
  File? _image2;

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoPController = TextEditingController();
  TextEditingController apellidoMController = TextEditingController();
  TextEditingController curpController = TextEditingController();

  List<String> sexos = ["Masculino", "Femenino"];
  List<String> turnos = [
    "Matutino",
    "Vespertino",
  ];

  List<dynamic> InfoObtenida = [];

  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState
    getInformacion();
    //obten los valores
  
  }

 Future<void> getInformacion() async {
  print(widget.informacion['user_id']);
    try {
      final response =
          await http.get(Uri.parse(ApiConfig.backendUrl + '/api/users/'+widget.informacion['user_id']));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          InfoObtenida = jsonData;
        });
      } else {
        // Manejar errores si la solicitud no fue exitosa
        print('Error al obtener alimentos: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores en la solicitud
      print('Error en la solicitud: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    //final JSON = InfoObtenida[0];
final JSON = InfoObtenida[0];
    String rutaImagen = ApiConfig.backendUrl + "/" + widget.informacion['foto'];
    String rutaImagen2 =
        ApiConfig.backendUrl + "/" + widget.informacion['foto'];
    print(rutaImagen);
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
                      'Información completa de la incidencia',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //ID
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'ID:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      widget.informacion['id'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  //Tipo
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Tipo:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      widget.informacion['tipo'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  //Subtipo
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Subtipo:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                       widget.informacion['subtipo'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Fecha:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      widget.informacion['fecha'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  //comentario
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Comentario:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                       widget.informacion['comentario'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  //email-guardia
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Guardia-email:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                       JSON['email'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Foto de incidente:',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 29, 29, 29),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
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
                    child: _image1 != null
                        ? Image.file(
                            _image1!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: rutaImagen.isNotEmpty
                                ? Image.network(
                                    Uri.encodeFull(
                                        rutaImagen), // Asegura que la URL esté codificada correctamente
                                    fit: BoxFit.fill,
                                  )
                                : Text('Vista previa de la imagen'),
                          ),
                  ),

         ],
              ),
            ),
          ),
          SizedBox(height: 10.0),

          //---------------------------------- credencial

          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => incidenciasScreen()),
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
