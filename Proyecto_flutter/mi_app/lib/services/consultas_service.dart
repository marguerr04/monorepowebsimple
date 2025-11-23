import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/consulta_model.dart';

class ConsultasService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  // Headers comunes para todas las requests
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Obtener todas las consultas recientes
  Future<List<Consulta>> getConsultas() async {
    try {
      print('🔄 Fetching consultas from: $baseUrl/consultas');
      
      final response = await http.get(
        Uri.parse('$baseUrl/consultas'),
        headers: _headers,
      );

      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Consultas obtenidas: ${jsonData.length} elementos');
        
        return jsonData.map((json) => Consulta.fromJson(json)).toList();
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        throw Exception('Failed to load consultas: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getConsultas: $e');
      throw Exception('Error loading consultas: $e');
    }
  }

  /// Obtener consultas de un paciente específico
  Future<List<Consulta>> getConsultasPaciente(int pacienteId) async {
    try {
      print('🔄 Fetching consultas for patient: $pacienteId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/pacientes/$pacienteId/consultas'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Consultas del paciente obtenidas: ${jsonData.length} elementos');
        
        return jsonData.map((json) => Consulta.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load patient consultas: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getConsultasPaciente: $e');
      throw Exception('Error loading patient consultas: $e');
    }
  }

  /// Crear una nueva consulta
  Future<Map<String, dynamic>> createConsulta({
    required int pacienteId,
    required String diagnostico,
    required String tratamiento,
    required DateTime fecha,
    String? observaciones,
    String? centroMedico,
  }) async {
    try {
      print('🔄 Creating nueva consulta for patient: $pacienteId');
      
      final requestBody = {
        'paciente_id': pacienteId,
        'diagnostico': diagnostico,
        'tratamiento': tratamiento,
        'fecha': fecha.toIso8601String(),
        if (observaciones != null) 'observaciones': observaciones,
        if (centroMedico != null) 'centro_medico': centroMedico,
      };

      print('📤 Request body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/consultas'),
        headers: _headers,
        body: json.encode(requestBody),
      );

      print('📡 Create response status: ${response.statusCode}');
      print('📡 Create response body: ${response.body}');

      if (response.statusCode == 201) {
        final result = json.decode(response.body);
        print('✅ Consulta creada exitosamente');
        return result;
      } else {
        print('❌ Error creating consulta: ${response.statusCode}');
        throw Exception('Failed to create consulta: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en createConsulta: $e');
      throw Exception('Error creating consulta: $e');
    }
  }

  /// Validar que un paciente existe
  Future<bool> validatePacienteExists(int pacienteId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pacientes/$pacienteId'),
        headers: _headers,
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error validating patient: $e');
      return false;
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
}