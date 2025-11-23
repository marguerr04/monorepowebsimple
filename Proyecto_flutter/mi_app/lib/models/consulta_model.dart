class Consulta {
  final int id;
  final int pacienteId;
  final String diagnostico;
  final String tratamiento;
  final DateTime fecha;
  final String? observaciones;
  final String? centroMedico;
  final DateTime? createdAt;

  Consulta({
    required this.id,
    required this.pacienteId,
    required this.diagnostico,
    required this.tratamiento,
    required this.fecha,
    this.observaciones,
    this.centroMedico,
    this.createdAt,
  });

  factory Consulta.fromJson(Map<String, dynamic> json) {
    return Consulta(
      id: json['id'] ?? 0,
      pacienteId: json['paciente_id'] ?? 0,
      diagnostico: json['diagnostico'] ?? '',
      tratamiento: json['tratamiento'] ?? '',
      fecha: DateTime.tryParse(json['fecha']?.toString() ?? '') ?? DateTime.now(),
      observaciones: json['observaciones'],
      centroMedico: json['centro_medico'],
      createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'paciente_id': pacienteId,
      'diagnostico': diagnostico,
      'tratamiento': tratamiento,
      'fecha': fecha.toIso8601String(),
      'observaciones': observaciones,
      'centro_medico': centroMedico,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Consulta{id: $id, pacienteId: $pacienteId, diagnostico: $diagnostico, fecha: $fecha}';
  }
}