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

class ModifyUserGuardia extends StatefulWidget {
  final dynamic informacion;

  ModifyUserGuardia({required this.informacion});

  @override
  _ModifyUserGuardiaState createState() => _ModifyUserGuardiaState();
}

class _ModifyUserGuardiaState extends State<ModifyUserGuardia> {
  File? _image1;
  File? _image2;

  bool _foto = false;

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoPController = TextEditingController();
  TextEditingController apellidoMController = TextEditingController();
  TextEditingController curpController = TextEditingController();

  String rutaImagen1 = "";
  String rutaImagen2 = "";

  List<String> sexos = ["Masculino", "Femenino"];
  List<String> turnos = [
    "Matutino",
    "Vespertino",
  ];

  String? selectedTurno = "Matutino";
  String? selectedSexo = "Masculino";

  //delete

  TextEditingController nombrePlatilloController = TextEditingController();
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
  String datos = "ad";
  String id_user = "";
  late ActivitiesController controlador;

  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState
    controlador = ActivitiesController();
    print(widget.informacion);
    nombreController.text = widget.informacion['nombre'];
    apellidoPController.text = widget.informacion['apellidop'];
    apellidoMController.text = widget.informacion['apellidom'];
    curpController.text = widget.informacion['curp'];
    id_user = widget.informacion['user_id'];

    rutaImagen1 = backendUrl + "/" + widget.informacion['foto_url'];
    rutaImagen2 = backendUrl + "/" + widget.informacion['fotocredencial_url'];
    //rutaImagen2 = ApiConfig.backendUrl + "/" + widget.informacion['fotocredencial_url'];
  }

  Future<void> _takePictureIMG1() async {
    _foto = true;
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image1 = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  Future<void> _takePictureIMG2() async {
    _foto = true;
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image2 = File(pickedFile.path);
      } else {
        print('No se seleccionó ninguna imagen.');
      }
    });
  }

  Future<void> editExpedienteSinFoto(String formData) async {
    print("editando sin foto");
    print(formData);
    try {
      final response = await http.put(
        Uri.parse(backendUrl + '/api/users/expediente/edit'),
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

  Future<void> editExpedienteConFoto(String formData) async {
    try {
      final response = await http.put(
        Uri.parse(backendUrl + '/api/users/expediente/modify'),
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

  String CreateJson(String nombre, ap, am, sexo, turno, curp) {
    //crear el JSON
    Map<String, dynamic> jsonObject = {
      "user_id": widget.informacion['user_id'],
      "nombre": nombre,
      "apellidop": ap,
      "apellidom": am,
      "curp": curp,
      "sexo": sexo,
      //"foto_url": _image1 != null ? base64Encode(_image1!.readAsBytesSync()) : "",
      //"fotocredencial_url": _image2 != null ? base64Encode(_image2!.readAsBytesSync()) : "",
      "turno": turno
    };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);

    return formData;
  }

  String CreateJsonFOTO(String nombre, ap, am, sexo, turno, curp) {
    //crear el JSON
    Map<String, dynamic> jsonObject = {
      "user_id": widget.informacion['user_id'],
      "nombre": nombre,
      "apellidop": ap,
      "apellidom": am,
      "curp": curp,
      "sexo": sexo,
      "foto_url":
          _image1 != null ? base64Encode(_image1!.readAsBytesSync()) : "",
      "fotocredencial_url":
          _image2 != null ? base64Encode(_image2!.readAsBytesSync()) : "",
      "turno": turno
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
                      'Modificar la información del guardia',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4F4F4F),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  //input 1 -- nombre
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: nombreController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Ingresa el nombre',
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
                          Icons.person,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  //input 2 -- apellido paterno
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: apellidoPController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Ingresa el apellido paterno',
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
                          Icons.person,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  //input 3-- apellido materno
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: apellidoMController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Ingresa el apellido materno',
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
                          Icons.person,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  //input 4-- curp
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: curpController, // Asignar el controlador
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF575757),
                        letterSpacing: 0.5,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        hintText: 'Ingresa el curp',
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
                          Icons.info,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ),
                  ),

                  //////// combo 1 -sexo
                  SizedBox(height: 16.0),
                  // ... Otros widgets antes del formulario
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Escoge un sexo',
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
                      value: selectedSexo,
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF777777),
                      ),
                      items: sexos.map((String sexo) {
                        return DropdownMenuItem<String>(
                          value: sexo,
                          child: Center(
                            child: Text(sexo),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSexo = newValue;
                        });
                      },
                      underline: Container(),
                    ),
                  ),

                  //////// combo 2 - turno
                  SizedBox(height: 16.0),
                  // ... Otros widgets antes del formulario
                  Container(
                    width: double.infinity,
                    child: Text(
                      'Escoge el turno',
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
                      value: selectedTurno,
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF777777),
                      ),
                      items: turnos.map((String turno) {
                        return DropdownMenuItem<String>(
                          value: turno,
                          child: Center(
                            child: Text(turno),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTurno = newValue;
                        });
                      },
                      underline: Container(),
                    ),
                  ),

