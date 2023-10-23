import 'package:flutter/material.dart';
import 'package:glucontrol_app/views/Module_4/Alimentos/AlimentosScreen.dart';
import 'package:glucontrol_app/views/Module_4/Actividades/ActivitiesScreen.dart';
import 'package:glucontrol_app/views/Module_4/RegistroGlucosa.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
   
    // Configura el color de la barra de notificaciones
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF323232), // Cambia el color aquí
    ));

    return Scaffold(
      backgroundColor: Color(0xFFE1E1E1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 0),
                  ),
                ],
                color: Colors.white,
              ),
              padding:
                  EdgeInsets.only(top: 50), // Iniciar desde la parte superior
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/logoHeader.png',
                    width: 170,
                    height: 32,
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 2,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            
            
          ],
        ),
      ),
    );
  }
}

