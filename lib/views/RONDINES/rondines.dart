import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seguritl/views/Incidencias/IncidenciasController.dart';
import 'package:seguritl/views/Module_3/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../configBackend.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class Checkpoint {
  double latitude;
  double longitude;
  bool validated;
  DateTime validationTime; // Nueva propiedad para almacenar la hora de validación

  Checkpoint({
    required this.latitude,
    required this.longitude,
    this.validated = false,
  }) : validationTime = DateTime.now(); // Inicializar con la hora actual
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

  late Timer _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    // Iniciar el temporizador solo si el índice actual es 0
    if (currentCheckpointIndex == 0) {
      startTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const Duration oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (Timer timer) {
      setState(() {
        _elapsedSeconds += 1;
      });


    });
  }

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
    //test
    /*
    Checkpoint(latitude: 21.1557101, longitude: -101.6690634),
    Checkpoint(latitude: 21.1557101, longitude: -101.6690638), 
    Checkpoint(latitude: 21.1557101, longitude: -101.6690640),  // Punto casa
    */
  Checkpoint(latitude: 21.107534, longitude: -101.627544), // Punto 1 -inicio
    Checkpoint(latitude: 21.108248, longitude: -101.629531), // Punto 2
    Checkpoint(latitude: 21.109302, longitude: -101.629154), // Punto 3
    Checkpoint(latitude: 21.109482, longitude: -101.627891), // Punto 4
    Checkpoint(latitude: 21.109890, longitude: -101.629947), // Punto 5
    Checkpoint(latitude: 21.109880, longitude: -101.628979), // Punto 6
    Checkpoint(latitude: 21.110372, longitude: -101.627834), // Punto 7
    Checkpoint(latitude: 21.109476, longitude: -101.625800), // Punto 8
    Checkpoint(latitude: 21.108607, longitude: -101.625313), // Punto 9
    Checkpoint(latitude: 21.107534, longitude: -101.627544), // Punto 10 termino
    
    // Agrega más puntos según sea necesario
  ];

  List<DateTime> validationTimes = []; // Lista para almacenar las horas de validación

  int currentCheckpointIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE1E1E1),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
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
                    padding: EdgeInsets.only(
                        top: 50), // Iniciar desde la parte superior
                    child: Column(
                      children: [
                        Text('SEGURITL'),
                        SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 2,
                          color: const Color.fromARGB(255, 57, 54, 244),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
              width: 100, // Ajusta el ancho del contenedor
              height: 100, // Ajusta la altura del contenedor
              child: CircularProgressIndicator(
                strokeWidth: 10, // Ajusta el grosor del indicador
                value: calculateProgress() / 100,
                color: Colors.blue,
              ),
            ),
            SizedBox(
                height:
                    10), // Aumenta el espacio entre el CircularProgressIndicator y el texto
            Text(
              "${calculateProgress().toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height:
                    10), // Aumenta el espacio entre el texto y el mensaje adicional
            Text(
              "Progreso del recorrido",
              style: TextStyle(fontSize: 16, color: Colors.grey),
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


            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: Text("Validar Punto de Control con gps"),
            ),
            SizedBox(
                height:
                    40),
                  
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 255, 255, 255),
                    padding: EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: const Color.fromARGB(255, 24, 24, 24),
                      ),
                      Text(
                        ' Regresar',
                        style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 27, 27, 27)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
              // Aumenta el espacio entre el botón y el CircularProgressIndicator
            
        ],
      ),
    );
  }

  void validateCheckpoint() {
    if (currentCheckpointIndex < checkpoints.length) {
      Checkpoint currentCheckpoint = checkpoints[currentCheckpointIndex];
      double tolerance =
          0.0008; // Tolerancia para la comparación de coordenadas

      if ((currentLatitude - currentCheckpoint.latitude).abs() < tolerance &&
          (currentLongitude - currentCheckpoint.longitude).abs() < tolerance) {
        // Coordenadas válidas
        setState(() {
          currentCheckpoint.validated = true;
          currentCheckpoint.validationTime = DateTime.now();
          validationTimes.add(currentCheckpoint.validationTime); // Agregar la hora a la lista
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
    int validatedCheckpoints =
        checkpoints.where((checkpoint) => checkpoint.validated).length;
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

 Future<void> showTotalTime() async {
  
    _timer.cancel();
  
   int minutos = _elapsedSeconds ~/ 60;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Recorrido Finalizado"),
      content: Text(
        "Tiempo Total: ${minutos} minutos",
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
           
            // almacenar en la base de datos
            try {
              // Obtener el valor almacenado del ID del usuario desde SharedPreferences
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? userId = prefs.getString('userId');
             
              // Utilizar double.parse en lugar de int.parse
              double totalTime = calculateTotalTime();
              String formData = CreateJSON(userId!, minutos);

              await addRecorrido(formData);
            } catch (e, stackTrace) {
              print('Error en el botón: $e');
              print('Stack Trace: $stackTrace');
            }
          },
          child: Text("Ok"),
        ),
      ],
    ),
  );
}

  String CreateJSON(String user_id, int minutos) {
  // Crear el JSON
  Map<String, dynamic> jsonObject = {
    
    "user_id": user_id,
    "tiempo": minutos,
    "fecha":DateTime.now().toIso8601String(),
  };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);

    return formData;
  }

  Future<void> addRecorrido(String formData) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl + '/api/rondines/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
         final Map<String, dynamic> responseData = json.decode(response.body);
        final String rondinID = responseData['id'];
        final String uid = responseData['user_id'];
        ///almacenar en la base de datos los detalles del rondin
        ///
        AddDetalles(rondinID, uid );
/*
        // Éxito: Navegar a la pantalla de inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrado con éxito'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          
        );
        */
      } else {
        // Error: Mostrar un SnackBar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de servidor: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      print('Error al enviar los datos al backend: $e');
      // Mostrar un SnackBar con el mensaje de error de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No se pudo conectar al backend. Verifica tu conexión de red o inténtalo más tarde.'),
        ),
      );
    }
  }


   Future<void> AddDetalles(String RID, UID) async {
    try {

      //construiir json
Map<String, dynamic> jsonObject = {
    
    "id_rondin": RID,
  "user_id": UID,
  "fecha": DateTime.now().toString(),
  "point1": validationTimes[0].toString(),
  "point2": validationTimes[1].toString(),
  "point3": validationTimes[2].toString(),
  "point4": validationTimes[0].toString(),
  "point5":validationTimes[0].toString(),
  "point6": validationTimes[0].toString(),
  "point7": validationTimes[0].toString(),
  "point8": validationTimes[0].toString(),
  "point9": validationTimes[0].toString(),
  "point10": validationTimes[0].toString(),
  };

    // Convertir el Map en una cadena JSON
    String formData = jsonEncode(jsonObject);

      final response = await http.post(
        Uri.parse(backendUrl + '/api/rondines/details/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: formData,
      );

      if (response.statusCode == 200) {
        print("detalles agregados");

        // Éxito: Navegar a la pantalla de inicio de sesión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registrado con éxito'),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Error: Mostrar un SnackBar con el mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de servidor: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      print('Error al enviar los datos al backend: $e');
      // Mostrar un SnackBar con el mensaje de error de conexión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'No se pudo conectar al backend. Verifica tu conexión de red o inténtalo más tarde.'),
        ),
      );
    }
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
