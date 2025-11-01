import 'package:flutter/material.dart';



class MetricSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? changePercentage; // Porcentaje de cambio (ej: "+50%")
  final Color? changeColor;      // Color para el porcentaje (verde o rojo)

  const MetricSummaryCard({
    super.key, // Esta sintaxis es correcta
    required this.title,
    required this.value,
    this.changePercentage,
    this.changeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded( // Usamos Expanded para que las tarjetas compartan el espacio horizontal
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2), // Sombra sutil
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Ajusta la altura al contenido
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              overflow: TextOverflow.ellipsis, // Evita desbordamiento de texto
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // Muestra la sección de cambio solo si se proporciona el porcentaje
            if (changePercentage != null) ...[ // Usamos '...' para añadir múltiples widgets condicionalmente
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    // Icono de flecha arriba o abajo según el color
                    changeColor == Colors.green ? Icons.arrow_upward : Icons.arrow_downward,
                    color: changeColor ?? Colors.grey,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    changePercentage!, // Usamos '!' porque ya comprobamos que no es null
                    style: TextStyle(color: changeColor ?? Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  // Añade "Por mes" solo si el título lo incluye (CORREGIDO)
                  if (title.toLowerCase().contains("por mes") || title.toLowerCase().contains("total"))
                    Text(
                      " Por mes",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

