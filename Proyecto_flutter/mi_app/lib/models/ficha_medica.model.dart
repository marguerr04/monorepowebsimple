import 'package:intl/intl.dart'; // Asegúrate de tener intl en pubspec.yaml

// Mantenemos tu modelo original si lo necesitas para otras partes
class FichaMedica {
  final int idFicha;
  final String diagnosticoPrincipal;
  final DateTime fecha; // Usamos DateTime para facilitar el formateo
  final String especialidad;
  final String estado;

  FichaMedica({
    required this.idFicha,
    required this.diagnosticoPrincipal,
    required this.fecha,
    required this.especialidad,
    required this.estado,
  });

  // Helper para formatear la fecha
  String get fechaFormateada {
    return DateFormat('dd/MM/yyyy').format(fecha);
  }
}

// NUEVO MODELO PARA LA TABLA DE RESUMEN (basado en la imagen nueva)
class FichaResumen {
  final String idPacienteAnonimizado;
  final String nombrePaciente;
  final int edad;
  final List<String> patologias; // Lista de strings para los tags
  final DateTime ultimaActualizacion;
  final bool tienePdf; // Para saber si mostrar el icono de PDF

  FichaResumen({
    required this.idPacienteAnonimizado,
    required this.nombrePaciente,
    required this.edad,
    required this.patologias,
    required this.ultimaActualizacion,
    this.tienePdf = false,
  });

   String get fechaActualizacionFormateada {
    return DateFormat('dd/MM/yyyy').format(ultimaActualizacion);
  }
}

