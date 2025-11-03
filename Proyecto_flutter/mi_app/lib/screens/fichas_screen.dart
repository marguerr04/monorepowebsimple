import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../widgets/fichas/fichas_data_table.dart';
import '../widgets/fichas/paginations_controls.dart';
import '../utils/app_colors.dart';
import '../services/fichas_service.dart';
import '../models/ficha_medica.model.dart';
import './ficha_detalle_screen.dart';
import './consulta_edit_screen.dart';
import '../widgets/fichas/ficha_detail_dialog.dart';
import '../widgets/fichas/consulta_edit_dialog.dart';


class FichasScreen extends StatefulWidget {
  const FichasScreen({super.key});

  @override
  State<FichasScreen> createState() => _FichasScreenState();
}

class _FichasScreenState extends State<FichasScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  int _totalItems = 0;
  late int _totalPages;
  String? _selectedComuna;
  String? _selectedPatologia;
  String? _selectedEstablecimiento;
  final TextEditingController _edadDesdeController = TextEditingController();
  final TextEditingController _edadHastaController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final FichasService _fichasService = FichasService();
  List<FichaMedica> _fichas = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _totalPages = (_totalItems / _itemsPerPage).ceil();
    _loadFichas();
  }

  Future<void> _loadFichas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final fichas = await _fichasService.fetchFichasResumen();
      setState(() {
        _fichas = fichas;
        _totalItems = fichas.length;
        _totalPages = (_totalItems / _itemsPerPage).ceil();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar las fichas: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _edadDesdeController.dispose();
    _edadHastaController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onPageChanged(int newPage) {
    setState(() {
      _currentPage = newPage;
      print('Cambiando a página: $_currentPage');
    });
  }

  void _applyFilters() {
    setState(() {
      print('Filtros aplicados...');
      _currentPage = 1;
      _loadFichas();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedComuna = null;
      _selectedPatologia = null;
      _selectedEstablecimiento = null;
      _edadDesdeController.clear();
      _edadHastaController.clear();
      _currentPage = 1;
      print('Filtros limpiados');
      _loadFichas();
    });
  }

  List<FichaMedica> get _currentPageItems {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _fichas.sublist(
      startIndex.clamp(0, _fichas.length),
      endIndex.clamp(0, _fichas.length),
    );
  }

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
        _loadFichas();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gestión de Fichas Médicas',
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 26),
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () { print('Crear Nueva Ficha'); },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('Crear Nueva Ficha'),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: () { print('Generar Dataset'); },
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Generar Dataset'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.primaryColor,
                              side: BorderSide(color: theme.primaryColor),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Buscar por ID Paciente, Nombre o Apellido...',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onSubmitted: (_) => _applyFilters(),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 20.0,
                          runSpacing: 15.0,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            _buildDropdown<String>(
                              hint: 'Comuna',
                              value: _selectedComuna,
                              items: ['Santiago', 'Providencia', 'Las Condes', 'Ñuñoa'],
                              onChanged: (val) => setState(() => _selectedComuna = val),
                            ),
                            _buildDropdown<String>(
                              hint: 'Patologías',
                              value: _selectedPatologia,
                              items: ['Diabetes', 'Hipertensión', 'Ansiedad', 'Obesidad', 'Respiratoria'],
                              onChanged: (val) => setState(() => _selectedPatologia = val),
                            ),
                            _buildDropdown<String>(
                              hint: 'Establecimiento',
                              value: _selectedEstablecimiento,
                              items: ['Clínica A', 'Hospital B', 'Centro Salud C'],
                              onChanged: (val) => setState(() => _selectedEstablecimiento = val),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _edadDesdeController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(hintText: 'Desde', isDense: true),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text('-'),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _edadHastaController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(hintText: 'Hasta', isDense: true),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: _applyFilters,
                                  child: const Text('Aplicar Filtros'),
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: _clearFilters,
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.gris,
                                  ),
                                  child: const Text('Limpiar'),
                                ),
                              ],
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
                                    onPressed: _loadFichas,
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            )
                          : _fichas.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: AppColors.fondoClaro,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.inbox_outlined, color: AppColors.gris, size: 64),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'No hay fichas médicas disponibles',
                                        style: TextStyle(fontSize: 18, color: AppColors.gris),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        'Presiona "Crear Nueva Ficha" para agregar la primera',
                                        style: TextStyle(color: AppColors.gris),
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
                  if (!_isLoading && _fichas.isNotEmpty)
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

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.blanco,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.bordeClaro),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: AppColors.gris)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.gris),
          elevation: 2,
          style: const TextStyle(color: AppColors.textoOscuro, fontSize: 14),
          dropdownColor: AppColors.blanco,
          items: items.map<DropdownMenuItem<T>>((T itemValue) {
            return DropdownMenuItem<T>(
              value: itemValue,
              child: Text(itemValue.toString()),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}