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
      throw Exception('Error loading pacientes stats: $e');
    }
  }

  /// Obtener estadísticas de consultas por paciente
  Future<Map<String, dynamic>> getEstadisticasConsultas() async {
    try {
      print('🩺 Fetching estadísticas de consultas...');
      
      // Primero obtenemos algunos pacientes para contar sus consultas
      final pacientesResponse = await http.get(
        Uri.parse('$baseUrl/debug/todos-pacientes'),
        headers: _headers,
      );

      if (pacientesResponse.statusCode == 200) {
        final Map<String, dynamic> pacientesData = json.decode(pacientesResponse.body);
        final List<dynamic> pacientes = pacientesData['pacientes'] ?? [];
        
        int totalConsultas = 0;
        List<Map<String, dynamic>> consultasPorPaciente = [];
        
        // Obtener consultas de los primeros 5 pacientes para estadísticas
        for (int i = 0; i < (pacientes.length < 5 ? pacientes.length : 5); i++) {
          final paciente = pacientes[i];
          final pacienteId = paciente['id'];
          
          try {
            final consultasResponse = await http.get(
              Uri.parse('$baseUrl/pacientes/$pacienteId/consultas'),
              headers: _headers,
            );
            
            if (consultasResponse.statusCode == 200) {
              final List<dynamic> consultas = json.decode(consultasResponse.body);
              totalConsultas += consultas.length;
              
              consultasPorPaciente.add({
                'paciente': paciente['nombre'],
                'consultas': consultas.length,
              });
            }
          } catch (e) {
            print('⚠️ Error obteniendo consultas para paciente $pacienteId: $e');
          }
        }
        
        return {
          'totalConsultas': totalConsultas,
          'consultasPorPaciente': consultasPorPaciente,
          'pacientesAnalizados': consultasPorPaciente.length,
        };
      } else {
        throw Exception('Error HTTP: ${pacientesResponse.statusCode}');
      }
    } catch (e) {
      print('❌ Error en getEstadisticasConsultas: $e');
      throw Exception('Error loading consultas stats: $e');
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
        getEstadisticasConsultas(),
      ]);
      
      return {
        'examenes': futures[0],
        'fichas': futures[1], 
        'pacientes': futures[2],
        'consultas': futures[3],
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      print('❌ Error en getDashboardCompleto: $e');
      throw Exception('Error loading dashboard: $e');
    }
  }
}