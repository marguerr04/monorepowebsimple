import 'package:intl/intl.dart';

class ConsultaDetalle {
  final int id;
  final DateTime fecha;
  final String tipoConsulta;
  final String nombreMedico;
  final String? diagnostico;
  final double? pesoPaciente;  
  final double? alturaPaciente;

  ConsultaDetalle({
    required this.id,
    required this.fecha,
    required this.tipoConsulta,
    required this.nombreMedico,
    this.diagnostico,
    this.pesoPaciente,         
    this.alturaPaciente,
  });

  factory ConsultaDetalle.fromJson(Map<String, dynamic> json) {
    return ConsultaDetalle(
      id: json['id'] ?? 0,
      fecha: DateTime.parse(json['fecha'] ?? DateTime.now().toString()),
      tipoConsulta: json['tipoConsulta'] ?? '',
      nombreMedico: json['nombreMedico'] ?? '',
      diagnostico: json['diagnostico'],
      pesoPaciente: json['pesoPaciente'] != null 
          ? double.tryParse(json['pesoPaciente'].toString()) 
          : null, 
      alturaPaciente: json['alturaPaciente'] != null 
          ? double.tryParse(json['alturaPaciente'].toString()) 
          : null, 




      
    );
  }

  String get fechaFormateada => DateFormat('dd/MM/yyyy').format(fecha);
}