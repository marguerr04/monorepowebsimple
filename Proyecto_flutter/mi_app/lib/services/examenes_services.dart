import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/examen_stats.model.dart';

class ExamenesService {
  final String baseUrl = "http://localhost:3000";

  Future<List<ExamenStats>> fetchEstadisticas({String? lastFetchTime}) 
  async {
    final uri = Uri.parse("$baseUrl/api/examenes/estadisticas")
        .replace(queryParameters: {
          if (lastFetchTime != null) 'lastFetchTime': lastFetchTime
        });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => ExamenStats.fromJson(e)).toList();
    } else {
      throw Exception("Error al cargar estadísticas de exámenes");
    }
  }
}
