import 'dart:convert';
import 'package:http/http.dart' as http;

class EstadisticasService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> getEstadisticasExamenes() async {
    try {
      print('📊 Fetching estadísticas de exámenes...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/examenes/estadisticas'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Estadísticas obtenidas: ${jsonData.length} tipos');
        
        int totalAprobados = 0;
        int totalReprobados = 0;
        
        for (var stat in jsonData) {
          totalAprobados += (stat['aprobados'] ?? 0) as int;
          totalReprobados += (stat['reprobados'] ?? 0) as int;
        }
        
        return {
          'tiposExamenes': jsonData.length,
          'totalAprobados': totalAprobados,
          'totalReprobados': totalReprobados,
          'totalExamenes': totalAprobados + totalReprobados,
          'detalle': jsonData,
        };
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getEstadisticasExamenes: $e');
      return {
        'tiposExamenes': 0,
        'totalAprobados': 0,
        'totalReprobados': 0,
        'totalExamenes': 0,
        'detalle': [],
        'error': true,
      };
    }
  }

  Future<Map<String, dynamic>> getResumenFichas() async {
    try {
      print('📋 Fetching resumen de fichas...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/fichas-resumen'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('✅ Resumen de fichas obtenido');
        
        return {
          'totalFichas': jsonData['totalItems'] ?? 0,
          'paginaActual': jsonData['currentPage'] ?? 1,
          'totalPaginas': jsonData['totalPages'] ?? 1,
          'fichas': jsonData['fichas'] ?? [],
        };
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getResumenFichas: $e');
      return {
        'totalFichas': 0,
        'fichas': [],
        'error': true,
      };
    }
  }

  Future<Map<String, dynamic>> getDashboardCompleto() async {
    try {
      print('📊 Cargando dashboard completo...');
      
      final futures = await Future.wait([
        getEstadisticasExamenes(),
        getResumenFichas(),
      ]);
      
      return {
        'examenes': futures[0],
        'fichas': futures[1],
        'timestamp': DateTime.now().toIso8601String(),
        'success': true,
      };
    } catch (e) {
      print('❌ Error en getDashboardCompleto: $e');
      return {
        'examenes': {
          'tiposExamenes': 0,
          'totalAprobados': 0,
          'totalReprobados': 0,
          'totalExamenes': 0,
        },
        'fichas': {
          'totalFichas': 0,
          'fichas': [],
        },
        'timestamp': DateTime.now().toIso8601String(),
        'success': false,
        'error': e.toString(),
      };
    }
  }
}