// -btn tomar foto 1
                  SizedBox(height: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _takePictureIMG1,
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
                                ' Cambiar foto del guardia',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

//---------------------------------IMAGENES preview---------------------------------
                  SizedBox(height: 16.0),
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
                            child: rutaImagen1.isNotEmpty
                                ? Image.network(
                                    Uri.encodeFull(
                                        rutaImagen1), // Asegura que la URL esté codificada correctamente
                                    fit: BoxFit.fill,
                                  )
                                : Text('Vista previa de la imagen'),
                          ),
                  ),

                  // -btn tomar foto 2
                  SizedBox(height: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: _takePictureIMG2,
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
                                ' Cambiar foto de la credencial',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

//---------------------------------IMAGENES preview---------------------------------
                  SizedBox(height: 16.0),
// Vista previa de la imagen
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
                            child: rutaImagen2.isNotEmpty
                                ? Image.network(
                                    Uri.encodeFull(
                                        rutaImagen2), // Asegura que la URL esté codificada correctamente
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
                      MaterialPageRoute(builder: (context) => UsersScreen()),
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
                      // validar que los campos no estén vacíos
                      String nombre = nombreController.text;
                      String ap = apellidoPController.text;
                      String am = apellidoMController.text;
                      String curp = curpController.text;

                      if (nombre.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, ingresa el nombre '),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }
                      if (ap.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Por favor, ingresa el apellido paterno '),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }
                      if (am.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Por favor, ingresa el apellido materno '),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }
                      if (curp.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Por favor, ingresa el curp '),
                          ),
                        );
                        return; // Salir de la función sin continuar
                      }

                      //validar si se esta editando la foto
                      if (_foto == false) {
                        //endpoints sin foto
                        String formData = CreateJson(
                          nombreController.text,
                          apellidoPController.text,
                          apellidoMController.text,
                          selectedSexo.toString(),
                          selectedTurno.toString(),
                          curpController.text,
                        );

                        await editExpedienteSinFoto(formData);
                      }
                      if (_foto == true) {
                        //crear json
                        String formData = CreateJsonFOTO(
                            nombreController.text,
                            apellidoPController.text,
                            apellidoMController.text,
                            selectedSexo.toString(),
                            selectedTurno.toString(),
                            curpController.text);

                        if (_image1 == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Por favor, toma la fotografía del guardia'),
                            ),
                          );
                          return; // Salir de la función sin continuar
                        }
                        //validar fotos2
                        if (_image2 == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Por favor, toma la fotografía de su credencial'),
                            ),
                          );
                          return; // Salir de la función sin continuar
                        }

                        await editExpedienteConFoto(formData);
                      }
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
    nombrePlatilloController.dispose();
    super.dispose();
  }
}
