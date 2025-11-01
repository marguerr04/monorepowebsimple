import 'package:flutter/material.dart';

class ChartPlaceholder extends StatelessWidget {
  final String title;
  final IconData icon;

  const ChartPlaceholder({
    super.key,
    required this.title,
    this.icon = Icons.pie_chart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Center(
            child: Icon(icon, size: 80, color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }
}
