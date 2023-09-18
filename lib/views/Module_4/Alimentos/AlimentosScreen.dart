import 'package:flutter/material.dart';
import 'package:glucontrol_app/views/Module_4/Alimentos/addAlimentos.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlimentosScreen(),
    );
  }
}

class AlimentosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alimentos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            FoodCard(
              title: 'Agregar',
              icon: Icons.add,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgregarAlimentoScreen()),
                );
              },
            ),
            FoodCard(
              title: 'Modificar',
              icon: Icons.edit,
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgregarAlimentoScreen()),
                );
              },
            ),
            FoodCard(
              title: 'Eliminar',
              icon: Icons.delete,
              onTap: () {
                // Acción para eliminar alimentos
                // Puedes mostrar un cuadro de diálogo o navegar a otra pantalla aquí.
              },
            ),
            FoodCard(
              title: 'Buscar',
              icon: Icons.search,
              onTap: () {
                // Acción para buscar alimentos
                // Puedes mostrar un cuadro de búsqueda o navegar a otra pantalla aquí.
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  FoodCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            SizedBox(height: 16.0),
            Text(
              title,
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
