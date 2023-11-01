import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gráfico de Pastel Interactivo'),
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
        child: PieChart(
          PieChartData(
            sections: generateData(),
            
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> generateData() {
    return List.generate(4, (index) {
      final value = (index + 1) * 10.0;
      return PieChartSectionData(
        title: 'Sección $index',
        value: value,
        color: getRandomColor(),
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }

  Color getRandomColor() {
    return Color.fromARGB(
      255,
      (70 + 20 * 10) % 255,
      (100 + 40 * 10) % 255,
      (20 + 10 * 10) % 255,
    );
  }
}
