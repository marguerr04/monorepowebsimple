import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/paciente_model.dart';

class PacientesService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Obtener paciente por ID
  Future<Paciente?> getPacienteById(int id) async {
    try {
      print('🔄 Fetching paciente by ID: $id');
      
      final response = await http.get(
        Uri.parse('$baseUrl/pacientes/$id'),
        headers: _headers,
      );

      print('📡 Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ Paciente obtenido: ${jsonData['nombre']} ${jsonData['apellido']}');
        
        return Paciente.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        print('❌ Paciente no encontrado');
        return null;
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        throw Exception('Failed to load paciente: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getPacienteById: $e');
      throw Exception('Error loading paciente: $e');
    }
  }

  /// Obtener paciente por RUT
  Future<Paciente?> getPacienteByRut(String rut) async {
    try {
      print('🔄 Fetching paciente by RUT: $rut');
      
      final response = await http.get(
        Uri.parse('$baseUrl/pacientes/rut/$rut'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('✅ Paciente obtenido por RUT: ${jsonData['nombre']} ${jsonData['apellido']}');
        
        return Paciente.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        print('❌ Paciente con RUT $rut no encontrado');
        return null;
      } else {
        throw Exception('Failed to load paciente by RUT: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getPacienteByRut: $e');
      throw Exception('Error loading paciente by RUT: $e');
    }
  }

  /// Obtener todos los pacientes (para debug/admin)
  Future<List<Paciente>> getAllPacientes() async {
    try {
      print('🔄 Fetching todos los pacientes');
      
      final response = await http.get(
        Uri.parse('$baseUrl/debug/todos-pacientes'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Pacientes obtenidos: ${jsonData.length} elementos');
        
        return jsonData.map((json) => Paciente.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load all pacientes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getAllPacientes: $e');
      throw Exception('Error loading all pacientes: $e');
    }
  }

  /// Buscar pacientes por RUT (búsqueda parcial)
  Future<List<Paciente>> buscarPacientesPorRut(String rutParcial) async {
    try {
      print('🔄 Searching pacientes by partial RUT: $rutParcial');
      
      final response = await http.get(
        Uri.parse('$baseUrl/debug/buscar-rut/$rutParcial'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Pacientes encontrados: ${jsonData.length} elementos');
        
        return jsonData.map((json) => Paciente.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search pacientes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en buscarPacientesPorRut: $e');
      return []; // Retornar lista vacía en caso de error
    }
  }

  /// Login de paciente
  Future<Map<String, dynamic>?> loginPaciente(String rut, String nombre) async {
    try {
      print('🔄 Login paciente: RUT=$rut, Nombre=$nombre');
      
      final requestBody = {
        'rut': rut,
        'nombre': nombre,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/pacientes/login'),
        headers: _headers,
        body: json.encode(requestBody),
      );

      print('📡 Login response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print('✅ Login exitoso');
        return result;
      } else if (response.statusCode == 404) {
        print('❌ Credenciales no válidas');
        return null;
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en loginPaciente: $e');
      throw Exception('Error in login: $e');
    }
  }

  /// Validar que el RUT tenga formato correcto
  bool validarFormatoRut(String rut) {
    // Remover puntos y guión
    final rutLimpio = rut.replaceAll(RegExp(r'[.\-\s]'), '');
    
    // Debe tener al menos 8 caracteres (7 dígitos + dígito verificador)
    if (rutLimpio.length < 8) return false;
    
    // Los primeros caracteres deben ser números
    final cuerpo = rutLimpio.substring(0, rutLimpio.length - 1);
    final dv = rutLimpio.substring(rutLimpio.length - 1);
    
    // El cuerpo debe ser solo números
    if (!RegExp(r'^\d+$').hasMatch(cuerpo)) return false;
    
    // El dígito verificador puede ser número o K
    if (!RegExp(r'^[\dKk]$').hasMatch(dv)) return false;
    
    return true;
  }

  /// Formatear RUT para mostrar
  String formatearRut(String rut) {
    final rutLimpio = rut.replaceAll(RegExp(r'[.\-\s]'), '');
    if (rutLimpio.length < 8) return rut;
    
    final cuerpo = rutLimpio.substring(0, rutLimpio.length - 1);
    final dv = rutLimpio.substring(rutLimpio.length - 1);
    
    // Formatear con puntos: 12.345.678-K
    String cuerpoFormateado = '';
    for (int i = 0; i < cuerpo.length; i++) {
      if (i > 0 && (cuerpo.length - i) % 3 == 0) {
        cuerpoFormateado += '.';
      }
      cuerpoFormateado += cuerpo[i];
    }
    
    return '$cuerpoFormateado-$dv';
  }
}