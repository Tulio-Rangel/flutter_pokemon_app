import 'package:flutter/material.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/services/poke_api_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PokeApiService _pokeApiService = PokeApiService();
  Pokemon? _pokemon;

  @override
  void initState() {
    super.initState();
    _fetchRandomPokemon();
  }

  Future<void> _fetchRandomPokemon() async {
    try {
      final pokemon = await _pokeApiService.getRandomPokemon();
      setState(() {
        _pokemon = pokemon;
      });
    } catch (e) {
      print('Error fetching Pokemon: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon App'),
      ),
      body: Center(
        child: _pokemon != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    _pokemon!.imageUrl,
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _pokemon!.name,
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRandomPokemon,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
