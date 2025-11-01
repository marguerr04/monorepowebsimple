class AnalitoPoint {
  final double valor;
  final DateTime fecha;
  final String analito; // AGREGAR ESTE CAMPO NUEVO

  AnalitoPoint({
    required this.valor,
    required this.fecha,
    required this.analito, // AGREGAR
  });

  factory AnalitoPoint.fromJson(Map<String, dynamic> json) {
    return AnalitoPoint(
      // CONVERTIR String a double
      valor: double.parse(json['valor'].toString()),
      fecha: DateTime.parse(json['fecha']),
      analito: json['analito'] ?? 'Desconocido', // AGREGAR
    );
  }
}