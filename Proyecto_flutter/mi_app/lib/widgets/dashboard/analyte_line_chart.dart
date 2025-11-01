import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/analito_point.model.dart';

class AnalyteLineChart extends StatelessWidget {
  final List<AnalitoPoint> data;

  const AnalyteLineChart({super.key, required this.data});

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
              "📈 Historial de Glucosa",
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
                          Icon(Icons.show_chart, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("No hay datos disponibles", 
                               style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    )
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (data.length > value.toInt()) {
                                  final date = data[value.toInt()].fecha;
                                  return Text("${date.day}/${date.month}");
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
                        lineBarsData: [
                          LineChartBarData(
                            spots: data.asMap().entries.map((entry) {
                              final index = entry.key;
                              final point = entry.value;
                              return FlSpot(index.toDouble(), point.valor);
                            }).toList(),
                            isCurved: true,
                            color: Colors.blue,
                            dotData: FlDotData(show: true),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
            ),
            if (data.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                "Último valor: ${data.last.valor} (${data.last.fecha.day}/${data.last.fecha.month}/${data.last.fecha.year})",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}