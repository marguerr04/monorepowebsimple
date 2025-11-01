import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/examen_stats.model.dart';

class ResultsBarChart extends StatelessWidget {
  final List<ExamenStats> data;

  const ResultsBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "📊 Estadísticas de Exámenes",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: data.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bar_chart, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("No hay estadísticas disponibles",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (data.length > value.toInt()) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      data[value.toInt()].tipoExamen,
                                      style: TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                }
                                return Text("");
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(value.toInt().toString());
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        barGroups: data.asMap().entries.map((entry) {
                          final index = entry.key;
                          final stats = entry.value;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: stats.aprobados.toDouble(),
                                color: Colors.green,
                                width: 16,
                              ),
                              BarChartRodData(
                                toY: stats.reprobados.toDouble(),
                                color: Colors.red,
                                width: 16,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
            if (data.isNotEmpty) ...[
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: Colors.green,
                      ),
                      SizedBox(width: 4),
                      Text("Aprobados", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text("Reprobados", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}