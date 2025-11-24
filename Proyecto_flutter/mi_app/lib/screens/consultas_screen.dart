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
                // Header mejorado con diseño moderno
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.cyanOscuro.withOpacity(0.1),
                        AppColors.cyanOscuro.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.cyanOscuro.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cyanOscuro.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.medical_information_rounded,
                          color: AppColors.cyanOscuro,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gestión de Consultas',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoOscuro,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: ${_consultas.length} consultas médicas registradas',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gris,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _showCreateConsultaDialog,
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Nueva Consulta'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cyanOscuro,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Barra de búsqueda mejorada
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.gris.withOpacity(0.2),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por diagnóstico, tratamiento o ID de paciente...',
                      hintStyle: TextStyle(color: AppColors.gris.withOpacity(0.6)),
                      prefixIcon: const Icon(Icons.search, color: AppColors.cyanOscuro),
                      filled: true,
                      fillColor: AppColors.fondoClaro,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.gris.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.cyanOscuro,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
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