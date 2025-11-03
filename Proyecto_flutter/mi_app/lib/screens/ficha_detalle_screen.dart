import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ficha_detallada.model.dart';
import '../services/fichas_service.dart';

class FichaDetalleScreen extends StatefulWidget {
  final String fichaId;
  const FichaDetalleScreen({super.key, required this.fichaId});

  @override
  State<FichaDetalleScreen> createState() => _FichaDetalleScreenState();
}

class _FichaDetalleScreenState extends State<FichaDetalleScreen> {
  final FichasService _fichasService = FichasService();
  Future<FichaDetallada>? _fichaDetalladaFuture;

  @override
  void initState() {
    super.initState();
    // Llamamos al servicio al iniciar la pantalla
    _fichaDetalladaFuture = _fichasService.getFichaDetallada(widget.fichaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen Ficha: ${widget.fichaId}'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<FichaDetallada>(
        future: _fichaDetalladaFuture,
        builder: (context, snapshot) {
          // --- ESTADO: CARGANDO ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // --- ESTADO: ERROR ---
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Error al cargar los datos: ${snapshot.error}'),
              ),
            );
          }
          // --- ESTADO: ÉXITO ---
          if (snapshot.hasData) {
            final ficha = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(24.0),
              children: [
                _buildPacienteCard(ficha.paciente),
                const SizedBox(height: 24),
                _buildConsultasCard(ficha.consultasRecientes),
                const SizedBox(height: 24),
                _buildExamenesCard(ficha.examenesRecientes),
              ],
            );
          }
          // Estado por defecto (no debería llegar aquí)
          return const Center(child: Text('No hay datos.'));
        },
      ),
    );
  }

  Widget _buildPacienteCard(PacienteDetalle paciente) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Datos del Paciente', style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 20),
            _buildInfoRow('Nombre:', paciente.nombre),
            _buildInfoRow('RUT:', paciente.rut),
            _buildInfoRow('Edad:', '${paciente.edad} años'),
            _buildInfoRow('Sexo:', paciente.sexo),
            _buildInfoRow('Teléfono:', paciente.telefono),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultasCard(List<ConsultaReciente> consultas) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Consultas Recientes', style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 20),
            if (consultas.isEmpty) const Text('No hay consultas recientes.'),
            ...consultas.map((c) => ListTile(
                  leading: const Icon(Icons.medical_services_outlined),
                  title: Text('Dr(a). ${c.medico} - ${DateFormat('dd/MM/yyyy').format(c.fecha)}'),
                  subtitle: Text('Diagnósticos: ${c.diagnosticos.join(', ')}'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildExamenesCard(List<ExamenReciente> examenes) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exámenes Recientes', style: Theme.of(context).textTheme.titleLarge),
            const Divider(height: 20),
            if (examenes.isEmpty) const Text('No hay exámenes recientes.'),
            ...examenes.map((e) => ListTile(
                  leading: const Icon(Icons.science_outlined),
                  title: Text('${e.tipoExamen} - ${DateFormat('dd/MM/yyyy').format(e.fecha)}'),
                  subtitle: Text('Sucursal: ${e.sucursal}'),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
