import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Importa la librería intl para dar formato a la fecha
import 'package:glucontrol_app/models/Module1/RegistroModel.dart';
import 'package:glucontrol_app/controllers/Module4/ActivitiesController.dart';
import 'package:glucontrol_app/views/Module_2/login.dart';
import 'package:http/http.dart' as http;
import '../../../configBackend.dart';
import 'package:glucontrol_app/views/Module_4/Actividades/ActivitiesScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AgregarActividadScreen(),
    );
  }
}

class AgregarActividadScreen extends StatefulWidget {
  @override
  _AgregarActividadScreenState createState() => _AgregarActividadScreenState();
}

class _AgregarActividadScreenState extends State<AgregarActividadScreen> {
  TextEditingController nombrePlatilloController = TextEditingController();
  String? classification; // Cambiado a String?

  List<String> clasificaciones = ["Trabajo", "Ejercicio", "Deporte", "Reposo", "Tareas del Hogar", "Conducción", "Estudio", "Actividades al Aire Libre", "Actividades Sociales"];
  String? selectedClasificacion = "Ejercicio";
  String datos = "ad";
  late ActivitiesController controlador;

  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState
    controlador = ActivitiesController();
  }

  Future<void> addActivitie(String formData) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl+'/api/Module4/CreateActivity'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        // Éxito: Navegar a la pantalla de inicio de sesión
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActividadesScreen()),
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
      appBar: AppBar(
        title: Text('Agregar Actividad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nombre:'),
            TextField(
              controller: nombrePlatilloController,
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre de la actividad',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Clasificación:'),
            DropdownButton<String>(
              value: selectedClasificacion,
              items: clasificaciones.map((String clasificacion) {
                return DropdownMenuItem<String>(
                  value: clasificacion,
                  child: Text(clasificacion),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Cambiado a String?
                setState(() {
                  selectedClasificacion = newValue;
                });
              },
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
  onPressed: () async {
    try {
      String nombrePlatillo = nombrePlatilloController.text;
     
      String formData = controlador.AddActJSON(
          nombrePlatilloController.text, selectedClasificacion);
       print('Nombre del Platillo: $formData');   
      await addActivitie(formData);
    } catch (e, stackTrace) {
      print('Error en el botón: $e');
      print('Stack Trace: $stackTrace');
    }
  },
  child: Text('Agregar Actividad'),
),

            
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nombrePlatilloController.dispose();
    super.dispose();
  }
}
