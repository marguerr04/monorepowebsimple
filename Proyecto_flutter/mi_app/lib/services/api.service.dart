import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ IMPORTANTE:
  // Usa '10.0.2.2' si estás en un EMULADOR Android.
  // Usa 'localhost' si estás en Flutter Web.
  // Usa tu IP local (ej. 192.168.x.x) si pruebas en un CELULAR REAL.
  static const String baseUrl = 'http://localhost:3000'; // Cambia esto según tu configuración

  static Future<Map<String, dynamic>> testConnection() async {
    final response = await http.get(Uri.parse('$baseUrl/test-db'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al conectar: ${response.statusCode}');
    }
  }
}
