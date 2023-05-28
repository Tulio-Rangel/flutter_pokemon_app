import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/models/pokemon.dart';

class PokeApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  Future<Pokemon> getRandomPokemon() async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=100'));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      final pokemons = decodedData['results'] as List<dynamic>;
      final randomIndex = _getRandomIndex(pokemons.length);
      final randomPokemonUrl = pokemons[randomIndex]['url'] as String;
      final pokemonData = await _fetchPokemonData(randomPokemonUrl);
      final pokemon = _parsePokemonData(pokemonData);
      return pokemon;
    }
    throw Exception('Error fetching Pokemon data');
  }

  Future<Map<String, dynamic>> _fetchPokemonData(String pokemonUrl) async {
    final response = await http.get(Uri.parse(pokemonUrl));
    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      return decodedData;
    }
    throw Exception('Error fetching Pokemon data');
  }

  Pokemon _parsePokemonData(Map<String, dynamic> pokemonData) {
    final name = pokemonData['name'] as String;
    final imageUrl = pokemonData['sprites']['front_default'] as String;
    return Pokemon(name: name, imageUrl: imageUrl);
  }

  int _getRandomIndex(int max) {
    final random = Random();
    return random.nextInt(max);
  }
}
