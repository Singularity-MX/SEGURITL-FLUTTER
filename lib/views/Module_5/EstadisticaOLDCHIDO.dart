import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configBackend.dart';

class GlucoseChartScreen extends StatefulWidget {
  @override
  _GlucoseChartScreenState createState() => _GlucoseChartScreenState();
}

class _GlucoseChartScreenState extends State<GlucoseChartScreen> {
  List<Map<String, dynamic>> glucoseData = [];

  @override
  void initState() {
    super.initState();
    // Obtener los datos de glucosa desde tu API
    fetchData();
  }

  Future<void> fetchData() async {
    // Realiza una solicitud HTTP para obtener los datos de glucosa
    final response = await http.get(Uri.parse(ApiConfig.backendUrl + '/api/Module4/GetGlucoseReadings'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        glucoseData = data;
      });
    } else {
      // Manejar errores si la solicitud no fue exitosa
      print('Error al obtener datos de glucosa: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica de Nivel de Glucosa'),
      ),
      body: Center(
        child: glucoseData.isEmpty
            ? CircularProgressIndicator() // Muestra un indicador de carga si los datos están vacíos
            : Column(
                children: <Widget>[
                  LineChart(
                    LineChartData(
                      // Configura tu gráfica aquí
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      minX: 0,
                      maxX: glucoseData.length.toDouble(),
                      minY: 0,
                      maxY: 250, // Ajusta el rango según tus datos
                      lineBarsData: [
                        LineChartBarData(
                          spots: glucoseData
                              .asMap()
                              .entries
                              .map((entry) =>
                                  FlSpot(entry.key.toDouble(), entry.value['Glucose_level'].toDouble()))
                              .toList(),
                          isCurved: true,
                          belowBarData: BarAreaData(show: false),
                          color: Colors.blue, // Color de la línea
                          dotData: const FlDotData(show: false),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: charts.LineChart(
                      _createSampleData(), // Crea un gráfico interactivo de "charts_flutter"
                      animate: true,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Método para crear datos de muestra para "charts_flutter"
  List<charts.Series<GlucoseData, int>> _createSampleData() {
    final data = glucoseData
        .map((entry) => GlucoseData(
              entry['Glucose_level'],
              entry['FID'],
              entry['AID'],
            ))
        .toList();

    return [
      charts.Series<GlucoseData, int>(
        id: 'glucoseData',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GlucoseData data, _) => data.glucoseLevel,
        measureFn: (GlucoseData data, _) => data.glucoseLevel,
        data: data,
        labelAccessorFn: (GlucoseData data, _) => '${data.fid}, ${data.aid}',
      ),
    ];
  }
}

class GlucoseData {
  final int glucoseLevel;
  final String fid;
  final String aid;

  GlucoseData(this.glucoseLevel, this.fid, this.aid);
}
