import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:glucontrol_app/configBackend.dart';
import 'package:http/http.dart' as http;
import 'package:glucontrol_app/controllers/Module4/GlucoseController.dart';
import 'package:glucontrol_app/views/Module_3/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistroGlucosaScreen(),
    );
  }
}

class RegistroGlucosaScreen extends StatefulWidget {
  @override
  _RegistroGlucosaScreenState createState() => _RegistroGlucosaScreenState();
}

class _RegistroGlucosaScreenState extends State<RegistroGlucosaScreen> {
  String? selectedAlimento;
  String? selectedActividad;
  TextEditingController glucosaController = TextEditingController();
TextEditingController cantidadController = TextEditingController();
TextEditingController duracionController = TextEditingController();

  List<String> alimentos = []; // Lista de alimentos
  List<String> actividades = []; // Lista de actividades

  late GlucoseController controlador;
  @override
  void initState() {
    super.initState();
    fetchAlimentos();
    fetchActividades();
    controlador = GlucoseController();
  }

Future<void> fetchAlimentos() async {
  final response = await http
      .get(Uri.parse('${ApiConfig.backendUrl}/api/Module4/GetUserFoods'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data is List) {
      setState(() {
        alimentos = data
            .map((item) => item['Food_name'].toString()) // Asegúrate de que el valor sea String
            .toList();
      });
    } else {
      throw Exception('Error al obtener alimentos');
    }
  } else {
    throw Exception('Error al obtener alimentos');
  }
}

Future<void> fetchActividades() async {
  final response = await http
      .get(Uri.parse('${ApiConfig.backendUrl}/api/Module4/GetActivities'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data is List) {
      setState(() {
        actividades = data
            .map((item) => item['Activitie_name'].toString()) // Asegúrate de que el valor sea String
            .toList();
      });
    } else {
      throw Exception('Error al obtener actividades');
    }
  } else {
    throw Exception('Error al obtener actividades');
  }
}

  Future<void> addReadingGlucose(String formData) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl + '/api/Module4/CreateGlucoseReading'),
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
        title: Text('Registro de Glucosa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Selecciona el Alimento:'),
            DropdownButton<String>(
  value: selectedAlimento,
  items: alimentos.map((String alimento) {
    return DropdownMenuItem<String>(
      value: alimento,
      child: Text(alimento),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      selectedAlimento = newValue ?? ''; // Usa el operador ?? para evitar nulos
    });
  },
),

            SizedBox(height: 16.0),
            Text('Cantidad de Alimento (g):'),
            TextField(
              controller: cantidadController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingrese la cantidad de alimento (en gramos)',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Selecciona la Actividad:'),
           DropdownButton<String>(
  value: selectedActividad,
  items: actividades.map((String actividad) {
    return DropdownMenuItem<String>(
      value: actividad,
      child: Text(actividad),
    );
  }).toList(),
  onChanged: (String? newValue) {
    setState(() {
      selectedActividad = newValue ?? ''; // Usa el operador ?? para evitar nulos
    });
  },
),
            SizedBox(height: 16.0),
            Text('Duración de la Actividad (minutos):'),
            TextField(
              controller: duracionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingrese la duración de la actividad (en minutos)',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Nivel de Glucosa (mg/dL):'),
            TextField(
              controller: glucosaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingrese el nivel de glucosa',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () async {
                // Aquí puedes agregar la lógica para registrar la glucosa
                // Utiliza selectedAlimento, selectedActividad y glucosaController.text
                // para obtener los valores seleccionados y el nivel de glucosa.
                print('Alimento seleccionado: $selectedAlimento');
                print('Actividad seleccionada: $selectedActividad');
                print('Nivel de Glucosa: ${glucosaController.text}');

                try {
                  String formData = controlador.AddReadGlucoseJSON(
                      selectedAlimento!, cantidadController.text, 
                      selectedActividad!, duracionController.text, glucosaController.text);
                  print('Nombre del Platillo: $formData');
                  await addReadingGlucose(formData);
                } catch (e, stackTrace) {
                  print('Error en el botón: $e');
                  print('Stack Trace: $stackTrace');
                }
              },
              child: Text('Registrar Glucosa'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpia el controlador cuando se destruye el widget para liberar recursos.
    glucosaController.dispose();
    super.dispose();
  }
}
