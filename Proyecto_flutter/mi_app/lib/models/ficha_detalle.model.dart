// lib/models/ficha_detalle.model.dart
import 'package:intl/intl.dart';
import 'consulta.model.dart'; // ✅ IMPORTAR el modelo correcto

class FichaDetalle {
  final int idFicha;
  final String nombreFicha;
  final int idPaciente;
  final String nombrePaciente;
  final String rut;
  final String sexo;
  final String telefono;
  final DateTime fechaNac;
  final int edad;

  // ✅ NUEVOS CAMPOS EDITABLES
  String diagnosticoPrincipal;
  String estado;
  String especialidadACargo;
  String establecimiento;

  final List<Consulta> consultas; // ✅ Ahora usa el modelo CON diagnóstico
  final List<Examen> examenes;
  final List<Tratamiento> tratamientos;

  FichaDetalle({
    required this.idFicha,
    required this.nombreFicha,
    required this.idPaciente,
    required this.nombrePaciente,
    required this.rut,
    required this.sexo,
    required this.telefono,
    required this.fechaNac,
    required this.edad,
    
    required this.diagnosticoPrincipal,
    required this.estado,
    required this.especialidadACargo,
    required this.establecimiento,

    required this.consultas,
    required this.examenes,
    required this.tratamientos,
  });

  factory FichaDetalle.fromJson(Map<String, dynamic> json) {
    final ficha = json['ficha'] ?? {};

    return FichaDetalle(
      idFicha: ficha['idFicha'] ?? 0,
      nombreFicha: ficha['nombreFicha'] ?? '',
      idPaciente: ficha['idPaciente'] ?? 0,
      nombrePaciente: ficha['nombrePaciente'] ?? '',
      rut: ficha['rut'] ?? '',
      sexo: ficha['sexo'] ?? '',
      telefono: ficha['telefono'] ?? '',
      fechaNac: DateTime.parse(ficha['fechanac'] ?? DateTime.now().toString()),
      edad: int.tryParse(ficha['edad'].toString()) ?? 0,
      
      diagnosticoPrincipal: ficha['diagnosticoPrincipal'] ?? 'Sin diagnóstico',
      estado: ficha['estado'] ?? 'Activo',
      especialidadACargo: ficha['especialidadACargo'] ?? 'No asignada',
      establecimiento: ficha['establecimiento'] ?? 'Sin establecimiento',

      // ✅ USA Consulta.fromJson del modelo correcto
      consultas: (json['consultas'] as List<dynamic>?)
              ?.map((c) => Consulta.fromJson(c))
              .toList() ??
          [],
      examenes: (json['examenes'] as List<dynamic>?)
              ?.map((e) => Examen.fromJson(e))
              .toList() ??
          [],
      tratamientos: (json['tratamientos'] as List<dynamic>?)
              ?.map((t) => Tratamiento.fromJson(t))
              .toList() ??
          [],
    );
  }

  String get fechaNacFormateada => DateFormat('dd/MM/yyyy').format(fechaNac);
}

// ❌❌❌ ELIMINA COMPLETAMENTE la clase Consulta de este archivo ❌❌❌
// NO DEBE HABER otra clase Consulta aquí

class Examen {
  final int id;
  final DateTime fecha;
  final String estado;
  final String tipoExamen;

  Examen({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.tipoExamen,
  });

  factory Examen.fromJson(Map<String, dynamic> json) {
    return Examen(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estadoexamen'] ?? '',
      tipoExamen: json['tipo_examen'] ?? '',
    );
  }

  String get fechaFormateada => DateFormat('dd/MM/yyyy').format(fecha);
}

class Tratamiento {
  final int id;
  final DateTime fecha;
  final String descripcion;
  final String tipoIntervencion;
  final String sucursal;

  Tratamiento({
    required this.id,
    required this.fecha,
    required this.descripcion,
    required this.tipoIntervencion,
    required this.sucursal,
  });

  factory Tratamiento.fromJson(Map<String, dynamic> json) {
    return Tratamiento(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      descripcion: json['descripcion'] ?? '',
      tipoIntervencion: json['tipo_intervencion'] ?? '',
      sucursal: json['sucursal'] ?? '',
    );
  }

  String get fechaFormateada => DateFormat('dd/MM/yyyy').format(fecha);
}