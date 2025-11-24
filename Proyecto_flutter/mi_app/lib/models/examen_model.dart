class Examen {
  final int id;
  final int pacienteId;
  final int? fichaMedicaId;
  final String tipoExamen;
  final String resultado;
  final DateTime fecha;
  final String? observaciones;
  final String? centroMedico;
  final String? estado;
  final DateTime? createdAt;
  
  // Información del paciente (opcional, viene del JOIN)
  final String? pacienteNombre;
  final String? pacienteRut;

  Examen({
    required this.id,
    required this.pacienteId,
    this.fichaMedicaId,
    required this.tipoExamen,
    required this.resultado,
    required this.fecha,
    this.observaciones,
    this.centroMedico,
    this.estado,
    this.createdAt,
    this.pacienteNombre,
    this.pacienteRut,
  });

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'] ?? 0,
      pacienteId: json['paciente_id'] ?? 0,
      fichaMedicaId: json['ficha_medica_id'],
      tipoExamen: json['tipo_examen'] ?? json['tipo_examen_nombre'] ?? '',
      resultado: json['resultado'] ?? (json['comentariosexamen'] ?? ''),
      fecha: DateTime.tryParse(json['fecha']?.toString() ?? '') ?? DateTime.now(),
      observaciones: json['observaciones'],
      centroMedico: json['centro_medico'] ?? json['centro_medico_nombre'] ?? json['nombrecentro'],
      estado: json['estado'] ?? json['estadoexamen'],
      createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) 
        : null,
      pacienteNombre: json['paciente_nombre'],
      pacienteRut: json['paciente_rut'],
    );
  }
  
  /// Nombre completo del paciente para mostrar
  String get pacienteDisplay => pacienteNombre ?? 'Paciente #$pacienteId';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      if (fichaMedicaId != null) 'ficha_medica_id': fichaMedicaId,
      'tipo_examen': tipoExamen,
      'resultado': resultado,
      'fecha': fecha.toIso8601String(),
      'observaciones': observaciones,
      'centro_medico': centroMedico,
      'estado': estado,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (pacienteNombre != null) 'paciente_nombre': pacienteNombre,
      if (pacienteRut != null) 'paciente_rut': pacienteRut,
    };
  }

  @override
  String toString() {
    return 'Examen{id: $id, pacienteId: $pacienteId, tipoExamen: $tipoExamen, resultado: $resultado, fecha: $fecha}';
  }

  /// Getter para obtener estado con valor por defecto
  String get estadoDisplay => estado ?? 'Pendiente';

  /// Getter para determinar si el resultado es normal/anormal
  bool get esResultadoNormal {
    final resultadoLower = resultado.toLowerCase();
    return resultadoLower.contains('normal') || 
           resultadoLower.contains('negativo') ||
           resultadoLower.contains('dentro del rango');
  }
}