// lib/widgets/fichas/ficha_detail.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/ficha_detalle.model.dart';
import '../../services/fichas_service.dart';

class FichaDetailDialog extends StatefulWidget {
  final int idFicha;

  const FichaDetailDialog({super.key, required this.idFicha});

  @override
  State<FichaDetailDialog> createState() => _FichaDetailDialogState();
}

class _FichaDetailDialogState extends State<FichaDetailDialog> {
  final FichasService _service = FichasService();
  FichaDetalle? _detalle;
  bool _isLoading = true;

  // ✅ CONTROLLERS para editar CONSULTAS
  final _diagnosticoCtrl = TextEditingController();
  final _pesoCtrl = TextEditingController();
  final _alturaCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadDetalle();
  }

  Future<void> _loadDetalle() async {
    try {
      final json = await _service.fetchFichaDetalle(widget.idFicha);
      setState(() {
        _detalle = FichaDetalle.fromJson(json);
        
        // ✅ INICIALIZAR CON DATOS DE LA CONSULTA MÁS RECIENTE
        if (_detalle!.consultas.isNotEmpty) {
          final consulta = _detalle!.consultas.first;
          _diagnosticoCtrl.text = consulta.diagnostico ?? ''; // ✅ AHORA SÍ EXISTE
          _pesoCtrl.text = consulta.pesoPaciente?.toString() ?? '';
          _alturaCtrl.text = consulta.alturaPaciente?.toString() ?? '';
        }
        
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar detalle: $e');
      setState(() => _isLoading = false);
    }
  }

  // ✅ MÉTODO CORREGIDO: Guardar cambios de CONSULTA
  Future<void> _guardarCambios() async {
    try {
      // Verificar que hay consultas
      if (_detalle == null || _detalle!.consultas.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay consultas para editar')),
        );
        return;
      }

      // Tomar la consulta más reciente
      final consulta = _detalle!.consultas.first;
      final idConsulta = consulta.id;

      print('✏️ Actualizando consulta $idConsulta...');
      print('📋 Datos a enviar:');
      print('  - Diagnóstico: ${_diagnosticoCtrl.text}');
      print('  - Peso: ${_pesoCtrl.text}');
      print('  - Altura: ${_alturaCtrl.text}');

      // ✅ AHORA SÍ FUNCIONA: Usa el modelo correcto
      final response = await http.patch(
        Uri.parse('http://localhost:3000/api/consultas/$idConsulta'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'diagnostico': _diagnosticoCtrl.text.isEmpty ? null : _diagnosticoCtrl.text,
          'peso_paciente': _pesoCtrl.text.isNotEmpty ? double.tryParse(_pesoCtrl.text) : null,
          'altura_paciente': _alturaCtrl.text.isNotEmpty ? double.tryParse(_alturaCtrl.text) : null,
        }),
      );

      print('📡 Respuesta del servidor: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Consulta actualizada correctamente ✅'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Recargar los datos para ver el cambio
        _loadDetalle();
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${response.statusCode}: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error completo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de conexión: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _diagnosticoCtrl.dispose();
    _pesoCtrl.dispose();
    _alturaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ficha Médica F-${widget.idFicha}'),
      content: _isLoading
          ? const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            )
          : _detalle == null
              ? const Text('Error al cargar detalle.')
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ SECCIÓN ESPECÍFICA PARA EDITAR CONSULTAS
                      if (_detalle!.consultas.isNotEmpty) 
                        _buildSeccionConsultaEditable(),
                      
                      const SizedBox(height: 16),
                      
                      // ✅ SECCIONES INFORMATIVAS
                      _buildSection('👤 Paciente', [
                        'Nombre: ${_detalle!.nombrePaciente}',
                        'RUT: ${_detalle!.rut}',
                        'Edad: ${_detalle!.edad} años',
                        'Teléfono: ${_detalle!.telefono}',
                      ]),
                      
                      _buildSection('🩺 Consultas recientes', _detalle!.consultas
                          .map((c) =>
                              '${c.fechaFormateada} - ${c.tipoConsulta} (${c.nombreMedico})')
                          .toList()),
                          
                      _buildSection('🧪 Exámenes', _detalle!.examenes
                          .map((e) =>
                              '${e.fechaFormateada} - ${e.tipoExamen} [${e.estado}]')
                          .toList()),
                          
                      _buildSection('🏥 Tratamientos', _detalle!.tratamientos
                          .map((t) =>
                              '${t.fechaFormateada} - ${t.tipoIntervencion} (${t.sucursal})')
                          .toList()),
                    ],
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
        // ✅ BOTÓN PARA GUARDAR CONSULTA
        ElevatedButton.icon(
          onPressed: _guardarCambios,
          icon: const Icon(Icons.save),
          label: const Text('Guardar Consulta'),
        ),
      ],
    );
  }

  // ✅ NUEVA SECCIÓN ESPECÍFICA PARA CONSULTAS
  Widget _buildSeccionConsultaEditable() {
    final consulta = _detalle!.consultas.first;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '✏️ Editar Consulta Más Reciente',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            
            const SizedBox(height: 12),
            
            // Información de la consulta (solo lectura)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📅 ${consulta.fechaFormateada}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text('🩺 ${consulta.tipoConsulta}'),
                  Text('👨‍⚕️ ${consulta.nombreMedico}'),
                  if (consulta.diagnostico != null && consulta.diagnostico!.isNotEmpty)
                    Text('📋 Diagnóstico actual: ${consulta.diagnostico}'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Campos editables
            TextField(
              controller: _diagnosticoCtrl,
              decoration: const InputDecoration(
                labelText: 'Diagnóstico *',
                hintText: 'Ej: Infección urinaria, Control post-tratamiento...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pesoCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Peso (kg)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _alturaCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Altura (cm)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            Text(
              '* Solo el diagnóstico es obligatorio',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ MÉTODO EXISTENTE (se mantiene igual)
  Widget _buildSection(String title, List<String> lines) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          ...lines.map((l) => Text(l)),
          const Divider(),
        ],
      ),
    );
  }
}