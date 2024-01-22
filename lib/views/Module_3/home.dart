import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:seguritl/views/CHAT/chatView.dart';
import 'package:seguritl/views/Module_4/Alimentos/AlimentosScreen.dart';
import 'package:seguritl/views/Module_4/Actividades/ActivitiesScreen.dart';
import 'package:seguritl/views/Module_4/Glucosa/GlucosaScreen.dart';
import 'package:seguritl/views/Module_1/info_screen.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../configBackend.dart';
import '../ACCESOS/accesos.dart';
import '../Incidencias/addIncidencias.dart';

import '../RONDINES/rondines.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Obtener la hora actual

  List<dynamic> info = [];

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener alimentos cuando se carga la pantalla
  }

  Future<void> getHomeInfo() async {
    try {
      final response = await http.get(Uri.parse(
          ApiConfig.backendUrl + '/api/Module4/GetGlucoseReadingsLast'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          info = jsonData;
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm').format(now);
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Image.asset(
            'lib/assets/FondoMenu.png', // Ruta de la imagen de fondo
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),

          // Contenedor en la parte superior con icono y fecha
// Contenedor en la parte superior con icono y fecha
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width *
                0.025, // Mover el contenedor al centro
            right: MediaQuery.of(context).size.width *
                0.025, // Mover el contenedor al centro
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.95, // Ancho del 95% de la pantalla
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(
                    66, 0, 0, 0), // Color de fondo con 20% de opacidad
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: 10.0,
                      sigmaY: 10.0), // Aplicar efecto de desenfoque
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.exit_to_app,
                              size: 30, // Tamaño del icono
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            onPressed: () {
                              // Aquí debes agregar la navegación a la pantalla deseada cuando se hace clic en el icono.
                              // Por ejemplo:
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return InfoScreen(); // Reemplaza OtraPantalla con la pantalla a la que deseas navegar.
                                },
                              ));
                            },
                          )),
                      Expanded(
                        child: Center(
                          child: Text(
                            '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                            style: TextStyle(
                              fontSize: 22,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 130,
            left: MediaQuery.of(context).size.width * 0.025,
            right: MediaQuery.of(context).size.width * 0.025,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(76, 0, 0, 0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        formattedTime.isNotEmpty
                            ? '$formattedTime'
                            : '0', // Puedes ajustar la condición según tu lógica
                        style: TextStyle(
                          fontSize: 100,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 233, 233, 233),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Text(
                    'Guardia',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 41, 41, 41),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    alignment:
                        WrapAlignment.center, // Alinea las filas en el centro
                    spacing: 13.0, // Espaciado entre las tarjetas
                    children: [
                      CardWithImageAndText(
                        'lib/assets/ICONS_CARD/glucosaIcon.png',
                        'Accesos',
                        140,
                        140,
                        70,
                        70,
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return QRValidationScreen(); // Reemplaza Pantalla1 con la pantalla que deseas abrir.
                            },
                          ));
                        },
                      ),
                      CardWithImageAndText(
                        'lib/assets/ICONS_CARD/comidasIcon.png',
                        'Incidencias',
                        140,
                        140,
                        70,
                        70,
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return AgregarIncidencia(); // Reemplaza Pantalla1 con la pantalla que deseas abrir.
                            },
                          ));
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    alignment:
                        WrapAlignment.center, // Alinea las filas en el centro
                    spacing: 13.0, // Espaciado entre las tarjetas
                    children: [
                      CardWithImageAndText(
                        'lib/assets/ICONS_CARD/actividadesIcon.png',
                        'Chat',
                        140,
                        140,
                        70,
                        70,
                        () {Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ChatScreen(); // Reemplaza Pantalla1 con la pantalla que deseas abrir.
                            },
                          ));},
                      ),
                      CardWithImageAndText(
                        'lib/assets/ICONS_CARD/statsIcon.png',
                        'Recorridos',
                        140,
                        140,
                        70,
                        70,
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return MyHomePage(); // Reemplaza Pantalla1 con la pantalla que deseas abrir.
                            },
                          ));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardWithImageAndText extends StatelessWidget {
  final String imagePath;
  final String cardText;
  final double cardWidth;
  final double cardHeight;
  final double imageWidth;
  final double imageHeight;
  final Function onTap; // Función de navegación personalizada

  CardWithImageAndText(this.imagePath, this.cardText, this.cardWidth,
      this.cardHeight, this.imageWidth, this.imageHeight, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap(); // Llamar a la función de navegación personalizada
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: imageWidth,
                height: imageHeight,
              ),
              SizedBox(height: 15),
              Text(
                cardText,
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 41, 41, 41),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EstadisticasScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Estadísticas'),
      ),
      // Aquí puedes construir el contenido de la pantalla de estadísticas
    );
  }
}
