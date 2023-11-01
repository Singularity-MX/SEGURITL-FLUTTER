import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../configBackend.dart';
import 'package:glucontrol_app/views/Module_4/Actividades/ActivitiesScreen.dart';
import 'package:glucontrol_app/controllers/Module4/ActivitiesController.dart';

class ModificarActividadScreen extends StatefulWidget {
  final Map<String, dynamic> food; // Datos del alimento a editar

  ModificarActividadScreen({required this.food});

  @override
  _ModificarActividadScreenState createState() => _ModificarActividadScreenState();
}

class _ModificarActividadScreenState extends State<ModificarActividadScreen> {
  // Controladores para los campos de edición
  TextEditingController foodNameController = TextEditingController();
  TextEditingController classificationController = TextEditingController();
  String? classification; // Cambiado a String?
  List<String> clasificaciones = ["Trabajo", "Ejercicio", "Deporte", "Reposo", "Tareas del Hogar", "Conducción", "Estudio", "Actividades al Aire Libre", "Actividades Sociales"];
  String? selectedClasificacion = "Ejercicio";
  late ActivitiesController controlador;
  String aid="";

  @override
  void initState() {
    super.initState();
    controlador = ActivitiesController();
    // Inicializa los controladores con los datos actuales del alimento
    foodNameController.text = widget.food['Activitie_name'];
    classificationController.text = widget.food['Classification'];
    aid=widget.food['AID'];
  }

  Future<void> ModifyActivitie(String formData) async {
    try {
      final response = await http.put(
        Uri.parse(ApiConfig.backendUrl +
            '/api/Module4/UpdateActivity/'+aid),
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
        title: Text('Editar Alimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: foodNameController,
              decoration: InputDecoration(labelText: 'Nombre del act'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Aquí debes enviar los datos actualizados al servidor
                final updatedFoodData = {
                  'Food_name': foodNameController.text,
                  'Classification': selectedClasificacion,
                };
                // Llama a la función para enviar los datos actualizados al servidor
                // Puedes usar http.put o http.post, dependiendo de tu API
                // Asegúrate de manejar las respuestas y errores adecuadamente

                try {
                  String formData = controlador.AddActJSON(
                      foodNameController.text, selectedClasificacion);

                  await ModifyActivitie(formData);
                } catch (e, stackTrace) {
                  print('Error en el botón: $e');
                  print('Stack Trace: $stackTrace');
                }
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
