// lib/models/ficha_medica.model.dart
import 'package:intl/intl.dart';

class FichaMedica {
  final String idFicha;
  final int? idConsulta;
  final String nombrePaciente;
  final String idPaciente;
  final int edad;
  final String diagnosticoPrincipal;
  final DateTime? fechaActualizacion;
  final String especialidadACargo;
  final String establecimiento;
  final String estado;
  final double? pesoPaciente;  // NUEVO CAMPO
  final double? alturaPaciente; // UEVO CAMPO

  FichaMedica({
    required this.idFicha,
    this.idConsulta,
    required this.nombrePaciente,
    required this.idPaciente,
    required this.edad,
    required this.diagnosticoPrincipal,
    this.fechaActualizacion,
    required this.especialidadACargo,
    required this.establecimiento,
    required this.estado,
    this.pesoPaciente,  // NUEVO CAMPO
    this.alturaPaciente, // NUEVO CAMPO
  });

  String get fechaFormateada {
    if (fechaActualizacion == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(fechaActualizacion!);
  }

  // ✅ Método útil para mostrar altura formateada
  String get alturaFormateada {
    if (alturaPaciente == null) return '--';
    return '${alturaPaciente!.toStringAsFixed(2)} m';
  }

  factory FichaMedica.fromJson(Map<String, dynamic> json) {
    return FichaMedica(
      idFicha: 'F-${json['idFicha']?.toString() ?? '???'}',
      idConsulta: json['idConsulta'],
      nombrePaciente: json['nombrePaciente'] ?? 'Sin Nombre',
      idPaciente: json['idPaciente']?.toString() ?? 'Sin RUT',
      edad: json['edad'] ?? 0,
      diagnosticoPrincipal: json['diagnosticoPrincipal'] ?? 'Sin Diagnóstico',
      fechaActualizacion: json['fechaActualizacion'] != null
          ? DateTime.parse(json['fechaActualizacion'])
          : null,
      especialidadACargo: json['especialidadACargo'] ?? 'No Asignado',
      establecimiento: json['establecimiento'] ?? 'Sin Establecimiento',
      estado: json['estado'] ?? 'Inactivo',
      pesoPaciente: json['pesoPaciente'] != null 
          ? double.tryParse(json['pesoPaciente'].toString()) 
          : null, // ✅ NUEVO CAMPO
      alturaPaciente: json['alturaPaciente'] != null 
          ? double.tryParse(json['alturaPaciente'].toString()) 
          : null, // ✅ NUEVO CAMPO
    );
  }
}