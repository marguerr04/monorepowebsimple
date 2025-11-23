import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../services/examenes_service.dart';
import '../models/examen_model.dart';
import '../utils/app_colors.dart';

class ExamenesScreen extends StatefulWidget {
  const ExamenesScreen({super.key});

  @override
  State<ExamenesScreen> createState() => _ExamenesScreenState();
}

class _ExamenesScreenState extends State<ExamenesScreen> {
  final ExamenesService _examenesService = ExamenesService();
  List<Examen> _examenes = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedSidebarIndex = 3;

  @override
  void initState() {
    super.initState();
    _loadExamenes();
  }

  void _onSidebarItemSelected(int index) {
    setState(() => _selectedSidebarIndex = index);
    
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/panel-control');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  Future<void> _loadExamenes() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final examenes = await _examenesService.getExamenes();
      if (!mounted) return;
      
      setState(() {
        _examenes = examenes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Error cargando exámenes: $e';
        _isLoading = false;
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  Color _getEstadoColor(String? estado) {
    switch (estado?.toLowerCase()) {
      case 'completado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'en proceso':
        return Colors.blue;
      default:
        return AppColors.gris;
    }
  }

  void _showExamenDetails(Examen examen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detalles del Examen'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('ID: ${examen.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Tipo: ${examen.tipoExamen}'),
              const SizedBox(height: 8),
              Text('Fecha: ${_formatearFecha(examen.fecha)}'),
              const SizedBox(height: 8),
              Text('Centro Médico: ${examen.centroMedico ?? 'No especificado'}'),
              const SizedBox(height: 8),
              Text('Estado: ${examen.estado ?? 'Sin estado'}'),
              const SizedBox(height: 8),
              Text('Resultado: ${examen.resultado}'),
              if (examen.observaciones != null) ...[
                const SizedBox(height: 8),
                Text('Observaciones: ${examen.observaciones!}'),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      body: Row(
        children: [
          AdminSidebar(
            selectedIndex: _selectedSidebarIndex,
            onItemSelected: _onSidebarItemSelected,
          ),
          
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.blanco,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gris.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.science,
                          color: Colors.orange,
                          size: 32,
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Exámenes Médicos',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoOscuro,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gestión de exámenes de laboratorio y diagnósticos',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gris,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      ElevatedButton.icon(
                        onPressed: _loadExamenes,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Actualizar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Expanded(
                  child: _isLoading 
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.orange),
                            SizedBox(height: 16),
                            Text('Cargando exámenes...'),
                          ],
                        ),
                      )
                    : _errorMessage != null 
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red, size: 64),
                              const SizedBox(height: 16),
                              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 16),
                              ElevatedButton(onPressed: _loadExamenes, child: const Text('Reintentar')),
                            ],
                          ),
                        )
                      : _examenes.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.science_outlined, color: AppColors.gris, size: 64),
                                SizedBox(height: 16),
                                Text('No hay exámenes registrados', style: TextStyle(fontSize: 18, color: AppColors.gris)),
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total de exámenes: ${_examenes.length}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textoOscuro,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _examenes.length,
                                    itemBuilder: (context, index) {
                                      final examen = _examenes[index];
                                      return Card(
                                        elevation: 2,
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        child: ListTile(
                                          leading: const Icon(Icons.science, color: Colors.orange),
                                          title: Text(examen.tipoExamen),
                                          subtitle: Text('Fecha: ${_formatearFecha(examen.fecha)}'),
                                          trailing: Text(
                                            examen.estado ?? 'Sin estado',
                                            style: TextStyle(
                                              color: _getEstadoColor(examen.estado),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onTap: () => _showExamenDetails(examen),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}