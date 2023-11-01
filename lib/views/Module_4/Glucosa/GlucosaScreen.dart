import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configBackend.dart';
import 'package:flutter/material.dart';
import 'package:glucontrol_app/views/Module_4/Alimentos/modifyAlimentos.dart';
import 'package:glucontrol_app/views/Module_3/home.dart';

import 'RegistroGlucosa.dart';
import 'modifyActividades.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GlucosaScreen(),
    );
  }
}

class GlucosaScreen extends StatefulWidget {
  @override
  _GlucosaScreenState createState() => _GlucosaScreenState();
}

class _GlucosaScreenState extends State<GlucosaScreen> {
  List<dynamic> readings = []; // Lista para almacenar los alimentos

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener alimentos cuando se carga la pantalla
    getReadings();
  }

  Future<void> getReadings() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.backendUrl + '/api/Module4/GetGlucoseReadings'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          readings = jsonData;
        });
      } else {
        // Manejar errores si la solicitud no fue exitosa
        print('Error al obtener alimentos: ${response.statusCode}');
      }
    } catch (error) {
      // Manejar errores en la solicitud
      print('Error en la solicitud: $error');
    }
  }

  Future<void> eliminarLectura(String RID) async {
    try {
      // Construye la URL con el FID como parámetro
      final url =
          Uri.parse('${ApiConfig.backendUrl}/api/Module4/DeleteGlucoseReading/$RID');

      // Realiza una solicitud al servidor para eliminar el alimento
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Si la eliminación se realiza correctamente, puedes actualizar la lista de alimentos
        getReadings();
      } else {
        // Maneja errores si la eliminación no fue exitosa
        print('Error al eliminar el alimento: ${response.statusCode}');
      }
    } catch (error) {
      // Maneja errores en la solicitud
      print('Error en la solicitud: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actividades'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
             Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistroGlucosaScreen()),
                );
            },
            child: Text('Agregar lectura'),
          ),
          ElevatedButton(
            onPressed: () {
             Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
            },
            child: Text('Home'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: readings.length,
              itemBuilder: (context, index) {
                final glucoseData = readings[index];
                return ListTile(
                  title: Text(glucoseData['Glucose_level'].toString()+' mg/dL' + ' ('+glucoseData['Category']+')' ?? 'Sin nombre'),
                  subtitle: Text(
  glucoseData['Registration_date'] != null
      ? DateFormat('yyyy-MM-dd').format(DateTime.parse(glucoseData['Registration_date']))+' -> '+glucoseData['Hour']
      : 'Sin clasificación',
),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility), // Icono para "Ver"
                        onPressed: () {
                          // Acción para ver el alimento
                          // Puedes navegar a una pantalla de detalle aquí.
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Detalles de lectura'),
                                content: Text(
                                  'Fecha: '+glucoseData['Registration_date'].toString() + '\n' +
                                  'Hora: '+glucoseData['Hour'].toString() + '\n' +
                                  'Lectura: '+glucoseData['Glucose_level'].toString() + ' mg/dL' + '\n' +
                                  'Categoria: '+glucoseData['Category'] + '\n' +
                                  'Comida: '+glucoseData['FID'] + ' '+glucoseData['Cantidad'].toString() +' gramos'+ '\n' +
                                  'Actividad: '+glucoseData['AID'] + ' ' + glucoseData['Duration'].toString() + ' minutos',
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('Aceptar'),
                                    onPressed: () {
                                      // Aquí debes eliminar el alimento utilizando el FID
                                      Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.edit), // Icono para "Editar"
                        onPressed: () {
                          // Acción para editar el alimento
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ModificarActividadScreen(food: glucoseData),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete), // Icono para "Eliminar"
                        onPressed: () {
                          // Mostrar un cuadro de diálogo de confirmación
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Eliminar registro'),
                                content: Text(
                                  '¿Estás seguro de que deseas eliminar este registro?',
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text('Eliminar'),
                                    onPressed: () {
                                      // Aquí debes eliminar el alimento utilizando el FID
                                      final aid = glucoseData['RID']; // Obtener el FID del alimento
                                      eliminarLectura(aid); // Llama a la función para eliminar el alimento
                                      Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
