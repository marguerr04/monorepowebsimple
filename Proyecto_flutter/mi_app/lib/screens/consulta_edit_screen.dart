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
      await _service.updateConsulta(
        widget.consultaId,
        _diagnosticoController.text,
      );
      
      // Retornar true indicando que se guardó correctamente
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }

  @override
  void dispose() {
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
                              Text('Tipo: ${_consulta!.tipoConsulta}'),
                              Text('Médico: ${_consulta!.nombreMedico}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _diagnosticoController,
                        decoration: const InputDecoration(
                          labelText: 'Diagnóstico',
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