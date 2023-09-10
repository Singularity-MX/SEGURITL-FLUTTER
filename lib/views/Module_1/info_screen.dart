import 'package:flutter/material.dart';
import 'info_menu.dart'; // Importa la página InfoMenu

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de glucontrol-app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Bienvenido a glucontrol-app',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Esta aplicación te ayuda a controlar tus niveles de glucosa.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navegar a la página InfoMenu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoMenu()),
                );
              },
              child: Text('Ir al Menú de Información'),
            ),
          ],
        ),
      ),
    );
  }
}
