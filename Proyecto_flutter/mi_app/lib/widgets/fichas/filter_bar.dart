import 'package:flutter/material.dart';

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Usaremos Wrap para que los filtros se ajusten en pantallas pequeñas
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Wrap(
        spacing: 16.0, // Espacio horizontal entre filtros
        runSpacing: 16.0, // Espacio vertical si se envuelven
        crossAxisAlignment: WrapCrossAlignment.end, // Alinea botones al final
        children: [
          // Campo de Búsqueda (Placeholder)
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por ID Paciente, Nombre o Apellido...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          // Dropdowns (Placeholders) - Puedes reemplazarlos con DropdownButtonFormField
          _buildDropdown('Comuna', ['Todas', 'Quilicura', 'Santiago']),
          _buildDropdown('Patologías', ['Seleccionar...', 'Diabetes', 'Hipertensión']),
          _buildDropdown('Establecimiento', ['Todos', 'Clínica A', 'Hospital B']),
          // Rango de Edad (Placeholder)
          Row(children: [Text("Rango Edad:"), SizedBox(width:5), Text("Desde - Hasta")]), // Simplificado
          // Botones de Acción
          ElevatedButton(
            onPressed: () {},
            child: const Text('Aplicar Filtros'),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Limpiar'),
          ),
        ],
      ),
    );
  }

  // Helper para construir Dropdowns (simplificado)
  Widget _buildDropdown(String label, List<String> items) {
     return ConstrainedBox(
       constraints: const BoxConstraints(minWidth: 150),
       child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true,
              value: items.first, // Valor seleccionado por defecto
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (_) {}, // Acción al cambiar
            ),
          ),
        ),
     );
  }
}
