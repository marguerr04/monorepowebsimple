// lib/services/fichas_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ficha_medica.model.dart';
import '../models/ficha_detallada.model.dart';
import '../models/consulta_detalle.model.dart';

class FichasService {
  final String baseUrl = "http://localhost:3000";
  final Duration timeout = const Duration(seconds: 30);
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // TODO: Agregar token de autenticación cuando esté disponible
    // 'Authorization': 'Bearer $token',
  };

  // ✅ MÉTODO EXISTENTE
  Future<Map<String, dynamic>> fetchFichasResumen({int page = 1, int limit = 10}) async {
    try {
      final uri = Uri.parse("$baseUrl/api/fichas-resumen").replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      
      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(timeout);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // Caso 1: El backend devuelve un objeto con metadata { items, total, totalPages }
        if (decoded is Map<String, dynamic>) {
          final List<dynamic> items = decoded['items'] ?? [];
          final int total = decoded['total'] ?? (items.length);
          final int totalPages = decoded['totalPages'] ?? (total == 0 ? 1 : (total / limit).ceil());

          return {
            'items': items.map((item) => FichaMedica.fromJson(item)).toList(),
            'total': total,
            'totalPages': totalPages,
            'currentPage': decoded['currentPage'] ?? page,
          };
        }

        // Caso 2: El backend devuelve un array plano (List) -> adaptamos a la forma esperada
        if (decoded is List) {
          final List<dynamic> items = decoded;
          final int total = items.length;
          final int totalPages = total == 0 ? 1 : (total / limit).ceil();

          return {
            'items': items.map((item) => FichaMedica.fromJson(item)).toList(),
            'total': total,
            'totalPages': totalPages,
            'currentPage': page,
          };
        }

        // Si la respuesta no es Map ni List, devolver vacío
        return {
          'items': <FichaMedica>[],
          'total': 0,
          'totalPages': 1,
          'currentPage': page,
        };
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado');
      } else if (response.statusCode == 403) {
        throw Exception('Acceso denegado');
      } else {
        throw Exception('Error ${response.statusCode} al obtener fichas');
      }
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ✅ NUEVO MÉTODO: Para consultas (usa el mismo endpoint)
  Future<List<FichaMedica>> fetchConsultasResumen({int page = 1, int limit = 10}) async {
  try {
    final uri = Uri.parse("$baseUrl/api/fichas-resumen?page=$page&limit=$limit");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => FichaMedica.fromJson(item)).toList();
    } else {
      throw Exception('Error ${response.statusCode} al obtener consultas');
    }
  } catch (e) {
    throw Exception('Error de conexión: $e');
  }
}

  Future<FichaDetallada> getFichaDetallada(String fichaId) async {
    try {
      final idNumerico = fichaId.replaceAll('F-', '');
      final uri = Uri.parse("$baseUrl/api/ficha/$idNumerico/resumen-detallado");
      
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return FichaDetallada.fromJson(jsonResponse);
      } else {
        throw Exception('Error ${response.statusCode} al obtener detalle de ficha');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

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

  // ✅ MÉTODO CORREGIDO: updateConsultaCompleto
  Future<void> updateConsultaCompleto(
    int consultaId, 
    double pesoPaciente, 
    double alturaPaciente, 
    String diagnosticoTexto
  ) async {
    try {
      final uri = Uri.parse("$baseUrl/api/consulta/$consultaId");
      
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'pesoPaciente': pesoPaciente,
          'alturaPaciente': alturaPaciente,
          'diagnosticos': [diagnosticoTexto],
          'diagnosticoTexto': diagnosticoTexto,
        }),
      );

      if (response.statusCode == 404) {
        throw Exception('Consulta no encontrada');
      } else if (response.statusCode != 200) {
        throw Exception('Error ${response.statusCode} al actualizar consulta: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  } // ✅ CIERRE CORRECTO DEL MÉTODO

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
} // ✅ CIERRE FINAL DE LA CLASE