import 'package:flutter/material.dart';

class AppColors {
  // Colores existentes
  static const Color grisOscuro = Color(0xFF424242);
  static const Color blanco = Color(0xFFFFFFFF);
  
  // Nuevos colores para el gradient del sidebar
  static const Color verdeGradient = Color(0xFF30CBA1);  // #30cba1
  static const Color azulGradient = Color(0xFF9CE3EB);   // #9ce3eb
  
  // Gradiente para el sidebar
  static LinearGradient sidebarGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [verdeGradient, azulGradient],
    stops: [0.0, 1.0],
    transform: GradientRotation(135 * 3.14159 / 180), // 135 grados en radianes
  );
  
  // Colores para texto sobre el gradiente
  static const Color textoSobreGradient = Color(0xFF2A2A2A);
  static const Color iconoSobreGradient = Color(0xFF2A2A2A);
}