class Paciente {
  final int id;
  final String rut;
  final String nombre;
  final String apellido;
  final DateTime fechaNacimiento;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? tipoSangre;
  final bool? activo;
  final DateTime? createdAt;

  Paciente({
    required this.id,
    required this.rut,
    required this.nombre,
    required this.apellido,
    required this.fechaNacimiento,
    this.telefono,
    this.email,
    this.direccion,
    this.tipoSangre,
    this.activo,
    this.createdAt,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    // Separar nombre completo en nombre y apellido si no viene separado
    String nombreCompleto = json['nombre'] ?? '';
    List<String> partesNombre = nombreCompleto.trim().split(' ');
    String nombre = partesNombre.isNotEmpty ? partesNombre[0] : '';
    String apellido = partesNombre.length > 1 ? partesNombre.sublist(1).join(' ') : '';
    
    return Paciente(
      id: json['id'] ?? 0,
      rut: json['rut'] ?? '',
      nombre: nombre,
      apellido: apellido,
      fechaNacimiento: DateTime.tryParse(json['fechanac']?.toString() ?? json['fecha_nacimiento']?.toString() ?? '') ?? DateTime.now(),
      telefono: json['telefono'],
      email: json['correo'] ?? json['email'],
      direccion: json['direccion'],
      tipoSangre: json['tipo_sangre'],
      activo: json['activo'] ?? true, // Por defecto activo si no se especifica
      createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) 
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rut': rut,
      'nombre': nombre,
      'apellido': apellido,
      'fecha_nacimiento': fechaNacimiento.toIso8601String(),
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'tipo_sangre': tipoSangre,
      'activo': activo,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Paciente{id: $id, rut: $rut, nombre: $nombre, apellido: $apellido}';
  }

  /// Getter para obtener nombre completo
  String get nombreCompleto => '$nombre $apellido';

  /// Getter para calcular la edad
  int get edad {
    final now = DateTime.now();
    final difference = now.difference(fechaNacimiento);
    return (difference.inDays / 365).floor();
  }

  /// Getter para formato de fecha de nacimiento
  String get fechaNacimientoFormatted {
    return '${fechaNacimiento.day.toString().padLeft(2, '0')}/${fechaNacimiento.month.toString().padLeft(2, '0')}/${fechaNacimiento.year}';
  }
}