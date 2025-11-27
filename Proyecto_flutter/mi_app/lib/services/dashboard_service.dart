import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Obtener estadísticas generales del dashboard
  Future<Map<String, dynamic>> getEstadisticasDashboard() async {
    try {
      print('📊 [Dashboard] Obteniendo estadísticas...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/estadisticas/dashboard'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ [Dashboard] Estadísticas obtenidas: $data');
        return data;
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [Dashboard] Error: $e');
      throw Exception('Error cargando estadísticas: $e');
    }
  }

  /// Obtener estadísticas de exámenes por tipo
  Future<List<Map<String, dynamic>>> getEstadisticasExamenes() async {
    try {
      print('📊 [Dashboard] Obteniendo estadísticas de exámenes...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/examenes/estadisticas'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('✅ [Dashboard] ${data.length} tipos de exámenes obtenidos');
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [Dashboard] Error: $e');
      throw Exception('Error cargando estadísticas de exámenes: $e');
    }
  }
}
