// lib/models/consulta.model.dart
import 'package:intl/intl.dart';

class Consulta {
  final int id;
  final DateTime fecha;
  final String tipoConsulta;
  final String nombreMedico;
  final String? diagnostico;
  final double? pesoPaciente;
  final double? alturaPaciente;
  final int fichaMedicaId;

  Consulta({
    required this.id,
    required this.fecha,
    required this.tipoConsulta,
    required this.nombreMedico,
    this.diagnostico,
    this.pesoPaciente,
    this.alturaPaciente,
    required this.fichaMedicaId,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'] ?? 0,
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toString()),
      tipoConsulta: json['tipo_consulta'] ?? json['tipoConsulta'] ?? '',
      nombreMedico: json['nombre_medico'] ?? json['nombreMedico'] ?? '',
      diagnostico: json['diagnostico'],
      pesoPaciente: json['peso_paciente'] != null 
          ? double.tryParse(json['peso_paciente'].toString()) 
          : null,
      alturaPaciente: json['altura_paciente'] != null 
          ? double.tryParse(json['altura_paciente'].toString()) 
          : null,
      fichaMedicaId: json['ficha_medica_id'] ?? json['fichaMedicaId'] ?? 0,
    );
  }

  String get fechaFormateada {
    return DateFormat('dd/MM/yyyy HH:mm').format(fecha);
  }

  String get fechaCorta {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'tipo_consulta': tipoConsulta,
      'nombre_medico': nombreMedico,
      'diagnostico': diagnostico,
      'peso_paciente': pesoPaciente,
      'altura_paciente': alturaPaciente,
      'ficha_medica_id': fichaMedicaId,
    };
  }
}