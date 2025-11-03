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
  });

  String get fechaFormateada {
    if (fechaActualizacion == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(fechaActualizacion!);
  }

  factory FichaMedica.fromJson(Map<String, dynamic> json) {
    return FichaMedica(
      // ---  CORRECCIÓN ---
      // El JSON envía 'idFicha' como int (ej: 1).
      // Lo convertimos a String y le añadimos el prefijo 'F-'.
      idFicha: 'F-${json['idFicha']?.toString() ?? '???'}',
      
      idConsulta: json['idConsulta'], // Este ya es int?, está OK.
      
      nombrePaciente: json['nombrePaciente'] ?? 'Sin Nombre',
      
      // --- ✅ CORRECCIÓN ---
      // El JSON envía 'idPaciente' (RUT) como int (ej: 181234567).
      // Lo convertimos a String.
      idPaciente: json['idPaciente']?.toString() ?? 'Sin RUT',
      
      edad: json['edad'] ?? 0,
      
      diagnosticoPrincipal: json['diagnosticoPrincipal'] ?? 'Sin Diagnóstico',
      
      fechaActualizacion: json['fechaActualizacion'] != null
          ? DateTime.parse(json['fechaActualizacion'])
          : null,
          
      especialidadACargo: json['especialidadACargo'] ?? 'No Asignado',
      establecimiento: json['establecimiento'] ?? 'Sin Establecimiento',
      estado: json['estado'] ?? 'Inactivo',
    );
  }
}

