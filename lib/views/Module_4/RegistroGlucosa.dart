import 'package:flutter/material.dart';

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

  List<String> alimentos = ['Manzana', 'Banana', 'Uvas', 'Pan', 'Arroz'];
  List<String> actividades = ['Caminar', 'Correr', 'Nadar', 'Bicicleta', 'Yoga'];

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
                  selectedAlimento = newValue;
                });
              },
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
                  selectedActividad = newValue;
                });
              },
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
              onPressed: () {
                // Aquí puedes agregar la lógica para registrar la glucosa
                // Utiliza selectedAlimento, selectedActividad y glucosaController.text
                // para obtener los valores seleccionados y el nivel de glucosa.
                print('Alimento seleccionado: $selectedAlimento');
                print('Actividad seleccionada: $selectedActividad');
                print('Nivel de Glucosa: ${glucosaController.text}');
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
