import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Importa la librería intl para dar formato a la fecha
import 'package:glucontrol_app/models/Module1/RegistroModel.dart';
import 'package:glucontrol_app/controllers/Module4/FoodControllers.dart';
import 'package:glucontrol_app/views/Module_2/login.dart';
import 'package:http/http.dart' as http;
import '../../../configBackend.dart';
import 'package:glucontrol_app/views/Module_4/Alimentos/AlimentosScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AgregarAlimentoScreen(),
    );
  }
}

class AgregarAlimentoScreen extends StatefulWidget {
  @override
  _AgregarAlimentoScreenState createState() => _AgregarAlimentoScreenState();
}

class _AgregarAlimentoScreenState extends State<AgregarAlimentoScreen> {
  TextEditingController nombrePlatilloController = TextEditingController();
  String? classification; // Cambiado a String?

  List<String> clasificaciones = ["Carbohidratos", "Proteínas", "Grasas", "Frutas", "Verduras"];
  String? selectedClasificacion = "Verduras";
  String datos = "ad";
  late FoodController controlador;

  @override
  void initState() {
    super.initState(); // Asegúrate de llamar a super.initState() aquí
    // Inicializar el controlador en el initState
    controlador = FoodController();
  }

  Future<void> AddFood(String formData) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl+'/api/Module4/CreateFood'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        // Éxito: Navegar a la pantalla de inicio de sesión
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AlimentosScreen()),
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
        title: Text('Agregar Alimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nombre del Platillo:'),
            TextField(
              controller: nombrePlatilloController,
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre del platillo',
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
      print('Nombre del Platillo: $nombrePlatillo');
      print('Clasificación: $selectedClasificacion');
      String formData = controlador.AddFoodJSON(
          nombrePlatilloController.text, selectedClasificacion);
       print('Nombre del Platillo: $formData');   
      await AddFood(formData);
    } catch (e, stackTrace) {
      print('Error en el botón: $e');
      print('Stack Trace: $stackTrace');
    }
  },
  child: Text('Agregar Alimento'),
),

            Text('Nombre del Platillo: '),
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
