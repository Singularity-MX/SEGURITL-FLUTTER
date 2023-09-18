import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ModificarActividadScreen(),
    );
  }
}

class ModificarActividadScreen extends StatefulWidget {
  @override
  _ModificarActividadScreenState createState() =>
      _ModificarActividadScreenState();
}

class _ModificarActividadScreenState extends State<ModificarActividadScreen> {
  String? selectedClasificacion;
  TextEditingController nombreController = TextEditingController();
  TextEditingController duracionController = TextEditingController();

  List<String> clasificaciones = ['Aeróbica', 'Anaeróbica', 'Yoga', 'Pilates', 'Estiramientos'];

  String? selectedActividad;
  List<String> actividades = ['Correr', 'Nadar', 'Caminar', 'Bicicleta', 'Yoga'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modificar Actividad'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Selecciona la Actividad a Modificar:'),
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
                  selectedActividad = newValue;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text('Nombre de la Actividad:'),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: 'Nombre actual: ${selectedActividad ?? ""}',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Duración (minutos):'),
            TextField(
              controller: duracionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Duración actual: ${selectedActividad ?? ""}',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Clasificación de la Actividad:'),
            DropdownButton<String>(
              value: selectedClasificacion,
              items: clasificaciones.map((String clasificacion) {
                return DropdownMenuItem<String>(
                  value: clasificacion,
                  child: Text(clasificacion),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedClasificacion = newValue;
                });
              },
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para modificar la actividad
                // Utiliza selectedActividad, nombreController.text, duracionController.text y selectedClasificacion
                // para obtener los valores seleccionados y modificados.
                print('Actividad a Modificar: $selectedActividad');
                print('Nuevo Nombre de la Actividad: ${nombreController.text}');
                print('Nueva Duración (minutos): ${duracionController.text}');
                print('Nueva Clasificación de la Actividad: $selectedClasificacion');
              },
              child: Text('Modificar Actividad'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpia los controladores cuando se destruye el widget para liberar recursos.
    nombreController.dispose();
    duracionController.dispose();
    super.dispose();
  }
}
