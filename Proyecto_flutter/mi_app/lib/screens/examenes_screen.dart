import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../services/examenes_service.dart';
import '../models/examen_model.dart';
import '../utils/app_colors.dart';

class ExamenesScreen extends StatefulWidget {
  final int? fichaIdInicial;
  
  const ExamenesScreen({super.key, this.fichaIdInicial});

  @override
  State<ExamenesScreen> createState() => _ExamenesScreenState();
}

class _ExamenesScreenState extends State<ExamenesScreen> {
  final ExamenesService _examenesService = ExamenesService();
  List<Examen> _examenes = [];
  List<Examen> _examenesFiltered = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedSidebarIndex = 3;
  
  // Controladores para búsqueda
  final TextEditingController _fichaIdController = TextEditingController();
  final TextEditingController _examenIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExamenes();
    
    // Si se recibió un fichaId inicial, aplicar el filtro automáticamente
    if (widget.fichaIdInicial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fichaIdController.text = widget.fichaIdInicial.toString();
        _filtrarExamenes();
      });
    }
  }

  @override
  void dispose() {
    _fichaIdController.dispose();
    _examenIdController.dispose();
    super.dispose();
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
        _examenesFiltered = examenes;
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

  void _filtrarExamenes() {
    final fichaText = _fichaIdController.text.trim();
    final examenText = _examenIdController.text.trim();
    
    // Si ambos campos están vacíos, mostrar todos
    if (fichaText.isEmpty && examenText.isEmpty) {
      setState(() => _examenesFiltered = _examenes);
      return;
    }

    setState(() {
      _examenesFiltered = _examenes.where((examen) {
        bool matchFicha = true;
        bool matchExamen = true;
        
        // Filtro por ID de Ficha (comparación exacta)
        if (fichaText.isNotEmpty) {
          // Limpiar el texto de búsqueda (remover F- si existe)
          String fichaSearch = fichaText.toUpperCase().replaceAll('F-', '').replaceAll('f-', '');
          
          if (examen.fichaMedicaId != null) {
            matchFicha = examen.fichaMedicaId.toString() == fichaSearch;
          } else {
            matchFicha = false;
          }
        }
        
        // Filtro por ID de Examen (comparación exacta)
        if (examenText.isNotEmpty) {
          matchExamen = examen.id.toString() == examenText;
        }
        
        return matchFicha && matchExamen;
      }).toList();
    });

    // Mostrar mensaje según resultados
    if (_examenesFiltered.isEmpty) {
      _showInfoSnackBar('No se encontraron exámenes con los filtros: ${fichaText.isNotEmpty ? "Ficha: $fichaText" : ""} ${examenText.isNotEmpty ? "Examen: $examenText" : ""}');
    } else {
      _showSuccessSnackBar('Se encontraron ${_examenesFiltered.length} examen(es)');
    }
  }

  void _limpiarFiltros() {
    setState(() {
      _fichaIdController.clear();
      _examenIdController.clear();
      _examenesFiltered = _examenes;
    });
    _showSuccessSnackBar('Filtros limpiados - Mostrando ${_examenes.length} exámenes');
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
        title: Row(
          children: [
            const Icon(Icons.science, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Detalles del Examen'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Información del paciente
              if (examen.pacienteNombre != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cyanOscuro.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person, size: 16, color: AppColors.cyanOscuro),
                          const SizedBox(width: 6),
                          const Text(
                            'Paciente',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.cyanOscuro,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Nombre: ${examen.pacienteNombre}'),
                      if (examen.pacienteRut != null) ...[
                        const SizedBox(height: 2),
                        Text('RUT: ${examen.pacienteRut}'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              // Información del examen
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tag, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          'ID Examen: ${examen.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (examen.fichaMedicaId != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.purple.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.folder, size: 14, color: Colors.purple),
                          const SizedBox(width: 4),
                          Text(
                            'Ficha: F-${examen.fichaMedicaId}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const Divider(height: 16),
              Row(
                children: [
                  const Icon(Icons.science_outlined, size: 16, color: AppColors.gris),
                  const SizedBox(width: 6),
                  Expanded(child: Text('Tipo: ${examen.tipoExamen}')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.gris),
                  const SizedBox(width: 6),
                  Text('Fecha: ${_formatearFecha(examen.fecha)}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.gris),
                  const SizedBox(width: 6),
                  Expanded(child: Text('Centro: ${examen.centroMedico ?? 'No especificado'}')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.info_outlined, size: 16, color: AppColors.gris),
                  const SizedBox(width: 6),
                  Text('Estado: ${examen.estado ?? 'Sin estado'}'),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Resultado:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.fondoClaro,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(examen.resultado),
              ),
              if (examen.observaciones != null) ...[
                const SizedBox(height: 8),
                const Text('Observaciones:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(examen.observaciones!),
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
                
                // Sección de búsqueda
                Container(
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(24.0),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.filter_list_rounded, color: Colors.orange, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Filtros de Búsqueda',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textoOscuro,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Busca exámenes por ID de Ficha o ID de Examen',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gris,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Campo ID Ficha con label
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.purple.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.folder, size: 14, color: Colors.purple),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Buscar por ID de Ficha Médica',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _fichaIdController,
                                  decoration: InputDecoration(
                                    labelText: 'ID de Ficha',
                                    hintText: 'Ej: 1, F-1, F-95',
                                    hintStyle: TextStyle(color: AppColors.gris.withOpacity(0.6)),
                                    prefixIcon: const Icon(Icons.folder_outlined, color: Colors.purple),
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
                                    color: Colors.orange,
                                    width: 2,
                                  ),
                                ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  onSubmitted: (_) => _filtrarExamenes(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Campo ID Examen con label
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.assignment, size: 14, color: Colors.blue),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'Buscar por ID de Examen',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _examenIdController,
                                  decoration: InputDecoration(
                                    labelText: 'ID de Examen',
                                    hintText: 'Ej: 1, 25, 100',
                                    hintStyle: TextStyle(color: AppColors.gris.withOpacity(0.6)),
                                    prefixIcon: const Icon(Icons.assignment_outlined, color: Colors.blue),
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
                                    color: Colors.orange,
                                    width: 2,
                                  ),
                                ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  onSubmitted: (_) => _filtrarExamenes(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Botón Buscar
                          ElevatedButton.icon(
                            onPressed: _filtrarExamenes,
                            icon: const Icon(Icons.search, size: 18),
                            label: const Text('Buscar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Botón Limpiar
                          OutlinedButton.icon(
                            onPressed: _limpiarFiltros,
                            icon: const Icon(Icons.clear, size: 18),
                            label: const Text('Limpiar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.gris,
                              side: BorderSide(color: AppColors.gris.withOpacity(0.5)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
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
                      : _examenesFiltered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off, color: AppColors.gris, size: 64),
                                const SizedBox(height: 16),
                                Text(
                                  _examenes.isEmpty 
                                    ? 'No hay exámenes registrados' 
                                    : 'No se encontraron exámenes con los filtros aplicados',
                                  style: const TextStyle(fontSize: 18, color: AppColors.gris),
                                ),
                                if (_examenes.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  TextButton.icon(
                                    onPressed: _limpiarFiltros,
                                    icon: const Icon(Icons.clear),
                                    label: const Text('Limpiar filtros'),
                                  ),
                                ],
                              ],
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.science, size: 16, color: Colors.orange),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Mostrando ${_examenesFiltered.length} de ${_examenes.length} exámenes',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_examenesFiltered.length < _examenes.length) ...[
                                      const SizedBox(width: 12),
                                      TextButton.icon(
                                        onPressed: _limpiarFiltros,
                                        icon: const Icon(Icons.clear, size: 16),
                                        label: const Text('Limpiar filtros'),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _examenesFiltered.length,
                                    itemBuilder: (context, index) {
                                      final examen = _examenesFiltered[index];
                                      final estadoColor = _getEstadoColor(examen.estado);
                                      
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.gris.withOpacity(0.2),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.05),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () => _showExamenDetails(examen),
                                            borderRadius: BorderRadius.circular(12),
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Row(
                                                children: [
                                                  // Icono con fondo
                                                  Container(
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: BoxDecoration(
                                                      color: Colors.orange.withOpacity(0.15),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Icon(
                                                      Icons.science,
                                                      color: Colors.orange,
                                                      size: 24,
                                                    ),
                                                  ),
                                                  
                                                  const SizedBox(width: 16),
                                                  
                                                  // Contenido principal
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          examen.tipoExamen,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600,
                                                            color: AppColors.textoOscuro,
                                                          ),
                                                        ),
                                                        const SizedBox(height: 4),
                                                        // Nombre del paciente
                                                        if (examen.pacienteNombre != null) ...[
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.person_outline,
                                                                size: 14,
                                                                color: AppColors.cyanOscuro,
                                                              ),
                                                              const SizedBox(width: 4),
                                                              Text(
                                                                examen.pacienteDisplay,
                                                                style: const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w500,
                                                                  color: AppColors.cyanOscuro,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 6),
                                                        ],
                                                        // Fila de IDs
                                                        Row(
                                                          children: [
                                                            // ID Examen
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                              decoration: BoxDecoration(
                                                                color: Colors.blue.withOpacity(0.1),
                                                                borderRadius: BorderRadius.circular(6),
                                                                border: Border.all(
                                                                  color: Colors.blue.withOpacity(0.3),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize: MainAxisSize.min,
                                                                children: [
                                                                  const Icon(Icons.tag, size: 10, color: Colors.blue),
                                                                  const SizedBox(width: 3),
                                                                  Text(
                                                                    'ID: ${examen.id}',
                                                                    style: const TextStyle(
                                                                      fontSize: 11,
                                                                      fontWeight: FontWeight.w600,
                                                                      color: Colors.blue,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(width: 6),
                                                            // ID Ficha
                                                            if (examen.fichaMedicaId != null)
                                                              Container(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.purple.withOpacity(0.1),
                                                                  borderRadius: BorderRadius.circular(6),
                                                                  border: Border.all(
                                                                    color: Colors.purple.withOpacity(0.3),
                                                                    width: 1,
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    const Icon(Icons.folder, size: 10, color: Colors.purple),
                                                                    const SizedBox(width: 3),
                                                                    Text(
                                                                      'F-${examen.fichaMedicaId}',
                                                                      style: const TextStyle(
                                                                        fontSize: 11,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.purple,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 6),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.calendar_today_outlined,
                                                              size: 14,
                                                              color: AppColors.gris,
                                                            ),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              _formatearFecha(examen.fecha),
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: AppColors.gris,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 16),
                                                            Icon(
                                                              Icons.location_on_outlined,
                                                              size: 14,
                                                              color: AppColors.gris,
                                                            ),
                                                            const SizedBox(width: 4),
                                                            Expanded(
                                                              child: Text(
                                                                examen.centroMedico ?? 'Sin centro',
                                                                style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: AppColors.gris,
                                                                ),
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  
                                                  const SizedBox(width: 16),
                                                  
                                                  // Badge de estado
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: estadoColor.withOpacity(0.15),
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Text(
                                                      examen.estado ?? 'Sin estado',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w600,
                                                        color: estadoColor,
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                  const SizedBox(width: 12),
                                                  
                                                  // Icono de acción
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: AppColors.gris.withOpacity(0.5),
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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