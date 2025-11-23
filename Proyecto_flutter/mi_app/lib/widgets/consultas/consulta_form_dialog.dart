import 'package:flutter/material.dart';
import '../../services/consultas_service.dart';
import '../../utils/app_colors.dart';

class ConsultaFormDialog extends StatefulWidget {
  const ConsultaFormDialog({super.key});

  @override
  State<ConsultaFormDialog> createState() => _ConsultaFormDialogState();
}

class _ConsultaFormDialogState extends State<ConsultaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteIdController = TextEditingController();
  final _diagnosticoController = TextEditingController();
  final _tratamientoController = TextEditingController();
  final _observacionesController = TextEditingController();
  
  final ConsultasService _consultasService = ConsultasService();
  
  DateTime _selectedDate = DateTime.now();
  String? _selectedCentroMedico;
  List<String> _centrosMedicos = ['Centro Médico Principal'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCentrosMedicos();
  }

  Future<void> _loadCentrosMedicos() async {
    try {
      final centros = await _consultasService.getCentrosMedicos();
      setState(() {
        _centrosMedicos = centros;
        if (centros.isNotEmpty) {
          _selectedCentroMedico = centros.first;
        }
      });
    } catch (e) {
      print('Error loading centros medicos: $e');
    }
  }

  @override
  void dispose() {
    _pacienteIdController.dispose();
    _diagnosticoController.dispose();
    _tratamientoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            Row(
              children: [
                const Icon(
                  Icons.medical_services,
                  color: AppColors.cyanOscuro,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nueva Consulta Médica',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoOscuro,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Formulario
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Paciente ID
                    TextFormField(
                      controller: _pacienteIdController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'ID del Paciente',
                        hintText: 'Ingrese el ID del paciente',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El ID del paciente es requerido';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Debe ser un número válido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Fecha
                    InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de la consulta',
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Centro Médico
                    DropdownButtonFormField<String>(
                      value: _selectedCentroMedico,
                      decoration: const InputDecoration(
                        labelText: 'Centro Médico',
                        prefixIcon: Icon(Icons.local_hospital),
                      ),
                      items: _centrosMedicos.map((centro) {
                        return DropdownMenuItem(
                          value: centro,
                          child: Text(centro),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCentroMedico = value;
                        });
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Diagnóstico
                    TextFormField(
                      controller: _diagnosticoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Diagnóstico',
                        hintText: 'Ingrese el diagnóstico de la consulta',
                        prefixIcon: Icon(Icons.assignment),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El diagnóstico es requerido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Tratamiento
                    TextFormField(
                      controller: _tratamientoController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Tratamiento',
                        hintText: 'Ingrese el tratamiento recomendado',
                        prefixIcon: Icon(Icons.healing),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El tratamiento es requerido';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Observaciones
                    TextFormField(
                      controller: _observacionesController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Observaciones (opcional)',
                        hintText: 'Observaciones adicionales...',
                        prefixIcon: Icon(Icons.note),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveConsulta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.cyanOscuro,
                    foregroundColor: AppColors.blanco,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.blanco),
                          ),
                        )
                      : const Text('Guardar Consulta'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveConsulta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final pacienteId = int.parse(_pacienteIdController.text);
      
      // Validar que el paciente existe
      final pacienteExists = await _consultasService.validatePacienteExists(pacienteId);
      if (!pacienteExists) {
        _showErrorMessage('El paciente con ID $pacienteId no existe');
        return;
      }
      
      await _consultasService.createConsulta(
        pacienteId: pacienteId,
        diagnostico: _diagnosticoController.text,
        tratamiento: _tratamientoController.text,
        fecha: _selectedDate,
        observaciones: _observacionesController.text.isNotEmpty 
            ? _observacionesController.text 
            : null,
        centroMedico: _selectedCentroMedico,
      );
      
      if (mounted) {
        Navigator.of(context).pop(true); // Retorna true para indicar éxito
      }
    } catch (e) {
      _showErrorMessage('Error al crear la consulta: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}