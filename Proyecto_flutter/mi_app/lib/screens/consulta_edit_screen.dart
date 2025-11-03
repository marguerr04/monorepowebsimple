import 'package:flutter/material.dart';
import '../services/fichas_service.dart';
import '../models/consulta_detalle.model.dart';

class ConsultaEditScreen extends StatefulWidget {
  final int consultaId;

  const ConsultaEditScreen({super.key, required this.consultaId});

  @override
  State<ConsultaEditScreen> createState() => _ConsultaEditScreenState();
}

class _ConsultaEditScreenState extends State<ConsultaEditScreen> {
  final FichasService _service = FichasService();
  ConsultaDetalle? _consulta;
  bool _isLoading = true;
  
  // ✅ NUEVOS CONTROLLERS para los campos que espera el backend
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _diagnosticoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConsulta();
  }

  Future<void> _loadConsulta() async {
    try {
      final consulta = await _service.getConsultaDetalle(widget.consultaId);
      setState(() {
        _consulta = consulta;
        // ✅ INICIALIZAR TODOS LOS CAMPOS
        _pesoController.text = consulta.pesoPaciente?.toString() ?? '';
        _alturaController.text = consulta.alturaPaciente?.toString() ?? '';
        _diagnosticoController.text = consulta.diagnostico ?? '';
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar consulta: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _guardarCambios() async {
  try {
    final peso = double.tryParse(_pesoController.text);
    final altura = double.tryParse(_alturaController.text);
    
    if (peso == null || altura == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peso y altura deben ser números válidos')),
      );
      return;
    }

    // ✅ VALIDACIÓN ESPECÍFICA PARA TUS CAMPOS DE BD
    // pesoPaciente: numeric(5,2) → Máximo 999.99
    if (peso < 20 || peso > 999.99) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El peso debe estar entre 20 y 999.99 kg')),
      );
      return;
    }

    // alturaPaciente: numeric(3,2) → Máximo 9.99 ⚠️ PROBLEMA!
    // PERO asumimos que en realidad debería ser para METROS, no cm
    if (altura < 0.50 || altura > 2.50) { // 50 cm a 2.50 metros
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La altura debe estar entre 0.50 y 2.50 metros')),
      );
      return;
    }

    print('🔄 Guardando cambios:');
    print('  - Peso: $peso kg');
    print('  - Altura: $altura m');

    await _service.updateConsultaCompleto(
      widget.consultaId,
      peso,
      altura, // ✅ Ahora en METROS
      _diagnosticoController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Cambios guardados correctamente'),
        backgroundColor: Colors.green,
      ),
    );
    
    Navigator.pop(context, true);
  } catch (e) {
    print('💥 Error al guardar: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al guardar: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  void dispose() {
    _pesoController.dispose();
    _alturaController.dispose();
    _diagnosticoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Consulta ${widget.consultaId}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _guardarCambios,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _consulta == null
              ? const Center(child: Text('Error al cargar consulta'))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fecha: ${_consulta!.fechaFormateada}'),
                              Text('Médico: ${_consulta!.nombreMedico}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // ✅ NUEVOS CAMPOS: PESO Y ALTURA
                      // ✅ CAMBIA LOS LABELS PARA REFLEJAR METROS, NO CM
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _pesoController,
                              decoration: const InputDecoration(
                                labelText: 'Peso (kg)',
                                border: OutlineInputBorder(),
                                hintText: 'Ej: 70.5',
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _alturaController,
                              decoration: const InputDecoration(
                                labelText: 'Altura (metros)', // ✅ CAMBIADO
                                border: OutlineInputBorder(),
                                hintText: 'Ej: 1.75', // ✅ EJEMPLO EN METROS
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      TextField(
                        controller: _diagnosticoController,
                        decoration: const InputDecoration(
                          labelText: 'Observaciones / Notas',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _guardarCambios,
                        child: const Text('Guardar Cambios'),
                      ),
                    ],
                  ),
                ),
    );
  }
}