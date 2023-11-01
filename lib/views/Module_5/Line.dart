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
          title: Text('Gráfico de Nivel de Glucosa'),
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
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              
            ),
            borderData: FlBorderData(show: true),
            gridData: FlGridData(show: true),
            minX: 0,
            maxX: 30,
            minY: 80,
            maxY: 120,
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                spots: generateData(),
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> generateData() {
    final Random random = Random();
    final List<FlSpot> data = List.generate(30, (index) {
      return FlSpot(
        index.toDouble(),
        80 + random.nextDouble() * 40,
      );
    });

    return data;
  }
}
