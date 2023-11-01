import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gráfico de Dispersión de Nivel de Glucosa'),
        ),
        body: GlucoseChartScreen(),
      ),
    );
  }
}

class GlucoseChartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ScatterChart(
          ScatterChartData(
            gridData: FlGridData(show: true),
            titlesData: FlTitlesData(show: false),
            borderData: FlBorderData(show: true),
            minX: 0,
            maxX: 30,
            minY: 80,
            maxY: 120,
            scatterSpots: generateData(),
          ),
        ),
      ),
    );
  }

  List<ScatterSpot> generateData() {
    final Random random = Random();
    final List<ScatterSpot> data = List.generate(30, (index) {
      return ScatterSpot(
        index.toDouble(),
        80 + random.nextDouble() * 40,
      );
    });

    return data;
  }
}
