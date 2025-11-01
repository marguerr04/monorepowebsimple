import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'sidebar_button.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex; // Nueva propiedad
  final Function(int) onItemSelected; // Nueva propiedad

  const AdminSidebar({
    super.key,
    required this.selectedIndex, // Hacerlo requerido
    required this.onItemSelected, // Hacerlo requerido
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF30CBA1), Color(0xFF9CE3EB)], // Tu gradiente directo
        ),
        // Codigo para poner linea borde negro sidebar
        border: Border(right: BorderSide(color: Colors.black, width: 5.0)), // ← Línea negra derecha
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sección de Rol
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: AppColors.grisOscuro,
                child: Icon(Icons.person, color: AppColors.blanco),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: AppColors.grisOscuro,
                child: Icon(Icons.settings, color: AppColors.blanco),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Rol: admin',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          
          // Botones de Navegación
          SidebarButton(
            text: 'Dashboard general',
            onTap: () {
              onItemSelected(0); // Índice 0 para Dashboard
            },
            isSelected: selectedIndex == 0, // Resaltar si está seleccionado
          ),
          SidebarButton(
            text: 'Fichas médicas',
            onTap: () {
              onItemSelected(1); // Índice 1 para Fichas
            },
            isSelected: selectedIndex == 1, // Resaltar si está seleccionado
          ),
          SidebarButton(
            text: 'Cerrar sesión',
            onTap: () {
              onItemSelected(2); // Índice 2 para Cerrar sesión
            },
            isSelected: selectedIndex == 2, // Resaltar si está seleccionado
          ),
        ],
      ),
    );
  }
}