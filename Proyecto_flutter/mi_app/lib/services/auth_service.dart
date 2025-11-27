import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api.service.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserId = 'userId';
  static const String _keyUserName = 'userName';
  static const String _keyUserEmail = 'userEmail';

  // Login de administrador
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/api/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Guardar sesión
        await _saveSession(data['user']);
        return {
          'success': true,
          'user': data['user'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error de autenticación',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  // Guardar sesión
  Future<void> _saveSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    // Convertir id a int si viene como String
    final userId = user['id'] is int ? user['id'] : int.parse(user['id'].toString());
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUserName, user['name']);
    await prefs.setString(_keyUserEmail, user['email']);
  }

  // Verificar si está logueado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Obtener datos del usuario
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogged = prefs.getBool(_keyIsLoggedIn) ?? false;
    
    if (!isLogged) return null;

    return {
      'id': prefs.getInt(_keyUserId),
      'name': prefs.getString(_keyUserName),
      'email': prefs.getString(_keyUserEmail),
      'role': 'admin',
    };
  }

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
