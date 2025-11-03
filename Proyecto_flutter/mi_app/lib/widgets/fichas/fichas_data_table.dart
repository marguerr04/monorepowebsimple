// lib/widgets/fichas/fichas_data_table.dart
import 'package:flutter/material.dart';
import '../../models/ficha_medica.model.dart';

class FichasDataTable extends StatelessWidget {
  final List<FichaMedica> fichas;

  const FichasDataTable({super.key, required this.fichas});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: DataTable(
        columnSpacing: 20.0,
        columns: const [
          DataColumn(label: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Nombre Paciente', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Edad', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Diagnóstico', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Establecimiento', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: fichas.map((ficha) {
          return DataRow(
            cells: [
              DataCell(Text('F-${ficha.idFicha}')),
              DataCell(Text(ficha.nombrePaciente)),
              DataCell(Text(ficha.edad.toString())),
              DataCell(
                Tooltip(
                  message: ficha.diagnosticoPrincipal,
                  child: Text(
                    ficha.diagnosticoPrincipal.length > 25
                        ? '${ficha.diagnosticoPrincipal.substring(0, 25)}...'
                        : ficha.diagnosticoPrincipal,
                  ),
                ),
              ),
              DataCell(Text(ficha.establecimiento)),
              DataCell(Text(ficha.fechaFormateada)),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility_outlined),
                      tooltip: 'Ver Ficha',
                      color: Colors.blue.shade700,
                      onPressed: () => _verDetalles(ficha),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Editar Ficha',
                      color: Colors.green.shade700,
                      onPressed: () => _editarFicha(ficha),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Eliminar Ficha',
                      color: Colors.red.shade700,
                      onPressed: () => _eliminarFicha(ficha),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _verDetalles(FichaMedica ficha) {
    print('Ver detalles de: ${ficha.nombrePaciente}');
  }

  void _editarFicha(FichaMedica ficha) {
    print('Editar ficha: ${ficha.idFicha}');
  }

  void _eliminarFicha(FichaMedica ficha) {
    print('Eliminar ficha: ${ficha.idFicha}');
  }
}
