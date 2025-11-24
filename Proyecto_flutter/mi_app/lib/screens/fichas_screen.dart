import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../widgets/fichas/fichas_data_table.dart';
import '../widgets/fichas/paginations_controls.dart';
import '../utils/app_colors.dart';
import '../services/fichas_service.dart';
import '../models/ficha_medica.model.dart';
import './ficha_detalle_screen.dart';
import './consulta_edit_screen.dart';

class FichasScreen extends StatefulWidget {
  const FichasScreen({super.key});

  @override
  State<FichasScreen> createState() => _FichasScreenState();
}

class _FichasScreenState extends State<FichasScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalItems = 0;
  int _totalPages = 1;
  
  // ✅ SOLO buscador por ID Ficha (nota: busca en la página actual cuando se usa paginación remota)
  final TextEditingController _searchController = TextEditingController();

  final FichasService _fichasService = FichasService();
  // Contenedor para los items de la página actual
  List<FichaMedica> _pageItems = [];
  // Items filtrados en la página actual (para el buscador local)
  List<FichaMedica> _pageItemsFiltrados = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _totalPages = (_totalItems / _itemsPerPage).ceil();
    _loadConsultas(page: _currentPage);
  }

  // Cargar consultas pidiendo la página al backend
  Future<void> _loadConsultas({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Usamos el método que devuelve items + metadata
      final result = await _fichasService.fetchFichasResumen(page: page, limit: _itemsPerPage);

      final items = (result['items'] as List<FichaMedica>);
      final total = result['total'] as int;
      final totalPages = result['totalPages'] as int;
      final currentPage = result['currentPage'] as int;

      setState(() {
        _pageItems = items;
        _pageItemsFiltrados = items;
        _totalItems = total;
        _totalPages = totalPages > 0 ? totalPages : 1;
        _currentPage = currentPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar las consultas: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newPage) {
    // Al cambiar la página, solicitamos la nueva página al servidor
    _loadConsultas(page: newPage);
  }

  // ✅ NUEVO: Filtrar por ID Ficha
  void _filtrarPorIDFicha() {
    final idBuscado = _searchController.text.trim().toLowerCase();
    
    setState(() {
      if (idBuscado.isEmpty) {
        _pageItemsFiltrados = _pageItems;
      } else {
        final idLimpio = idBuscado.replaceAll('f-', '');
        _pageItemsFiltrados = _pageItems.where((ficha) {
          final idFicha = ficha.idFicha.toLowerCase().replaceAll('f-', '');
          return idFicha.contains(idLimpio);
        }).toList();
      }
      // Nota: al filtrar localmente sobre la página actual, no actualizamos _totalItems ni _totalPages
      // Para un buscador global se debe implementar búsqueda en el servidor.
    });
    
    print('🔍 Buscando ID Ficha: "$idBuscado" - Encontrados: ${_pageItemsFiltrados.length} registros (en página actual)');
  }

  // ✅ NUEVO: Limpiar búsqueda
  void _limpiarBusqueda() {
    setState(() {
      _searchController.clear();
      _pageItemsFiltrados = _pageItems;
    });
    print('🧹 Búsqueda limpiada - Mostrando todos los registros');
  }

  // Ahora la página ya viene del servidor, así que devolvemos los items filtrados de la página actual
  List<FichaMedica> get _currentPageItems => _pageItemsFiltrados;

  void _onViewFicha(String fichaId) {
    print('Ver Ficha ID: $fichaId');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FichaDetalleScreen(fichaId: fichaId),
      ),
    );
  }

  void _onEditConsulta(int consultaId) {
    print('Editar Consulta ID: $consultaId');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsultaEditScreen(consultaId: consultaId),
      ),
    ).then((dataEditada) {
      if (dataEditada == true) {
        print("Recargando fichas después de editar...");
        _loadConsultas();
      }
    });
  }

  void _onDeleteFicha(String fichaId) {
    print('Borrar Ficha ID: $fichaId');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: AdminSidebar(
              selectedIndex: 1,
              onItemSelected: (index) {
                if (index == 0) {
                  Navigator.pushReplacementNamed(context, '/dashboard');
                } else if (index == 2) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header mejorado
                  Container(
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
                            Icons.medical_services_rounded,
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
                                'Gestión de Consultas Médicas',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textoOscuro,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total: $_totalItems consultas médicas registradas',
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
                          onPressed: () { print('Crear Nueva Consulta'); },
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('Crear Nueva Consulta'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cyanOscuro,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () { print('Generar Reporte'); },
                          icon: const Icon(Icons.download_rounded, size: 18),
                          label: const Text('Generar Reporte'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.cyanOscuro,
                            side: const BorderSide(color: AppColors.cyanOscuro, width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Buscador mejorado
                  Container(
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
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Buscar por ID Ficha...',
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
                                onSubmitted: (_) => _filtrarPorIDFicha(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _filtrarPorIDFicha,
                              icon: const Icon(Icons.search, size: 18),
                              label: const Text('Buscar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.cyanOscuro,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: _limpiarBusqueda,
                              icon: const Icon(Icons.clear, size: 18),
                              label: const Text('Limpiar'),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.gris,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: AppColors.gris,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Ejemplo: 1, F-1, 95, F-95',
                              style: TextStyle(
                                color: AppColors.gris,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red[200]!),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                                  const SizedBox(height: 16),
                                  Text(
                                    _errorMessage,
                                    style: TextStyle(color: Colors.red[700]),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _loadConsultas,
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                          : _pageItemsFiltrados.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: AppColors.fondoClaro,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        _searchController.text.isEmpty 
                                            ? Icons.inbox_outlined 
                                            : Icons.search_off, 
                                        color: AppColors.gris, 
                                        size: 64
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        _searchController.text.isEmpty 
                                            ? 'No hay consultas médicas disponibles'
                                            : 'No se encontraron consultas para el ID Ficha buscado',
                                        style: const TextStyle(fontSize: 18, color: AppColors.gris),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _searchController.text.isEmpty
                                            ? 'Presiona "Crear Nueva Consulta" para agregar la primera'
                                            : 'Verifica el ID Ficha e intenta nuevamente',
                                        style: const TextStyle(color: AppColors.gris),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: FichasDataTable(
                                    fichas: _currentPageItems,
                                    onView: _onViewFicha,
                                    onEdit: _onEditConsulta,
                                    onDelete: _onDeleteFicha,
                                  ),
                                ),
                  const SizedBox(height: 20),
                  if (!_isLoading && _pageItemsFiltrados.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: PaginationControls(
                        currentPage: _currentPage,
                        totalPages: _totalPages,
                        totalItems: _totalItems,
                        itemsPerPage: _itemsPerPage,
                        onPageChanged: _onPageChanged,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}