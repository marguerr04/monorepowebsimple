import 'dart:convert';
import 'package:http/http.dart' as http;

class EstadisticasService {
  static const String baseUrl = 'http://localhost:3000/api';
  
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Obtener estadísticas de exámenes
  Future<Map<String, dynamic>> getEstadisticasExamenes() async {
    try {
      print('📊 Fetching estadísticas de exámenes...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/examenes/estadisticas'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('✅ Estadísticas obtenidas: ${jsonData.length} tipos de exámenes');
        
        // Calcular totales
        int totalAprobados = 0;
        int totalReprobados = 0;
        int tiposExamenes = jsonData.length;
        
        for (var stat in jsonData) {
          totalAprobados += (stat['aprobados'] ?? 0) as int;
          totalReprobados += (stat['reprobados'] ?? 0) as int;
        }
        
        return {
          'tiposExamenes': tiposExamenes,
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
      throw Exception('Error loading estadísticas: $e');
    }
  }

  /// Obtener resumen de fichas médicas
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
      throw Exception('Error loading fichas: $e');
    }
  }

  /// Obtener conteo total de pacientes
  Future<Map<String, dynamic>> getEstadisticasPacientes() async {
    try {
      print('👥 Fetching estadísticas de pacientes...');
      
      final response = await http.get(
        Uri.parse('$baseUrl/debug/todos-pacientes'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('✅ Estadísticas de pacientes obtenidas');
        
        return {
          'totalPacientes': jsonData['total'] ?? 0,
          'pacientes': jsonData['pacientes'] ?? [],
        };
      } else {
        throw Exception('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getEstadisticasPacientes: $e');
      return {
        'totalPacientes': 0,
        'pacientes': [],
      };
    }
  }

  /// Obtener todas las estadísticas del dashboard
  Future<Map<String, dynamic>> getDashboardCompleto() async {
    try {
      print('📊 Cargando dashboard completo...');
      
      final futures = await Future.wait([
        getEstadisticasExamenes(),
        getResumenFichas(),
        getEstadisticasPacientes(),
      ]);
      
      return {
        'examenes': futures[0],
        'fichas': futures[1], 
        'pacientes': futures[2],
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('❌ Error en getDashboardCompleto: $e');
      // Retornar datos por defecto en caso de error
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
        'pacientes': {
          'totalPacientes': 0,
          'pacientes': [],
        },
        'timestamp': DateTime.now().toIso8601String(),
        'error': true,
      };
    }
  }
}