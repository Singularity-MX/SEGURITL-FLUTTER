import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configBackend.dart';
import 'package:flutter/material.dart';
import 'package:glucontrol_app/views/Module_4/Alimentos/modifyAlimentos.dart';
import 'package:glucontrol_app/views/Module_4/Alimentos/addAlimentos.dart';
import 'package:glucontrol_app/views/Module_3/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlimentosScreen(),
    );
  }
}

class AlimentosScreen extends StatefulWidget {
  @override
  _AlimentosScreenState createState() => _AlimentosScreenState();
}

class _AlimentosScreenState extends State<AlimentosScreen> {
  List<dynamic> alimentos = []; // Lista para almacenar los alimentos

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener alimentos cuando se carga la pantalla
    getAlimentos();
  }

  Future<void> getAlimentos() async {
    try {
      final response = await http
          .get(Uri.parse(ApiConfig.backendUrl + '/api/Module4/GetUserFoods'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          alimentos = jsonData;
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

  Future<void> eliminarAlimento(String fid) async {
    try {
      // Construye la URL con el FID como parámetro
      final url =
          Uri.parse('${ApiConfig.backendUrl}/api/Module4/DeleteFood/$fid');

      // Realiza una solicitud al servidor para eliminar el alimento
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Si la eliminación se realiza correctamente, puedes actualizar la lista de alimentos
        getAlimentos();
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
        title: Text('Alimentos'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
             Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgregarAlimentoScreen()),
                );
            },
            child: Text('Agregar Alimento'),
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
              itemCount: alimentos.length,
              itemBuilder: (context, index) {
                final food = alimentos[index];
                return ListTile(
                  title: Text(food['Food_name'] ?? 'Sin nombre'),
                  subtitle: Text(food['Classification'] ?? 'Sin clasificación'),
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
                                title: Text('Ver detalles de alimento'),
                                content: Text(
                                  food['FID'] + '\n' + food['Food_name'],
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
                              builder: (context) => EditarAlimentoScreen(food: food),
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
                                title: Text('Eliminar Alimento'),
                                content: Text(
                                  '¿Estás seguro de que deseas eliminar este alimento?',
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
                                      final fid = food['FID']; // Obtener el FID del alimento
                                      eliminarAlimento(fid); // Llama a la función para eliminar el alimento
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
