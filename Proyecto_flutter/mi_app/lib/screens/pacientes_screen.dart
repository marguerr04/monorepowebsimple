import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../models/paciente_model.dart';
import '../services/pacientes_service.dart';
import '../utils/app_colors.dart';

class PacientesScreen extends StatefulWidget {
  const PacientesScreen({super.key});

  @override
  State<PacientesScreen> createState() => _PacientesScreenState();
}

class _PacientesScreenState extends State<PacientesScreen> {
  final PacientesService _pacientesService = PacientesService();
  
  List<Paciente> _pacientes = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int _selectedSidebarIndex = 4; // Índice 4 para Pacientes en el sidebar

  @override
  void initState() {
    super.initState();
    _loadPacientes();
  }

  Future<void> _loadPacientes() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final pacientes = await _pacientesService.getAllPacientes();
      if (!mounted) return;
      
      setState(() {
        _pacientes = pacientes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() => _isLoading = false);
      _showErrorSnackBar('Error cargando pacientes: $e');
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

  void _onSidebarItemSelected(int index) {
    setState(() => _selectedSidebarIndex = index);
    
    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1: // Fichas médicas
        Navigator.pushReplacementNamed(context, '/fichas');
        break;
      case 2: // Consultas
        Navigator.pushReplacementNamed(context, '/consultas');
        break;
      case 3: // Exámenes
        Navigator.pushReplacementNamed(context, '/examenes');
        break;
      case 4: // Pacientes (estamos aquí)
        break;
      case 5: // Cerrar sesión
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
  }

  List<Paciente> get _filteredPacientes {
    if (_searchQuery.isEmpty) return _pacientes;
    
    return _pacientes.where((paciente) {
      return paciente.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             paciente.apellido.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             paciente.rut.contains(_searchQuery) ||
             paciente.email?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
    }).toList();
  }

  String _getInitial(String text) {
    return text.isNotEmpty ? text[0].toUpperCase() : '?';
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
                // Header con título
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
                  child: const Row(
                    children: [
                      // Título y subtítulo
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gestión de Pacientes',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoOscuro,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Consulta y administra la información de los pacientes',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gris,
                              ),
                            ),
                          ],
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
                      hintText: 'Buscar por nombre, apellido, RUT o email...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),
                
                // Lista de pacientes
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyanOscuro),
                          ),
                        )
                      : _filteredPacientes.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: AppColors.gris,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isEmpty 
                                        ? 'No hay pacientes registrados'
                                        : 'No se encontraron pacientes',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: AppColors.gris,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isEmpty 
                                        ? 'Los pacientes se registran desde la aplicación móvil'
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
                              onRefresh: _loadPacientes,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(20.0),
                                itemCount: _filteredPacientes.length,
                                itemBuilder: (context, index) {
                                  final paciente = _filteredPacientes[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: _buildPacienteCard(paciente),
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

  Widget _buildPacienteCard(Paciente paciente) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () => _showPacienteDetails(paciente),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundColor: AppColors.cyanOscuro.withOpacity(0.1),
                radius: 30,
                child: Text(
                  '${_getInitial(paciente.nombre)}${_getInitial(paciente.apellido)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.cyanOscuro,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paciente.nombreCompleto,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textoOscuro,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.badge, size: 16, color: AppColors.gris),
                        const SizedBox(width: 4),
                        Text(
                          _pacientesService.formatearRut(paciente.rut),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.gris,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.cake, size: 16, color: AppColors.gris),
                        const SizedBox(width: 4),
                        Text(
                          '${paciente.edad} años',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.gris,
                          ),
                        ),
                        if (paciente.tipoSangre != null) ...[
                          const SizedBox(width: 16),
                          const Icon(Icons.bloodtype, size: 16, color: AppColors.gris),
                          const SizedBox(width: 4),
                          Text(
                            paciente.tipoSangre!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.gris,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (paciente.email != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16, color: AppColors.gris),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              paciente.email!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.gris,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Acciones
              Column(
                children: [
                  IconButton(
                    onPressed: () => _showConsultasPaciente(paciente),
                    icon: const Icon(Icons.medical_services),
                    color: AppColors.cyanOscuro,
                    tooltip: 'Ver consultas',
                  ),
                  IconButton(
                    onPressed: () => _showExamenesPaciente(paciente),
                    icon: const Icon(Icons.science),
                    color: AppColors.cyanOscuro,
                    tooltip: 'Ver exámenes',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPacienteDetails(Paciente paciente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(paciente.nombreCompleto),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('RUT: ${_pacientesService.formatearRut(paciente.rut)}'),
            const SizedBox(height: 8),
            Text('Edad: ${paciente.edad} años'),
            const SizedBox(height: 8),
            Text('Fecha nacimiento: ${paciente.fechaNacimientoFormatted}'),
            if (paciente.telefono != null) ...[
              const SizedBox(height: 8),
              Text('Teléfono: ${paciente.telefono}'),
            ],
            if (paciente.email != null) ...[
              const SizedBox(height: 8),
              Text('Email: ${paciente.email}'),
            ],
            if (paciente.direccion != null) ...[
              const SizedBox(height: 8),
              Text('Dirección: ${paciente.direccion}'),
            ],
            if (paciente.tipoSangre != null) ...[
              const SizedBox(height: 8),
              Text('Tipo de sangre: ${paciente.tipoSangre}'),
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

  void _showConsultasPaciente(Paciente paciente) {
    // TODO: Navegar a consultas del paciente específico
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Funcionalidad de consultas para ${paciente.nombreCompleto} próximamente'),
        backgroundColor: AppColors.cyanOscuro,
      ),
    );
  }

  void _showExamenesPaciente(Paciente paciente) {
    // TODO: Navegar a exámenes del paciente específico
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Funcionalidad de exámenes para ${paciente.nombreCompleto} próximamente'),
        backgroundColor: AppColors.cyanOscuro,
      ),
    );
  }
}