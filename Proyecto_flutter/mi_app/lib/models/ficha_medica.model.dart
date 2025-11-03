import 'package:intl/intl.dart';

class FichaMedica {
  final int idFicha;
  final String idPaciente;
  final String nombrePaciente;
  final int edad;
  final String diagnosticoPrincipal;
  final DateTime fechaActualizacion;
  final String especialidadACargo;
  final String establecimiento;
  final String estado;

  FichaMedica({
    required this.idFicha,
    required this.idPaciente,
    required this.nombrePaciente,
    required this.edad,
    required this.diagnosticoPrincipal,
    required this.fechaActualizacion,
    required this.especialidadACargo,
    required this.establecimiento,
    required this.estado,
  });

  factory FichaMedica.fromJson(Map<String, dynamic> json) {
    return FichaMedica(
      idFicha: json['idFicha'] ?? json['id'] ?? 0,
      idPaciente: json['idPaciente'] ?? '',
      nombrePaciente: json['nombrePaciente'] ?? 'Sin nombre',
      edad: json['edad'] is int
          ? json['edad']
          : int.tryParse(json['edad'].toString()) ?? 0,
      diagnosticoPrincipal: json['diagnosticoPrincipal'] ??
          json['diagnostico_principal'] ??
          'Sin diagnóstico',
      fechaActualizacion: DateTime.tryParse(
              json['fechaActualizacion'] ??
                  json['fecha'] ??
                  DateTime.now().toIso8601String()) ??
          DateTime.now(),
      especialidadACargo:
          json['especialidadACargo'] ?? json['especialidad'] ?? 'No asignado',
      establecimiento:
          json['establecimiento'] ?? json['dirSucursal'] ?? 'Sin establecimiento',
      estado: json['estado'] ?? 'Activo',
    );
  }

  String get fechaFormateada {
    return DateFormat('dd/MM/yyyy').format(fechaActualizacion);
  }
}


// MODELO DE RESUMEN - Mantenemos si lo necesitas
class FichaResumen {
  final String idPacienteAnonimizado;
  final String nombrePaciente;
  final int edad;
  final List<String> patologias;
  final DateTime ultimaActualizacion;
  final bool tienePdf;

  FichaResumen({
    required this.idPacienteAnonimizado,
    required this.nombrePaciente,
    required this.edad,
    required this.patologias,
    required this.ultimaActualizacion,
    this.tienePdf = false,
  });

  // Factory constructor desde JSON
  factory FichaResumen.fromJson(Map<String, dynamic> json) {
    return FichaResumen(
      idPacienteAnonimizado: json['id_paciente'] ?? 'N/A',
      nombrePaciente: json['nombre_paciente'] ?? 'Sin nombre',
      edad: json['edad'] ?? 0,
      patologias: (json['patologias'] as List<dynamic>?)?.cast<String>() ?? [],
      ultimaActualizacion: DateTime.parse(json['ultima_actualizacion'] ?? DateTime.now().toString()),
      tienePdf: json['tiene_pdf'] ?? false,
    );
  }

  String get fechaActualizacionFormateada {
    return DateFormat('dd/MM/yyyy').format(ultimaActualizacion);
  }
}