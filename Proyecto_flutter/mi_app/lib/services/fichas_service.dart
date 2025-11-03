// lib/services/fichas_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ficha_medica.model.dart';
import '../models/ficha_detallada.model.dart'; // ✅ NUEVO IMPORT
import '../models/consulta_detalle.model.dart'; // ✅ NUEVO IMPORT

class FichasService {
  final String baseUrl = "http://localhost:3000";

  // ✅ MÉTODO EXISTENTE
  Future<List<FichaMedica>> fetchFichasResumen() async {
    try {
      final uri = Uri.parse("$baseUrl/api/fichas-resumen");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((item) => FichaMedica.fromJson(item)).toList();
      } else {
        throw Exception('Error ${response.statusCode} al obtener fichas');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ✅ NUEVO MÉTODO 1: Obtener detalle de ficha (para el botón "ojo")
 // ✅ NUEVO MÉTODO 1: Obtener detalle de ficha (para el botón "ojo")
Future<FichaDetallada> getFichaDetallada(String fichaId) async {
  try {
    // ✅ CORRECCIÓN: Extrae solo el número del ID (remueve "F-")
    final idNumerico = fichaId.replaceAll('F-', '');
    
    final uri = Uri.parse("$baseUrl/api/ficha/$idNumerico/resumen-detallado");
    print('🔗 Llamando API: $uri');
    
    final response = await http.get(uri);

    print('📡 Respuesta API - Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print('✅ JSON recibido correctamente');
      return FichaDetallada.fromJson(jsonResponse);
    } else {
      print('❌ Error ${response.statusCode}: ${response.body}');
      throw Exception('Error ${response.statusCode} al obtener detalle de ficha');
    }
  } catch (e) {
    print('💥 Error de conexión: $e');
    throw Exception('Error de conexión: $e');
  }
}

  // ✅ NUEVO MÉTODO 2: Obtener detalle de consulta (para el botón "lápiz")
  Future<ConsultaDetalle> getConsultaDetalle(int consultaId) async {
    try {
      final uri = Uri.parse("$baseUrl/api/consulta/$consultaId");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return ConsultaDetalle.fromJson(jsonResponse);
      } else {
        throw Exception('Error ${response.statusCode} al obtener detalle de consulta');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ✅ NUEVO MÉTODO 3: Actualizar consulta (para guardar cambios)
  Future<void> updateConsulta(int consultaId, String diagnostico) async {
    try {
      final uri = Uri.parse("$baseUrl/api/consulta/$consultaId");
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'diagnostico': diagnostico,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Error ${response.statusCode} al actualizar consulta');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ✅ MÉTODOS PARA EL CRUD COMPLETO (opcionales)
  Future<FichaMedica> crearFicha(Map<String, dynamic> datos) async {
    final uri = Uri.parse("$baseUrl/api/fichas");
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    if (response.statusCode == 201) {
      return FichaMedica.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error ${response.statusCode} al crear ficha');
    }
  }

  Future<FichaMedica> actualizarFicha(int id, Map<String, dynamic> datos) async {
    final uri = Uri.parse("$baseUrl/api/fichas/$id");
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(datos),
    );

    if (response.statusCode == 200) {
      return FichaMedica.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error ${response.statusCode} al actualizar ficha');
    }
  }

  Future<void> eliminarFicha(int id) async {
    final uri = Uri.parse("$baseUrl/api/fichas/$id");
    final response = await http.delete(uri);

    if (response.statusCode != 200) {
      throw Exception('Error ${response.statusCode} al eliminar ficha');
    }
  }
}