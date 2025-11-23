import 'package:flutter/material.dart';
import '../../models/consulta_model.dart';
import '../../utils/app_colors.dart';

class ConsultaDetailCard extends StatelessWidget {
  final Consulta consulta;
  final VoidCallback? onTap;

  const ConsultaDetailCard({
    super.key,
    required this.consulta,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con fecha y paciente
              Row(
                children: [
                  // Icono
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColors.cyanOscuro.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      color: AppColors.cyanOscuro,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Info principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Consulta #${consulta.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textoOscuro,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person, size: 16, color: AppColors.gris),
                            const SizedBox(width: 4),
                            Text(
                              'Paciente ID: ${consulta.pacienteId}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gris,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Fecha
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatDate(consulta.fecha),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textoOscuro,
                        ),
                      ),
                      Text(
                        _formatTime(consulta.fecha),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gris,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Diagnóstico
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.assignment, size: 16, color: AppColors.gris),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diagnóstico:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gris,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          consulta.diagnostico,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textoOscuro,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Tratamiento
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.healing, size: 16, color: AppColors.gris),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tratamiento:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gris,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          consulta.tratamiento,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textoOscuro,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Centro médico y observaciones (si existen)
              if (consulta.centroMedico != null || consulta.observaciones != null) ...[
                const SizedBox(height: 12),
                const Divider(color: AppColors.bordeClaro),
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    if (consulta.centroMedico != null) ...[
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.local_hospital, size: 14, color: AppColors.gris),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                consulta.centroMedico!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gris,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    if (consulta.observaciones != null) ...[
                      const Icon(Icons.note, size: 14, color: AppColors.gris),
                      const SizedBox(width: 4),
                      const Text(
                        'Con observaciones',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.gris,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              
              // Indicador de acción
              if (onTap != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Toca para ver detalles',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.cyanOscuro.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColors.cyanOscuro.withOpacity(0.7),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}