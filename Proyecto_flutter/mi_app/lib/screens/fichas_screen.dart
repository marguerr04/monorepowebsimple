import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../widgets/fichas/fichas_data_table.dart';
// Corregido el nombre del archivo de paginación
import '../widgets/fichas/paginations_controls.dart';
import '../utils/app_colors.dart'; // Importa tus colores si necesitas alguno específico

class FichasScreen extends StatefulWidget {
  const FichasScreen({super.key});

  @override
  State<FichasScreen> createState() => _FichasScreenState();
}

class _FichasScreenState extends State<FichasScreen> {
  // --- Estados (sin cambios) ---
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  final int _totalItems = 7495;
  late int _totalPages;
  String? _selectedComuna;
  String? _selectedPatologia;
  String? _selectedEstablecimiento;
  final TextEditingController _edadDesdeController = TextEditingController();
  final TextEditingController _edadHastaController = TextEditingController();
  final TextEditingController _searchController = TextEditingController(); // Controller para búsqueda

  @override
  void initState() {
    super.initState();
    _totalPages = (_totalItems / _itemsPerPage).ceil();
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
      // Lógica futura para recargar datos
    });
  }

  void _applyFilters() {
    setState(() {
      print('Filtros aplicados: ...'); // Lógica existente
      _currentPage = 1;
      // Lógica futura para recargar datos
    });
  }

  void _clearFilters() {
    setState(() {
       _searchController.clear(); // Limpia también el campo de búsqueda
      _selectedComuna = null;
      _selectedPatologia = null;
      _selectedEstablecimiento = null;
      _edadDesdeController.clear();
      _edadHastaController.clear();
      _currentPage = 1;
      print('Filtros limpiados');
      // Lógica futura para recargar datos
    });
  }

  @override
  Widget build(BuildContext context) {
    // Accedemos al tema para usar colores definidos globalmente
    final theme = Theme.of(context);

    return Scaffold(
      // backgroundColor ahora viene del tema definido en main.dart (AppColors.fondoClaro)
      body: Row(
        children: [
          // Sidebar (ya debería usar colores del tema/AppColors si lo actualizaste)
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

          // Área de Contenido Principal
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0), // Aumentamos padding general
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. Encabezado y Botones de Acción ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Gestión de Fichas Médicas',
                         style: theme.textTheme.titleLarge?.copyWith(fontSize: 26), // Usar estilo de título del tema
                      ),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () { print('Crear Nueva Ficha'); },
                            icon: const Icon(Icons.add, size: 18), // Icono más pequeño
                            label: const Text('Crear Nueva Ficha'),
                            // El estilo ya viene del elevatedButtonTheme en main.dart
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed: () { print('Generar Dataset'); },
                            icon: const Icon(Icons.download, size: 18),
                            label: const Text('Generar Dataset'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.primaryColor, // Color primario del tema
                              side: BorderSide(color: theme.primaryColor), // Borde color primario
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                               shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Mismo redondeo que ElevatedButton
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30), // Más espacio

                  // --- 2. Panel de Búsqueda y Filtros ---
                  Container(
                    padding: const EdgeInsets.all(20.0), // Más padding interno
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface, // Usa el color de superficie del tema (blanco por defecto)
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05), // Sombra más suave
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Campo de Búsqueda
                        TextField(
                           controller: _searchController,
                          decoration: const InputDecoration( // Estilo viene del inputDecorationTheme
                            hintText: 'Buscar por ID Paciente, Nombre o Apellido...',
                            prefixIcon: Icon(Icons.search),
                           // fillColor ajustado en el tema
                           // border ajustado en el tema
                          ),
                           onSubmitted: (_) => _applyFilters(), // Aplicar filtros al presionar Enter
                        ),
                        const SizedBox(height: 20),

                        // Fila de Filtros Avanzados
                        Wrap(
                          spacing: 20.0,
                          runSpacing: 15.0,
                          crossAxisAlignment: WrapCrossAlignment.end, // Alinea items al final
                          children: [
                            // Dropdown Comuna (Ejemplo con estilo mejorado)
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
                            // Rango de Edad
                            Row(
                               mainAxisSize: MainAxisSize.min, // Para que no ocupe todo el ancho
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
                                  child: Text('-'), // Separador
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
                            // Botones de filtro
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: _applyFilters,
                                  child: const Text('Aplicar Filtros'),
                                  // Estilo viene del tema
                                ),
                                const SizedBox(width: 10),
                                TextButton(
                                  onPressed: _clearFilters,
                                   style: TextButton.styleFrom(
                                     foregroundColor: AppColors.gris, // Usar gris de AppColors
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

                  // --- 3. Tabla de Datos ---
                  // Envuelve la tabla en un Container para darle fondo y borde si es necesario
                  Container(
                     decoration: BoxDecoration(
                       color: theme.colorScheme.surface, // Fondo blanco
                       borderRadius: BorderRadius.circular(12),
                        boxShadow: [ // Sombra opcional
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                     ),
                     child: const FichasDataTable(), // La tabla ya tiene sus datos dummy
                  ),
                  const SizedBox(height: 20),

                  // --- 4. Controles de Paginación ---
                  Align(
                    alignment: Alignment.centerRight, // Alinea a la derecha
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

 // Helper para construir Dropdowns con estilo consistente
 Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 48, // Altura estándar para inputs
      decoration: BoxDecoration(
        color: AppColors.blanco, // Fondo blanco
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.bordeClaro), // Borde claro
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: AppColors.gris)),
          isExpanded: true, // Para que ocupe el ancho disponible en Wrap
          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.gris),
          elevation: 2,
          style: const TextStyle(color: AppColors.textoOscuro, fontSize: 14), // Estilo del texto
          dropdownColor: AppColors.blanco,
          items: items.map<DropdownMenuItem<T>>((T itemValue) {
            return DropdownMenuItem<T>(
              value: itemValue,
              child: Text(itemValue.toString()), // Asume que T se puede convertir a String
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

