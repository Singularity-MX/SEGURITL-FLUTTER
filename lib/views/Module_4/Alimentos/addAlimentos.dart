import 'package:flutter/material.dart';

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
  TextEditingController ingredientesController = TextEditingController();
  TextEditingController clasificacionController = TextEditingController();

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
            Text('Ingredientes:'),
            TextField(
              controller: ingredientesController,
              decoration: InputDecoration(
                hintText: 'Ingrese los ingredientes',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Clasificación:'),
            TextField(
              controller: clasificacionController,
              decoration: InputDecoration(
                hintText: 'Ingrese la clasificación',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para guardar el alimento en tu base de datos o realizar la acción deseada.
                String nombrePlatillo = nombrePlatilloController.text;
                String ingredientes = ingredientesController.text;
                String clasificacion = clasificacionController.text;

                print('Nombre del Platillo: $nombrePlatillo');
                print('Ingredientes: $ingredientes');
                print('Clasificación: $clasificacion');

                // Puedes agregar aquí la lógica para guardar el alimento.
              },
              child: Text('Agregar Alimento'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Limpia los controladores cuando se destruye el widget para liberar recursos.
    nombrePlatilloController.dispose();
    ingredientesController.dispose();
    clasificacionController.dispose();
    super.dispose();
  }
}
