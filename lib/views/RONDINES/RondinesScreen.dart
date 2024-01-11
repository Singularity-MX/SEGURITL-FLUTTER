import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/views/Incidencias/addIncidencias.dart';
import 'package:seguritl/views/Incidencias/vistaIncidencia.dart';
import 'package:seguritl/views/Module_3/home_admin.dart';
import 'package:seguritl/views/Usuarios/VerUsuarios/vistaAdmin.dart';
import 'package:seguritl/views/Usuarios/VerUsuarios/vistaGuardia.dart';
import 'package:seguritl/views/Usuarios/addUsers.dart';
import 'dart:convert';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Alimentos/modifyAlimentos.dart';
import 'package:seguritl/views/Module_4/Actividades/addActividades.dart';
import 'package:seguritl/views/Module_3/home.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RondinesScreen(),
    );
  }
}

class RondinesScreen extends StatefulWidget {
  @override
  _RondinesScreenState createState() => _RondinesScreenState();
}

class _RondinesScreenState extends State<RondinesScreen> {
  List<dynamic> lista = []; // Lista para almacenar los alimentos
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener alimentos cuando se carga la pantalla
    getRondines();
  }

  Future<void> getRondines() async {
    try {
      final response =
          await http.get(Uri.parse(ApiConfig.backendUrl + '/api/rondines'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          lista = jsonData;
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



  Future<void> eliminarRondin(String ID) async {
    try {
      // Construye la URL con el FID como parámetro
      final url = Uri.parse('${ApiConfig.backendUrl}/api/rondines/delete/$ID');

      // Realiza una solicitud al servidor para eliminar el alimento
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Si la eliminación se realiza correctamente, puedes actualizar la lista de alimentos
        getRondines();
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
      backgroundColor: Color.fromARGB(255, 233, 233, 233),
      body: Column(
        children: <Widget>[
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
          SizedBox(height: 20),
          /////////////////////////////////////////////////-> TXT BUSCAR
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: _searchController,
              onChanged: (text) {
                setState(() {
                  _searchText = text;
                });
              }, // Asignar el controlador
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF575757),
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                hintText: 'Buscar correo...',
                hintStyle: TextStyle(
                  color: Color(0xFF575757),
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Color(0xFFFF3B3B),
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search_sharp,
                  color: Color(0xFF777777),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final JSON = lista[index];

                // Filtra los alimentos que coinciden con la cadena de búsqueda
                if (_searchText.isNotEmpty &&
                    (JSON['guardia_email'] == null ||
                        !JSON['guardia_email']
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()))) {
                  return Container(); // Oculta el elemento si no coincide
                }

                return ListTile(
                  title: Text(JSON['guardia_email'] ?? 'Sin nombre'),
                  subtitle: Text(JSON['fecha'].toString() ?? 'Sin clasificación'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility), // Icono para "Ver"
                        onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Información del recorrido'),
                                content: Text(
                                  'Email: \n' +
                                      JSON['guardia_email'] 
                                      +'\n\nFecha: \n' +
                                      JSON['fecha'] +
                                      '\n\nTiempo total: \n' +
                                      JSON['tiempo'].toString() + ' minutos' 
                                      
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('Aceptar'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                 ],
                              );
                            },
                          );
                        
                        }
                      ),
                     
                      IconButton(
                        icon: Icon(Icons.delete), // Icono para "Eliminar"
                        onPressed: () {
                          // Mostrar un cuadro de diálogo de confirmación
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Eliminar cuenta'),
                                content: Text(
                                  '¿Estás seguro de que deseas eliminar ' +
                                      JSON['guardia_email'] +
                                      ' ?',
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el cuadro de diálogo
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text('Eliminar'),
                                    onPressed: () {
                                      // Aquí debes eliminar el alimento utilizando el FID
                                      final id= JSON['id'].toString();
                                      eliminarRondin(
                                          id); // Llama a la función para eliminar el alimento
                                      Navigator.of(context)
                                          .pop(); // Cerrar el cuadro de diálogo
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

          SizedBox(height: 20),
          /////////////////////////////////////////////////-> buttons

          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .center, // Alinea los botones en los extremos
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.50, // 37% del ancho de la pantalla
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Acción para el botón con icono
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreenAdmin()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 48, 48, 48),
                        padding: EdgeInsets.all(13.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Icon(
                        // Aquí especifica el icono que deseas mostrar
                        Icons
                            .home, // Puedes cambiar esto al icono que prefieras
                        size: 25, // Tamaño del icono
                      ),
                      label: Text(
                        '',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                 ],
              )),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
