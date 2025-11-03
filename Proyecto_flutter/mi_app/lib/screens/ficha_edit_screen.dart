import 'package:flutter/material.dart';
import '../models/ficha_medica.model.dart';
import '../services/fichas_service.dart';

class FichaEditScreen extends StatefulWidget {
  final FichaMedica ficha;

  const FichaEditScreen({super.key, required this.ficha});

  @override
  State<FichaEditScreen> createState() => _FichaEditScreenState();
}

class _FichaEditScreenState extends State<FichaEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _diagnosticoController;
  late TextEditingController _estadoController;
  late TextEditingController _especialidadController;
  late TextEditingController _establecimientoController;

  final FichasService _service = FichasService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _diagnosticoController =
        TextEditingController(text: widget.ficha.diagnosticoPrincipal);
    _estadoController = TextEditingController(text: widget.ficha.estado);
    _especialidadController = TextEditingController(text: widget.ficha.especialidadACargo ?? '');
    _establecimientoController =
        TextEditingController(text: widget.ficha.establecimiento);
  }

  @override
  void dispose() {
    _diagnosticoController.dispose();
    _estadoController.dispose();
    _especialidadController.dispose();
    _establecimientoController.dispose();
    super.dispose();
  }

  Future<void> _guardarCambios() async {
  if (!_formKey.currentState!.validate()) return;
  setState(() => _isSaving = true);

  try {
    
    await _service.actualizarNombreFicha(
      widget.ficha.idFicha, 
      _diagnosticoController.text
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Ficha actualizada correctamente ✅'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context, true);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al actualizar ficha: $e'),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => _isSaving = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Editar Ficha F-${widget.ficha.idFicha}'),
  backgroundColor: Theme.of(context).primaryColor,
  foregroundColor: Theme.of(context).colorScheme.onPrimary,
),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _diagnosticoController,
                decoration: const InputDecoration(
                  labelText: 'Diagnóstico Principal',
                  hintText: 'Ej: Infección Urinaria',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty)
                        ? 'Este campo no puede estar vacío'
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estadoController,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _especialidadController,
                decoration: const InputDecoration(
                  labelText: 'Especialidad a Cargo',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _establecimientoController,
                decoration: const InputDecoration(
                  labelText: 'Establecimiento',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),
              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Cambios'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      onPressed: _guardarCambios,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
