import 'package:flutter/material.dart';
import '../services/poke_api.service.dart';

class PokeApiScreen extends StatefulWidget {
  const PokeApiScreen({super.key});

  @override
  State<PokeApiScreen> createState() => _PokeApiScreenState();
}

class _PokeApiScreenState extends State<PokeApiScreen> {
  final PokeApiService _apiService = PokeApiService();
  late Future<List<dynamic>> _pokemons;

  @override
  void initState() {
    super.initState();
    _pokemons = _apiService.getPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokédex API')),
      body: FutureBuilder<List<dynamic>>(
        future: _pokemons,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles'));
          } else {
            final pokemons = snapshot.data!;
            return ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final p = pokemons[index];
                return ListTile(
                  leading: Text('#${index + 1}'),
                  title: Text(p['name']),
                  subtitle: Text(p['url']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
