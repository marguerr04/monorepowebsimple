import 'package:flutter/material.dart';

class FichaDetailDialog extends StatelessWidget {
  final String fichaId;

  const FichaDetailDialog({super.key, required this.fichaId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detalles Ficha $fichaId'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Ficha: $fichaId'),
            const SizedBox(height: 16),
            const Text('Paciente: Juan Pérez González'),
            const Text('Edad: 33 años'),
            const Text('Diagnóstico: Infección Urinaria'),
            const Text('Establecimiento: Clínica Central'),
            const SizedBox(height: 16),
            const Text('📋 Información detallada aquí...'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}