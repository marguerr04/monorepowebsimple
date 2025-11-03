import 'package:flutter/material.dart';
import '../../models/ficha_medica.model.dart';
import '../../utils/app_colors.dart';

class FichasDataTable extends StatelessWidget {
  final List<FichaMedica> fichas;
  final Function(String fichaId) onView;
  final Function(int consultaId) onEdit;
  final Function(String fichaId) onDelete;

  const FichasDataTable({
    super.key,
    required this.fichas,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16.0, // ✅ REDUCIDO de 24 a 16
        headingRowHeight: 48.0,
        dataRowMaxHeight: 52.0,
        headingRowColor: MaterialStateProperty.all(AppColors.fondoClaro),
        columns: const [
          DataColumn(label: Text('ID Ficha')),
          DataColumn(label: Text('Paciente')),
          DataColumn(label: Text('Edad')),
          DataColumn(label: Text('Diagnóstico')),
          DataColumn(label: Text('Establecimiento')),
          DataColumn(label: Text('Fecha')),
          DataColumn(
            label: Text('Acciones'),
            numeric: true, // ✅ ALINEA A LA DERECHA
          ),
        ],
        rows: fichas.map((ficha) {
          return DataRow(
            cells: [
              DataCell(Text(ficha.idFicha)),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: Text(
                    ficha.nombrePaciente,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(Text(ficha.edad.toString())),
              DataCell(
                Tooltip(
                  message: ficha.diagnosticoPrincipal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Text(
                      ficha.diagnosticoPrincipal,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              DataCell(
                Tooltip(
                  message: ficha.establecimiento,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: Text(
                      ficha.establecimiento,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              DataCell(Text(ficha.fechaFormateada)),
              DataCell(
                Container(
                  constraints: const BoxConstraints(maxWidth: 120), // ✅ LIMITA ANCHO
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // ✅ OCUPA MÍNIMO ESPACIO
                    mainAxisAlignment: MainAxisAlignment.end, // ✅ ALINEA A LA DERECHA
                    children: [
                      // --- ✅ ACCIÓN "VER" (OJO) ---
                      IconButton(
                        padding: const EdgeInsets.all(4), // ✅ REDUCIDO
                        constraints: const BoxConstraints(minWidth: 32, maxWidth: 32), // ✅ TAMAÑO FIJO
                        icon: Icon(Icons.visibility_outlined, color: theme.primaryColor, size: 18),
                        tooltip: 'Ver Ficha Detallada',
                        onPressed: () {
                          print('Ver ficha: ${ficha.idFicha}');
                          onView(ficha.idFicha);
                        },
                      ),

                      // --- ✅ ACCIÓN "EDITAR" (LÁPIZ) ---
                      IconButton(
                        padding: const EdgeInsets.all(4), // ✅ REDUCIDO
                        constraints: const BoxConstraints(minWidth: 32, maxWidth: 32), // ✅ TAMAÑO FIJO
                        icon: const Icon(Icons.edit_outlined, color: AppColors.gris, size: 18),
                        tooltip: 'Editar Última Consulta',
                        onPressed: () {
                          print('✏️ Editar consulta: ${ficha.idConsulta}');
                          if (ficha.idConsulta == null) {
                            print('❌ No hay idConsulta para ${ficha.idFicha}');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('No hay consultas para editar en ${ficha.idFicha}'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          } else {
                            onEdit(ficha.idConsulta!);
                          }
                        },
                      ),

                      // --- ✅ ACCIÓN "BORRAR" (BASURA) ---
                      IconButton(
                        padding: const EdgeInsets.all(4), // ✅ REDUCIDO
                        constraints: const BoxConstraints(minWidth: 32, maxWidth: 32), // ✅ TAMAÑO FIJO
                        icon: Icon(Icons.delete_outline, color: Colors.red[700], size: 18),
                        tooltip: 'Eliminar Ficha',
                        onPressed: () {
                          print('🗑️ Eliminar ficha: ${ficha.idFicha}');
                          onDelete(ficha.idFicha);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}