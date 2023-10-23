import 'package:flutter/material.dart';
import 'package:glucontrol_app/views/Module_4/Alimentos/AlimentosScreen.dart';
import 'package:glucontrol_app/views/Module_4/Actividades/ActivitiesScreen.dart';
import 'package:glucontrol_app/views/Module_4/RegistroGlucosa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            CategoryCard(
              title: 'Alimentos',
              icon: Icons.restaurant,
              onPressed: () {
                // Navega a la pantalla de alimentos
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AlimentosScreen(),
                ));
              },
            ),
            CategoryCard(
              title: 'Actividades',
              icon: Icons.directions_run,
              onPressed: () {
                // Navega a la pantalla de actividades
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => ActividadesScreen(),
                ));
              },
            ),
            CategoryCard(
              title: 'Glucosa',
              icon: Icons.favorite,
              onPressed: () {
                // Navega a la pantalla de glucosa
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RegistroGlucosaScreen(),
                ));
              },
            ),
            CategoryCard(
              title: 'Estadísticas',
              icon: Icons.insert_chart,
              onPressed: () {
                // Navega a la pantalla de estadísticas
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => EstadisticasScreen(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  CategoryCard({
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(16.0),
      child: InkWell(
        onTap: onPressed,
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






class EstadisticasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Estadísticas'),
      ),
      // Aquí puedes construir el contenido de la pantalla de estadísticas
    );
  }
}
