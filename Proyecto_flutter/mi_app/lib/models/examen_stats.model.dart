class ExamenStats {
  final String tipoExamen;
  final int aprobados;
  final int reprobados;
  final DateTime lastUpdated;

  ExamenStats({
    required this.tipoExamen,
    required this.aprobados,
    required this.reprobados,
    required this.lastUpdated,
  });

  factory ExamenStats.fromJson(Map<String, dynamic> json) {
    // DEBUG TEMPORAL PARA VER QUÉ LLEGA
    print("📋 JSON recibido en ExamenStats: $json");
    
    return ExamenStats(
      tipoExamen: json['tipo_examen']?.toString() ?? 'Desconocido',
      // CONVERSIÓN SUPER SEGURA
      aprobados: _safeParseInt(json['aprobados']),
      reprobados: _safeParseInt(json['reprobados']),
      lastUpdated: _safeParseDateTime(json['last_updated']),
    );
  }

  // MÉTODO AUXILIAR PARA CONVERSIÓN SEGURA DE INT
  static int _safeParseInt(dynamic value) {
    try {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    } catch (e) {
      print("⚠️ Error convirtiendo a int: $value");
      return 0;
    }
  }

  // MÉTODO AUXILIAR PARA CONVERSIÓN SEGURA DE DATETIME
  static DateTime _safeParseDateTime(dynamic value) {
    try {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      return DateTime.now();
    } catch (e) {
      print("⚠️ Error convirtiendo a DateTime: $value");
      return DateTime.now();
    }
  }
}