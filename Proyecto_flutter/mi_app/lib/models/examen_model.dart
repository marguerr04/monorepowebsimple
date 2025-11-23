class Examen {
  final int id;
  final int pacienteId;
  final String tipoExamen;
  final String resultado;
  final DateTime fecha;
  final String? observaciones;
  final String? centroMedico;
  final String? estado;
  final DateTime? createdAt;

  Examen({
    required this.id,
    required this.pacienteId,
    required this.tipoExamen,
    required this.resultado,
    required this.fecha,
    this.observaciones,
    this.centroMedico,
    this.estado,
    this.createdAt,
  });

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'] ?? 0,
      pacienteId: json['paciente_id'] ?? 0,
      tipoExamen: json['tipo_examen'] ?? '',
      resultado: json['resultado'] ?? '',
      fecha: DateTime.tryParse(json['fecha']?.toString() ?? '') ?? DateTime.now(),
      observaciones: json['observaciones'],
      centroMedico: json['centro_medico'],
      estado: json['estado'],
      createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'tipo_examen': tipoExamen,
      'resultado': resultado,
      'fecha': fecha.toIso8601String(),
      'observaciones': observaciones,
      'centro_medico': centroMedico,
      'estado': estado,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
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