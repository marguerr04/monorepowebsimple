import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'sidebar_button.dart';

class AdminSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        // === CAMBIO AQUÍ ===
        // Gradiente basado en el color verde de la imagen (#30c7a9)
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF30C7A9), // Color principal (de la imagen)
            Color(0xFF28A68B)  // Un tono un poco más oscuro
          ],
        ),
        // ==================
        border: Border(right: BorderSide(color: Colors.black, width: 3.0)),
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
            isSelected: selectedIndex == 0,
          ),
          SidebarButton(
            text: 'Fichas médicas',
            onTap: () {
              onItemSelected(1); // Índice 1 para Fichas
            },
            isSelected: selectedIndex == 1,
          ),
          SidebarButton(
            text: 'Cerrar sesión',
            onTap: () {
              onItemSelected(2); // Índice 2 para Cerrar sesión
            },
            isSelected: selectedIndex == 2,
          ),
        ],
      ),
    );
  }
}