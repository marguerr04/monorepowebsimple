import 'package:flutter/material.dart';
import '../widgets/layout/admin_sidebar.dart';
import '../utils/app_colors.dart';

class PanelControlScreen extends StatefulWidget {
  const PanelControlScreen({super.key});

  @override
  State<PanelControlScreen> createState() => _PanelControlScreenState();
}

class _PanelControlScreenState extends State<PanelControlScreen> {
  int _selectedSidebarIndex = 1; // Índice 1 para Panel de Control

  void _onSidebarItemSelected(int index) {
    setState(() => _selectedSidebarIndex = index);
    
    switch (index) {
      case 0: // Dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
      case 1: // Panel de Control (estamos aquí)
        break;
      case 2: // Cerrar sesión
        Navigator.pushReplacementNamed(context, '/login');
        break;
    }
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
                // Header mejorado
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
                      // Icono principal del panel
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: AppColors.cyanOscuro.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.dashboard,
                          color: AppColors.cyanOscuro,
                          size: 32,
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Título y subtítulo
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panel de Control',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textoOscuro,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Gestionar Solicitudes y Fichas Médicas',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gris,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Iconos de acción en el header
                      Row(
                        children: [
                          // Icono de notificaciones
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Notificaciones próximamente'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.notifications,
                                color: Colors.orange,
                              ),
                              tooltip: 'Notificaciones',
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Icono de configuración
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Configuración próximamente'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.purple,
                              ),
                              tooltip: 'Configuración',
                            ),
                          ),
                          
                          const SizedBox(width: 8),
                          
                          // Icono de ayuda
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: IconButton(
                              onPressed: () {
                                _showHelpDialog();
                              },
                              icon: const Icon(
                                Icons.help_outline,
                                color: Colors.blue,
                              ),
                              tooltip: 'Ayuda',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Contenido principal responsivo - SOLUCIÓN AL OVERFLOW
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          
                          // Título centrado
                          const Text(
                            'Selecciona una opción',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textoOscuro,
                            ),
                          ),
                          
                          const SizedBox(height: 30),
                          
                          // Grid responsivo de 4 botones
                          LayoutBuilder(
                            builder: (context, constraints) {
                              double cardWidth = (constraints.maxWidth - 40) / 2;
                              double cardHeight = cardWidth * 0.75; // Aspect ratio 4:3
                              
                              return Wrap(
                                spacing: 20,
                                runSpacing: 20,
                                alignment: WrapAlignment.center,
                                children: [
                                  // Botón 1: Fichas Médicas
                                  SizedBox(
                                    width: cardWidth,
                                    height: cardHeight,
                                    child: _buildControlButton(
                                      title: 'Fichas\nMédicas',
                                      icon: Icons.folder_shared,
                                      color: const Color(0xFF4CAF50), // Verde
                                      onTap: () => Navigator.pushNamed(context, '/fichas'),
                                    ),
                                  ),
                                  
                                  // Botón 2: Consultas Médicas  
                                  SizedBox(
                                    width: cardWidth,
                                    height: cardHeight,
                                    child: _buildControlButton(
                                      title: 'Consultas\nMédicas',
                                      icon: Icons.medical_services,
                                      color: const Color(0xFF2196F3), // Azul
                                      onTap: () => Navigator.pushNamed(context, '/consultas'),
                                    ),
                                  ),
                                  
                                  // Botón 3: Exámenes Médicos
                                  SizedBox(
                                    width: cardWidth,
                                    height: cardHeight,
                                    child: _buildControlButton(
                                      title: 'Exámenes\nMédicos',
                                      icon: Icons.science,
                                      color: const Color(0xFFFF9800), // Naranja
                                      onTap: () {
                                        _showComingSoonMessage('Exámenes Médicos');
                                      },
                                    ),
                                  ),
                                  
                                  // Botón 4: Gestión de Pacientes
                                  SizedBox(
                                    width: cardWidth,
                                    height: cardHeight,
                                    child: _buildControlButton(
                                      title: 'Gestión\nPacientes',
                                      icon: Icons.people,
                                      color: const Color(0xFF9C27B0), // Morado
                                      onTap: () {
                                        _showComingSoonMessage('Gestión de Pacientes');
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          
                          const SizedBox(height: 40), // Padding inferior
                        ],
                      ),
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

  Widget _buildControlButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.8),
                color,
              ],
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Título
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoonMessage(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature estará disponible próximamente'),
        backgroundColor: AppColors.cyanOscuro,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Row(
            children: [
              Icon(Icons.help_outline, color: Colors.blue),
              SizedBox(width: 8),
              Text('Ayuda del Panel de Control'),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bienvenido al Panel de Control del Sistema Médico',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text('• Fichas Médicas: Gestiona registros médicos de pacientes'),
                SizedBox(height: 8),
                Text('• Consultas Médicas: Administra citas y consultas'),
                SizedBox(height: 8),
                Text('• Exámenes Médicos: Control de resultados de exámenes'),
                SizedBox(height: 8),
                Text('• Gestión de Pacientes: Control de datos de pacientes'),
                SizedBox(height: 12),
                Text(
                  'Usa los iconos en el header para:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('🔔 Ver notificaciones del sistema'),
                SizedBox(height: 4),
                Text('⚙️ Configurar preferencias'),
                SizedBox(height: 4),
                Text('❓ Obtener ayuda adicional'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Entendido'),
            ),
          ],
        );
      },
    );
  }
}