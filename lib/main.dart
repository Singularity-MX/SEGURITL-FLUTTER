import 'package:flutter/material.dart';
import 'views/Module_1/info_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'glucontrol-app',
      initialRoute: '/info', // Ruta inicial
      routes: {
        '/info': (context) => InfoScreen(), // Ruta para la pantalla de información
      },
    );
  }
}
