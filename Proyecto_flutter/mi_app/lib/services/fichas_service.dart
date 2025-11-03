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

  // ✅ MÉTODOS PARA EL CRUD COMPLETO
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