import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class SidebarButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSelected;

  const SidebarButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: Color(0xFF721679), // ← Color morado de fondo
          borderRadius: BorderRadius.circular(8), // ← Bordes redondeados
          border: Border.all(color: Colors.black, width: 4.0), // ← Borde negro
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white, // ← Texto blanco para mejor contraste con morado
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}