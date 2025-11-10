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

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: 20.0,
              headingRowHeight: 52.0,
              dataRowHeight: 56.0,
              headingRowColor: MaterialStateProperty.all(AppColors.fondoClaro),
              columns: const [
                DataColumn(label: Text('ID Ficha')), // 
                DataColumn(label: Text('ID Consulta')), // 
                DataColumn(label: Text('Médico')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Altura (m)')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: fichas.map((ficha) {
                return DataRow(
                  cells: [
                    // ID Ficha (PRINCIPAL)
                    DataCell(
                      Tooltip(
                        message: 'Ficha ID: ${ficha.idFicha}',
                        child: Text(
                          ficha.idFicha, // ✅ MUESTRA SOLO EL ID FICHA
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue, // Destacar el ID ficha
                          ),
                        ),
                      ),
                    ),
                    
                    // ID Consulta
                    DataCell(
                      Tooltip(
                        message: 'Consulta ID: ${ficha.idConsulta}',
                        child: Text(
                          ficha.idConsulta != null ? 'C-${ficha.idConsulta}' : 'N/A',
                          style: TextStyle(
                            color: ficha.idConsulta != null ? Colors.black : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    
                    // Médico
                    DataCell(
                      Tooltip(
                        message: ficha.especialidadACargo,
                        child: Text(
                          ficha.especialidadACargo,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                    
                    // Fecha
                    DataCell(Text(ficha.fechaFormateada)),
                    
                    // Altura
                    DataCell(
                      Tooltip(
                        message: ficha.alturaFormateada,
                        child: Text(
                          ficha.alturaFormateada,
                          style: TextStyle(
                            color: ficha.alturaPaciente != null ? Colors.black : Colors.grey[600],
                            fontWeight: ficha.alturaPaciente != null ? FontWeight.normal : FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    
                    // Acciones
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // VER FICHA
                          IconButton(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(minWidth: 40, maxWidth: 40),
                            icon: Icon(Icons.visibility_outlined, color: theme.primaryColor, size: 20),
                            tooltip: 'Ver Ficha del Paciente',
                            onPressed: () => onView(ficha.idFicha),
                          ),

                          // EDITAR CONSULTA
                          IconButton(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(minWidth: 40, maxWidth: 40),
                            icon: const Icon(Icons.edit_outlined, color: AppColors.gris, size: 20),
                            tooltip: 'Editar Consulta',
                            onPressed: () {
                              if (ficha.idConsulta == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No hay consulta para editar en ${ficha.idFicha}'),
                                  ),
                                );
                              } else {
                                onEdit(ficha.idConsulta!);
                              }
                            },
                          ),

                          // ELIMINAR
                          IconButton(
                            padding: const EdgeInsets.all(6),
                            constraints: const BoxConstraints(minWidth: 40, maxWidth: 40),
                            icon: Icon(Icons.delete_outline, color: Colors.red[700], size: 20),
                            tooltip: 'Eliminar Consulta',
                            onPressed: () => onDelete(ficha.idFicha),
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