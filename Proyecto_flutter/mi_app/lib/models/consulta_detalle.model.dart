import 'package:intl/intl.dart';

class ConsultaDetalle {
  final int id;
  final DateTime fecha;
  final String tipoConsulta;
  final String nombreMedico;
  final String? diagnostico;

  ConsultaDetalle({
    required this.id,
    required this.fecha,
    required this.tipoConsulta,
    required this.nombreMedico,
    this.diagnostico,
  });

  factory ConsultaDetalle.fromJson(Map<String, dynamic> json) {
    return ConsultaDetalle(
      id: json['id'] ?? 0,
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toString()),
      tipoConsulta: json['tipoConsulta'] ?? '',
      nombreMedico: json['nombreMedico'] ?? '',
      diagnostico: json['diagnostico'],
    );
  }

  String get fechaFormateada => DateFormat('dd/MM/yyyy').format(fecha);
}