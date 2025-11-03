import 'package:flutter/material.dart';

class ConsultaEditDialog extends StatefulWidget {
  final int consultaId;

  const ConsultaEditDialog({super.key, required this.consultaId});

  @override
  State<ConsultaEditDialog> createState() => _ConsultaEditDialogState();
}

class _ConsultaEditDialogState extends State<ConsultaEditDialog> {
  final _diagnosticoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _diagnosticoController.text = 'Diagnóstico actual...';
  }

  @override
  void dispose() {
    _diagnosticoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Consulta ${widget.consultaId}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Consulta ID: 10'),
            const Text('Fecha: 15/06/2024'),
            const Text('Médico: Dra. Carolina Soto'),
            const SizedBox(height: 16),
            TextField(
              controller: _diagnosticoController,
              decoration: const InputDecoration(
                labelText: 'Diagnóstico',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            print('Guardando diagnóstico: ${_diagnosticoController.text}');
            Navigator.pop(context, true); // Retorna true indicando éxito
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}