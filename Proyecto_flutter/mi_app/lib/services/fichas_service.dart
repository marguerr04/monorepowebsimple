// lib/services/fichas_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ficha_medica.model.dart';

class FichasService {
  final String baseUrl = "http://localhost:3000";

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

  // Método para obtener detalle completo de ficha
  Future<Map<String, dynamic>> fetchFichaDetalle(int idFicha) async {
    final uri = Uri.parse('$baseUrl/api/fichas/$idFicha/resumen');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error ${response.statusCode} al obtener detalle');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener detalle: $e');
    }
  }

  // ✅ NUEVO MÉTODO: Actualizar ficha completa
  Future<bool> updateFicha(int idFicha, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/api/fichas/$idFicha');

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('✅ Ficha actualizada correctamente');
        return true;
      } else {
        print('❌ Error al actualizar ficha: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error de conexión al actualizar ficha: $e');
      return false;
    }
  }

  // MÉTODOS PARA EL CRUD COMPLETO (se mantienen)
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

  Future<FichaMedica> actualizarNombreFicha(int id, String nuevoNombre) async {
    final uri = Uri.parse("$baseUrl/api/fichas/$id");
    
    print('✏️ [Service] Actualizando nombre de ficha $id: $nuevoNombre');
    
    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nombre': nuevoNombre}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return FichaMedica.fromJson(jsonResponse['ficha'] ?? jsonResponse);
    } else {
      throw Exception('Error ${response.statusCode}: ${response.body}');
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