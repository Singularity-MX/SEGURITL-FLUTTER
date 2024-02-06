import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/views/Incidencias/addIncidencias.dart';
import 'package:seguritl/views/Incidencias/addIncidenciasADMIN.dart';
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
      home: incidenciasScreen(),
    );
  }
}

class incidenciasScreen extends StatefulWidget {
  @override
  _incidenciasScreenState createState() => _incidenciasScreenState();
}

class _incidenciasScreenState extends State<incidenciasScreen> {
  List<dynamic> lista = []; // Lista para almacenar los alimentos
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener alimentos cuando se carga la pantalla
    getIncidencias();
  }

  Future<void> getIncidencias() async {
    try {
      final response =
          await http.get(Uri.parse(ApiConfig.backendUrl + '/api/incidencias'));
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

  Future<void> eliminarActividad(String AID) async {
    try {
      // Construye la URL con el FID como parámetro
      final url = Uri.parse('${ApiConfig.backendUrl}/api/incidencias/delete/$AID');

      // Realiza una solicitud al servidor para eliminar el alimento
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Si la eliminación se realiza correctamente, puedes actualizar la lista de alimentos
        getIncidencias();
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
                  color: const Color.fromRGBO(88, 148, 245, 1),
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
                hintText: 'Buscar ...',
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
                    color: const Color.fromRGBO(88, 148, 245, 1),
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
                    (JSON['tipo'] == null ||
                        !JSON['tipo']
                            .toLowerCase()
                            .contains(_searchText.toLowerCase()))) {
                  return Container(); // Oculta el elemento si no coincide
                }

                return ListTile(
                  title: Text(JSON['tipo'] ?? 'Sin nombre'),
                  subtitle: Text(JSON['comentario'] ?? 'Sin clasificación'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility), // Icono para "Ver"
                        onPressed: () {
                        
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VistaIncidencia(informacion:JSON)),
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
                                title: Text('Eliminar registro'),
                                content: Text(
                                  '¿Estás seguro de que deseas eliminar ' +
                                      JSON['tipo'] +
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
                                      final fid = JSON[
                                          'id']; // Obtener el FID del alimento
                                      eliminarActividad(
                                          fid); // Llama a la función para eliminar el alimento
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
                    .spaceBetween, // Alinea los botones en los extremos
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.37, // 37% del ancho de la pantalla
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
                        primary: Color.fromRGBO(31, 52, 87, 1),
                        padding: EdgeInsets.all(13.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      icon: Icon(
                        // Aquí especifica el icono que deseas mostrar
                        Icons
                            .home, // Puedes cambiar esto al icono que prefieras
                        size: 25, 
                        color: Colors.white,// Tamaño del icono
                      ),
                      label: Text(
                        '',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.37, // 37% del ancho de la pantalla
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción para el segundo botón
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddIncidenciaAdmin()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(31, 52, 87, 1),
                        padding: EdgeInsets.all(13.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Icon(
                        Icons.add, // Icono de un signo de suma
                        size: 25, // Tamaño del icono
                        color: Colors.white, // Color del icono
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
