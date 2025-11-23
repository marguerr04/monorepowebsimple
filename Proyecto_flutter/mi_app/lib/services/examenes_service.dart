import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/examen_model.dart';

class ExamenesService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Obtener todos los exámenes recientes
  Future<List<Examen>> getExamenes() async {
    try {
      print('🔄 Fetching examenes from: $baseUrl/examenes');
      
      final response = await http.get(
        Uri.parse('$baseUrl/examenes'),
        headers: _headers,
      );

      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Exámenes obtenidos: ${jsonData.length} elementos');
        
        return jsonData.map((json) => Examen.fromJson(json)).toList();
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        throw Exception('Failed to load examenes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getExamenes: $e');
      throw Exception('Error loading examenes: $e');
    }
  }

  /// Obtener exámenes de un paciente específico
  Future<List<Examen>> getExamenesPaciente(int pacienteId) async {
    try {
      print('🔄 Fetching examenes for patient: $pacienteId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/pacientes/$pacienteId/examenes'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Exámenes del paciente obtenidos: ${jsonData.length} elementos');
        
        return jsonData.map((json) => Examen.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load patient examenes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getExamenesPaciente: $e');
      throw Exception('Error loading patient examenes: $e');
    }
  }

  /// Crear un nuevo examen
  Future<Map<String, dynamic>> createExamen({
    required int pacienteId,
    required String tipoExamen,
    required String resultado,
    required DateTime fecha,
    String? observaciones,
    String? centroMedico,
    String? estado,
  }) async {
    try {
      print('🔄 Creating nuevo examen for patient: $pacienteId');
      
      final requestBody = {
        'paciente_id': pacienteId,
        'tipo_examen': tipoExamen,
        'resultado': resultado,
        'fecha': fecha.toIso8601String(),
        if (observaciones != null) 'observaciones': observaciones,
        if (centroMedico != null) 'centro_medico': centroMedico,
        if (estado != null) 'estado': estado,
      };

      print('📤 Request body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/examenes'),
        headers: _headers,
        body: json.encode(requestBody),
      );

      print('📡 Create response status: ${response.statusCode}');
      print('📡 Create response body: ${response.body}');

      if (response.statusCode == 201) {
        final result = json.decode(response.body);
        print('✅ Examen creado exitosamente');
        return result;
      } else {
        print('❌ Error creating examen: ${response.statusCode}');
        throw Exception('Failed to create examen: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en createExamen: $e');
      throw Exception('Error creating examen: $e');
    }
  }

  /// Obtener tipos de examen disponibles
  Future<List<String>> getTiposExamen() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tipos-examen'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => item['tipo'].toString()).toList();
      } else {
        throw Exception('Failed to load tipos examen');
      }
    } catch (e) {
      print('❌ Error getting tipos examen: $e');
      return ['Hemograma', 'Glucosa', 'Colesterol']; // Fallback
    }
  }

  /// Obtener centros médicos disponibles
  Future<List<String>> getCentrosMedicos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/centros-medicos'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => item['nombre'].toString()).toList();
      } else {
        throw Exception('Failed to load centros medicos');
      }
    } catch (e) {
      print('❌ Error getting centros medicos: $e');
      return ['Centro Médico Principal']; // Fallback
    }
  }

  /// Obtener estadísticas de exámenes (para gráficos)
  Future<Map<String, dynamic>> getEstadisticasExamenes() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/examenes/estadisticas'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load estadisticas');
      }
    } catch (e) {
      print('❌ Error getting estadisticas: $e');
      return {};
    }
  }
}