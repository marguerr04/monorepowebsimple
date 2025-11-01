// lib/widgets/fichas/paginations_controls.dart (o pagination_controls.dart)
import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  // --- AÑADIR ESTOS PARÁMETROS AL CONSTRUCTOR ---
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final Function(int) onPageChanged; // Callback cuando cambia la página
  // ---------------------------------------------

  const PaginationControls({
    super.key,
    // --- HACER QUE SE REQUIERAN ESTOS PARÁMETROS ---
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
    required this.onPageChanged,
    // ---------------------------------------------
  });

  @override
  Widget build(BuildContext context) {
    // Calcular el rango de items que se están mostrando
    final int startItem = (currentPage - 1) * itemsPerPage + 1;
    // Asegurarse de que el endItem no exceda el totalItems
    final int endItem = (currentPage * itemsPerPage > totalItems)
                        ? totalItems
                        : currentPage * itemsPerPage;

    // Calcular las páginas a mostrar alrededor de la página actual
    List<Widget> pageNumberButtons = [];
    int startPage = (currentPage - 2).clamp(1, totalPages);
    int endPage = (currentPage + 2).clamp(1, totalPages);

    if (startPage > 1) {
      pageNumberButtons.add(TextButton(onPressed: () => onPageChanged(1), child: const Text('1')));
      if (startPage > 2) pageNumberButtons.add(const Text("...", style: TextStyle(color: Colors.grey)));
    }

    for (int i = startPage; i <= endPage; i++) {
      pageNumberButtons.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: i == currentPage ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextButton(
            onPressed: i == currentPage ? null : () => onPageChanged(i),
            child: Text(
              i.toString(),
              style: TextStyle(
                color: i == currentPage ? Colors.white : Colors.grey[700],
                fontWeight: i == currentPage ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) pageNumberButtons.add(const Text("...", style: TextStyle(color: Colors.grey)));
      pageNumberButtons.add(TextButton(onPressed: () => onPageChanged(totalPages), child: Text(totalPages.toString())));
    }


    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto "Mostrando X-Y de Z resultados"
          Text(
            "Mostrando $startItem-$endItem de $totalItems resultados",
            style: TextStyle(color: Colors.grey.shade700),
          ),

          // Botones de paginación
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: currentPage > 1 ? () => onPageChanged(1) : null,
                tooltip: 'Primera Página',
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
                tooltip: 'Página Anterior',
              ),
              const SizedBox(width: 8),

              // Números de página dinámicos
              ...pageNumberButtons, // Usamos el spread operator para añadir los widgets de la lista

              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
                tooltip: 'Página Siguiente',
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: currentPage < totalPages ? () => onPageChanged(totalPages) : null,
                tooltip: 'Última Página',
              ),
            ],
          ),
        ],
      ),
    );
  }
}