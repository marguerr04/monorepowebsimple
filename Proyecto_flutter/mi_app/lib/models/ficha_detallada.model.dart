import 'package:intl/intl.dart';

class FichaDetallada {
  final PacienteDetalle paciente;
  final List<ConsultaReciente> consultasRecientes;
  final List<ExamenReciente> examenesRecientes;

  FichaDetallada({
    required this.paciente,
    required this.consultasRecientes,
    required this.examenesRecientes,
  });

  factory FichaDetallada.fromJson(Map<String, dynamic> json) {
    return FichaDetallada(
      paciente: PacienteDetalle.fromJson(json['paciente'] ?? {}),
      consultasRecientes: (json['consultasRecientes'] as List<dynamic>?)
          ?.map((c) => ConsultaReciente.fromJson(c))
          .toList() ?? [],
      examenesRecientes: (json['examenesRecientes'] as List<dynamic>?)
          ?.map((e) => ExamenReciente.fromJson(e))
          .toList() ?? [],
    );
  }
}

class PacienteDetalle {
  final String nombre;
  final String rut;
  final int edad;
  final String sexo;
  final String telefono;

  PacienteDetalle({
    required this.nombre,
    required this.rut,
    required this.edad,
    required this.sexo,
    required this.telefono,
  });

  factory PacienteDetalle.fromJson(Map<String, dynamic> json) {
    return PacienteDetalle(
      nombre: json['nombre'] ?? '',
      rut: json['rut'] ?? '',
      edad: json['edad'] ?? 0,
      sexo: json['sexo'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }
}

class ConsultaReciente {
  final DateTime fecha;
  final String medico;
  final List<String> diagnosticos;

  ConsultaReciente({
    required this.fecha,
    required this.medico,
    required this.diagnosticos,
  });

  factory ConsultaReciente.fromJson(Map<String, dynamic> json) {
    return ConsultaReciente(
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toString()),
      medico: json['medico'] ?? '',
      diagnosticos: (json['diagnosticos'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class ExamenReciente {
  final DateTime fecha;
  final String tipoExamen;
  final String sucursal;

  ExamenReciente({
    required this.fecha,
    required this.tipoExamen,
    required this.sucursal,
  });

  factory ExamenReciente.fromJson(Map<String, dynamic> json) {
    return ExamenReciente(
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toString()),
      tipoExamen: json['tipoExamen'] ?? '',
      sucursal: json['sucursal'] ?? '',
    );
  }
}