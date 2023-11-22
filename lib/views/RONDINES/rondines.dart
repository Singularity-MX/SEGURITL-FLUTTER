import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class Checkpoint {
  double latitude;
  double longitude;
  bool validated;

  Checkpoint({required this.latitude, required this.longitude, this.validated = false});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;

  double enteredLatitude = 0.0;
  double enteredLongitude = 0.0;

/**

CASETA DE ESTACIONAMIENTO (1)
21.107534, -101.627544

EDIFICIO 12 (2)
21.108248, -101.629531

EDIFICIO K (3)
21.109302, -101.629154

EDIFICIO SISTEMAS(4)
21.109482, -101.627891

ENTRADA CONALEP (5)
21.109890, -101.629947

EDIFICIO METALMECANICA (6)
21.109880, -101.628979

EDIFICIO POSGRADO ANTIGUO (7)
21.110372, -101.627834

AUDITORIO (8)
21.109476, -101.625800

ENTRE AUDITORIO Y CANCHA (9)
21.108607, -101.625313

, 21.155689, -101.669075
 */

  List<Checkpoint> checkpoints = [
    //Checkpoint(latitude: 21.155689, longitude: -101.669075), // Punto casa 
    Checkpoint(latitude: 21.107534, longitude: -101.627544), // Punto 1
    Checkpoint(latitude: 21.108248, longitude: -101.629531), // Punto 2
    Checkpoint(latitude: 21.109302, longitude: -101.629154), // Punto 3
    Checkpoint(latitude: 21.109482, longitude: -101.627891), // Punto 4
    Checkpoint(latitude: 21.109890, longitude: -101.629947), // Punto 5
    Checkpoint(latitude: 21.109880, longitude: -101.628979), // Punto 6
    Checkpoint(latitude: 21.110372, longitude: -101.627834), // Punto 7
    Checkpoint(latitude: 21.109476, longitude: -101.625800), // Punto 8
    Checkpoint(latitude: 21.108607, longitude: -101.625313), // Punto 9
    // Agrega más puntos según sea necesario
  ];

  int currentCheckpointIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitoreo de Ruta"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Latitud actual: $currentLatitude",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Longitud actual: $currentLongitude",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                enteredLatitude = double.tryParse(value) ?? 0.0;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ingresar Latitud'),
            ),
            TextField(
              onChanged: (value) {
                enteredLongitude = double.tryParse(value) ?? 0.0;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ingresar Longitud'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentLatitude = enteredLatitude;
                  currentLongitude = enteredLongitude;
                });
              },
              child: Text("Asignar Coordenadas"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
               ;
                validateCheckpoint();
              },
              child: Text("Validar Punto de Control sin gps"),
            ),
              SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getCurrentLocation();
                
              },
              child: Text("Validar Punto de Control con gps"),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              value: calculateProgress() / 100, // El valor debe estar entre 0 y 1
              color: Colors.blue, // Puedes cambiar el color según tu preferencia
            ),
            Text(
              "${calculateProgress().toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Último Punto Validado: ${currentCheckpointIndex > 0 ? currentCheckpointIndex : 'Ninguno'}",
              style: TextStyle(fontSize: 16),
            ),
            if (currentCheckpointIndex == checkpoints.length)
              TextButton(
                onPressed: () {
                  showTotalTime();
                },
                child: Text("Finalizar Recorrido"),
              ),
          ],
        ),
      ),
    );
  }

  void validateCheckpoint() {
    if (currentCheckpointIndex < checkpoints.length) {
      Checkpoint currentCheckpoint = checkpoints[currentCheckpointIndex];
      double tolerance = 0.0008; // Tolerancia para la comparación de coordenadas

      if ((currentLatitude - currentCheckpoint.latitude).abs() < tolerance &&
          (currentLongitude - currentCheckpoint.longitude).abs() < tolerance) {
        // Coordenadas válidas
        setState(() {
          currentCheckpoint.validated = true;
          currentCheckpointIndex++;
        });
        showSuccessMessage("Validación Exitosa", currentCheckpointIndex);
      } else {
        // Coordenadas no válidas
        showErrorMessage("Error, dirigete al punto: ", currentCheckpointIndex);
      }
    }
  }

  double calculateProgress() {
    int validatedCheckpoints = checkpoints.where((checkpoint) => checkpoint.validated).length;
    return (validatedCheckpoints / checkpoints.length) * 100;
  }

  void showSuccessMessage(String message, int checkpointIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Éxito"),
        content: Text("$message\nDirígete al punto ${checkpointIndex + 1}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  void showErrorMessage(String message, int checkpointIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text("$message${checkpointIndex + 1}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  void showTotalTime() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Recorrido Finalizado"),
        content: Text("Tiempo Total: ${calculateTotalTime().toStringAsFixed(2)} minutos"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"),
          ),
        ],
      ),
    );
  }

  double calculateTotalTime() {
    // Calcula el tiempo total en minutos (ejemplo: 5 metros por minuto)
    return checkpoints.fold(0.0, (sum, checkpoint) => sum + (checkpoint.validated ? 5.0 : 0.0));
  }


// Nueva función para obtener las coordenadas de Geolocator
  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
      print('Latitud: $currentLatitude');
      print('Longitud: $currentLongitude');
      validateCheckpoint();
      
    } catch (e) {
      print("Error al obtener las coordenadas: $e");
    }
  }


}
