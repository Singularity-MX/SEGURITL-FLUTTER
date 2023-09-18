import 'package:flutter/material.dart';

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
  String? selectedClasificacion;
  TextEditingController nombreController = TextEditingController();
  TextEditingController duracionController = TextEditingController();

  List<String> clasificaciones = ['Aeróbica', 'Anaeróbica', 'Yoga', 'Pilates', 'Estiramientos'];

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
            Text('Nombre de la Actividad:'),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre de la actividad',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Duración (minutos):'),
            TextField(
              controller: duracionController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Ingrese la duración en minutos',
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
                // Aquí puedes agregar la lógica para registrar la actividad
                // Utiliza nombreController.text, duracionController.text y selectedClasificacion
                // para obtener los valores ingresados y seleccionados.
                print('Nombre de la Actividad: ${nombreController.text}');
                print('Duración (minutos): ${duracionController.text}');
                print('Clasificación de la Actividad: $selectedClasificacion');
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
    // Limpia los controladores cuando se destruye el widget para liberar recursos.
    nombreController.dispose();
    duracionController.dispose();
    super.dispose();
  }
}
