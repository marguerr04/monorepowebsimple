import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/consulta.model.dart';

class ConsultasService {
  final String baseUrl = "http://localhost:3000";

  Future<Consulta> actualizarConsulta(
    int id,
    String diagnostico,
    String estado,
    String especialidad,
    String establecimiento,
  ) async {
    final uri = Uri.parse('$baseUrl/api/consultas/$id');

    final response = await http.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'diagnostico': diagnostico,
        'estado': estado,
        'especialidad_a_cargo': especialidad,
        'establecimiento': establecimiento,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return Consulta.fromJson(jsonResponse['consulta']);
    } else {
      throw Exception('Error ${response.statusCode} al actualizar consulta');
    }
  }
}
