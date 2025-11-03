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

    // ✅ SOLUCIÓN: Usar LayoutBuilder para forzar la expansión
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth), // ✅ FORZAR ANCHO MÁXIMO
            child: DataTable(
              columnSpacing: 20.0,
              headingRowHeight: 52.0,
              dataRowHeight: 56.0,
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
                  numeric: true,
                ),
              ],
              rows: fichas.map((ficha) {
                return DataRow(
                  cells: [
                    // ✅ QUITAR ConstrainedBox - dejar que se expanda
                    DataCell(Text(ficha.idFicha)),
                    
                    // ✅ QUITAR ConstrainedBox - dejar que se expanda
                    DataCell(
                      Tooltip(
                        message: ficha.nombrePaciente,
                        child: Text(
                          ficha.nombrePaciente,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    
                    DataCell(Text(ficha.edad.toString())),
                    
                    // ✅ QUITAR ConstrainedBox - dejar que se expanda
                    DataCell(
                      Tooltip(
                        message: ficha.diagnosticoPrincipal,
                        child: Text(
                          ficha.diagnosticoPrincipal,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    
                    // ✅ QUITAR ConstrainedBox - dejar que se expanda
                    DataCell(
                      Tooltip(
                        message: ficha.establecimiento,
                        child: Text(
                          ficha.establecimiento,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    
                    DataCell(Text(ficha.fechaFormateada)),
                    
                    // ✅ QUITAR Container con constraints - dejar que se expanda
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // --- ✅ ACCIÓN "VER" (OJO) ---
                          IconButton(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              maxWidth: 40,
                            ),
                            icon: Icon(
                              Icons.visibility_outlined, 
                              color: theme.primaryColor, 
                              size: 20,
                            ),
                            tooltip: 'Ver Ficha Detallada',
                            onPressed: () {
                              print('Ver ficha: ${ficha.idFicha}');
                              onView(ficha.idFicha);
                            },
                          ),

                          // --- ✅ ACCIÓN "EDITAR" (LÁPIZ) ---
                          IconButton(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              maxWidth: 40,
                            ),
                            icon: const Icon(
                              Icons.edit_outlined, 
                              color: AppColors.gris, 
                              size: 20,
                            ),
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
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              maxWidth: 40,
                            ),
                            icon: Icon(
                              Icons.delete_outline, 
                              color: Colors.red[700], 
                              size: 20,
                            ),
                            tooltip: 'Eliminar Ficha',
                            onPressed: () {
                              print('🗑️ Eliminar ficha: ${ficha.idFicha}');
                              onDelete(ficha.idFicha);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}