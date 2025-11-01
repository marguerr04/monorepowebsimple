import 'package:dio/dio.dart';

class PokeApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://pokeapi.co/api/v2/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<List<dynamic>> getPokemons() async {
    try {
      final response = await _dio.get('pokemon?limit=5');
      if (response.statusCode == 200) {
        return response.data['results']; 
      } else {
        throw Exception('Error al obtener los Pokémon');
      }
    } catch (e) {
      print('Error: $e');
      rethrow;
    }
  }
}
