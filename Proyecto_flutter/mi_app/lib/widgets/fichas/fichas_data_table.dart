// lib/widgets/fichas/fichas_data_table.dart
import 'package:flutter/material.dart';
import '../../models/ficha_medica.model.dart'; // Importa el archivo con ambos modelos

class FichasDataTable extends StatelessWidget {
  const FichasDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. GENERAR DATOS DUMMY CON EL NUEVO MODELO 'FichaResumen'
    final List<FichaResumen> fichas = List.generate(
      15,
      (index) {
        final patologiasList = [
          ['Diabetes', 'Hipertensión'],
          ['Ansiedad'],
          ['Obesidad', 'Respiratoria'],
          ['Ninguna']
        ];
        
        final nombres = ['Juan Pérez González', 'María Angélica Soto', 'Carlos Núñez Rojas', 'Ana Contreras Lagos'];
        final edades = [45, 62, 31, 50];
        final ids = ['P-****-6789', 'A-****-543K', 'M-****-1122', 'F-****-5556'];

        return FichaResumen(
          idPacienteAnonimizado: ids[index % 4],
          nombrePaciente: nombres[index % 4],
          edad: edades[index % 4],
          patologias: patologiasList[index % 4],
          ultimaActualizacion: DateTime.now().subtract(Duration(days: index * 10)),
          tienePdf: index % 2 == 0, // Alternar para mostrar/ocultar icono PDF
        );
      },
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0), // Añadido padding interno
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
        // 2. DEFINIR LAS NUEVAS COLUMNAS
        columns: const [
          DataColumn(label: Text('ID Paciente (Anonimizado)', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Nombre Paciente', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Edad', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Patologías (Tags)', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Última Actualización', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Acciones', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        // 3. MAPEAR LOS DATOS DE 'FichaResumen' A LAS FILAS
        rows: fichas.map((ficha) {
          return DataRow(cells: [
            DataCell(Text(ficha.idPacienteAnonimizado)),
            DataCell(Text(ficha.nombrePaciente)),
            DataCell(Text(ficha.edad.toString())),
            DataCell(
              // Usamos Wrap para que los chips se ajusten si no caben
              Wrap(
                spacing: 4.0, // Espacio horizontal entre chips
                runSpacing: 4.0, // Espacio vertical si hay varias líneas
                children: ficha.patologias.map((patologia) {
                  return Chip(
                    label: Text(patologia),
                    backgroundColor: _getPatologiaColor(patologia),
                    labelStyle: const TextStyle(color: Colors.black87, fontSize: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    visualDensity: VisualDensity.compact, // Chip más pequeño
                  );
                }).toList(),
              ),
            ),
            DataCell(Text(ficha.fechaActualizacionFormateada)),
            DataCell(
              // 4. AÑADIR ICONOS DE ACCIONES
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility_outlined),
                    onPressed: () { /* Lógica para ver detalle */ },
                    tooltip: 'Ver Ficha',
                    color: Colors.blue.shade700,
                  ),
                  if (ficha.tienePdf) // Mostrar solo si tiene PDF
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                      onPressed: () { /* Lógica para descargar PDF */ },
                      tooltip: 'Descargar PDF',
                      color: Colors.red.shade700,
                    ),
                  IconButton(
                    icon: const Icon(Icons.archive_outlined),
                    onPressed: () { /* Lógica para archivar */ },
                    tooltip: 'Archivar',
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  // 5. HELPER PARA DAR COLOR A LOS CHIPS DE PATOLOGÍA
  Color _getPatologiaColor(String patologia) {
    switch (patologia.toLowerCase()) {
      case 'diabetes':
        return Colors.green.shade100;
      case 'hipertensión':
        return Colors.blue.shade100;
      case 'ansiedad':
        return Colors.yellow.shade100;
      case 'obesidad':
        return Colors.orange.shade100;
      case 'respiratoria':
        return Colors.cyan.shade100;
      default:
        return Colors.grey.shade200;
    }
  }
}