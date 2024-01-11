import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Importa la librería intl para dar formato a la fecha
import 'package:seguritl/models/Module1/RegistroModel.dart';
import 'package:seguritl/controllers/Module4/ActivitiesController.dart';
import 'package:seguritl/views/Module_2/login.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/views/Module_3/home_admin.dart';
import 'package:seguritl/views/Usuarios/UsersScreen.dart';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Actividades/ActivitiesScreen.dart';



class VistaAdmin extends StatefulWidget {
    final dynamic informacion;

  VistaAdmin({required this.informacion});
  @override
  _VistaAdminState createState() => _VistaAdminState();
}

class _VistaAdminState extends State<VistaAdmin> {

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoPController = TextEditingController();
  TextEditingController apellidoMController = TextEditingController();
  TextEditingController curpController = TextEditingController();

  List<String> sexos = ["Masculino", "Femenino"];
  List<String> turnos = [
    "Matutino",
    "Vespertino",
  ];

  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState

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
                      'Información de Administrador',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //Email
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Email',
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
                     widget.informacion['email'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                   //Contraseña
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Password',
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
                     widget.informacion['password'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.left,
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
          
        ],
      ),
    );
  }

  @override
  void dispose() {
   
    super.dispose();
  }
}
