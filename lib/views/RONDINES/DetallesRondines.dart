import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seguritl/views/Incidencias/addIncidencias.dart';
import 'package:seguritl/views/Incidencias/vistaIncidencia.dart';
import 'package:seguritl/views/Module_3/home_admin.dart';
import 'package:seguritl/views/RONDINES/RondinesScreen.dart';
import 'package:seguritl/views/Usuarios/VerUsuarios/vistaAdmin.dart';
import 'package:seguritl/views/Usuarios/VerUsuarios/vistaGuardia.dart';
import 'package:seguritl/views/Usuarios/addUsers.dart';
import 'dart:convert';
import '../../../configBackend.dart';
import 'package:seguritl/views/Module_4/Alimentos/modifyAlimentos.dart';
import 'package:seguritl/views/Module_4/Actividades/addActividades.dart';
import 'package:seguritl/views/Module_3/home.dart';

class DetallesRondines extends StatefulWidget {
  final Map<String, dynamic> Datos; // Datos del alimento a editar

  DetallesRondines({required this.Datos});
  @override
  _DetallesRondinesState createState() => _DetallesRondinesState();
}

class _DetallesRondinesState extends State<DetallesRondines> {
  List<dynamic> lista = []; // Lista para almacenar los alimentos
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  void initState() {
    super.initState();
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
          SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // Número de elementos en la lista
  itemBuilder: (context, index) {
    // Generar dinámicamente el título y el subtítulo para cada elemento
    String puntoTitle = 'Punto '+ (index + 1).toString();
    String puntoSubtitle = widget.Datos['point'+(index + 1).toString()] ?? 'Sin clasificación';

    return ListTile(
      title: Text(puntoTitle),
      subtitle: Text(puntoSubtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        
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
                              builder: (context) => RondinesScreen()),
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
