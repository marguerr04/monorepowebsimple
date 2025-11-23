import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../models/consulta_model.dart';
import '../services/consultas_service.dart';
import '../services/pacientes_service.dart';
import '../utils/app_colors.dart';
import '../widgets/consultas/consulta_form_dialog.dart';
import '../widgets/consultas/consulta_detail_card.dart';

class ConsultasScreen extends StatefulWidget {
  const ConsultasScreen({super.key});

  @override
  State<ConsultasScreen> createState() => _ConsultasScreenState();
}

class _ConsultasScreenState extends State<ConsultasScreen> {
  final ConsultasService _consultasService = ConsultasService();
  final PacientesService _pacientesService = PacientesService();
  
  List<Consulta> _consultas = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedSidebarIndex = 1; // Índice 1 para Panel de Control cuando estamos en consultas

  @override
  void initState() {
    super.initState();
    _loadConsultas();
  }

  Future<void> _loadConsultas() async {
    setState(() => _isLoading = true);
    
    try {
      final consultas = await _consultasService.getConsultas();
      setState(() {
        _consultas = consultas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error cargando consultas: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showCreateConsultaDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const ConsultaFormDialog(),
    );
    
    if (result == true) {
      _showSuccessSnackBar('Consulta creada exitosamente');
      _loadConsultas(); // Refrescar la lista
    }
  }

  void _onSidebarItemSelected(int index) {
    setState(() => _selectedSidebarIndex = index);
    
    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1: // Panel de Control
        Navigator.pushReplacementNamed(context, '/panel-control');
        break;
      case 2: // Cerrar sesión
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  List<Consulta> get _filteredConsultas {
    if (_searchQuery.isEmpty) return _consultas;
    
    return _consultas.where((consulta) {
      return consulta.diagnostico.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             consulta.tratamiento.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             consulta.pacienteId.toString().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      body: Row(
        children: [
          // Sidebar
          AdminSidebar(
            selectedIndex: _selectedSidebarIndex,
            onItemSelected: _onSidebarItemSelected,
          ),
          
          // Contenido principal
          Expanded(
            child: Column(
              children: [
                // Header con título y botón crear
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: AppColors.blanco,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Título y subtítulo
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gestión de Consultas',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoOscuro,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Administra las consultas médicas del sistema',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gris,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Botón crear consulta
                      ElevatedButton.icon(
                        onPressed: _showCreateConsultaDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Nueva Consulta'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cyanOscuro,
                          foregroundColor: AppColors.blanco,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Barra de búsqueda
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: AppColors.blanco,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar por diagnóstico, tratamiento o ID de paciente...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
                
                // Lista de consultas
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyanOscuro),
                          ),
                        )
                      : _filteredConsultas.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.medical_services_outlined,
                                    size: 64,
                                    color: AppColors.gris,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isEmpty 
                                        ? 'No hay consultas registradas'
                                        : 'No se encontraron consultas',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.gris,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isEmpty 
                                        ? 'Crea la primera consulta presionando el botón "Nueva Consulta"'
                                        : 'Intenta con otro término de búsqueda',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.gris,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadConsultas,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(20.0),
                                itemCount: _filteredConsultas.length,
                                itemBuilder: (context, index) {
                                  final consulta = _filteredConsultas[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: ConsultaDetailCard(
                                      consulta: consulta,
                                      onTap: () => _showConsultaDetails(consulta),
                                    ),
                                  );
                                },
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

  void _showConsultaDetails(Consulta consulta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Consulta #${consulta.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Paciente ID: ${consulta.pacienteId}'),
            const SizedBox(height: 8),
            Text('Fecha: ${consulta.fecha.toLocal().toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Diagnóstico: ${consulta.diagnostico}'),
            const SizedBox(height: 8),
            Text('Tratamiento: ${consulta.tratamiento}'),
            if (consulta.observaciones != null) ...[
              const SizedBox(height: 8),
              Text('Observaciones: ${consulta.observaciones}'),
            ],
            if (consulta.centroMedico != null) ...[
              const SizedBox(height: 8),
              Text('Centro Médico: ${consulta.centroMedico}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}