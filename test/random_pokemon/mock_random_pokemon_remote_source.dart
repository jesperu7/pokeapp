import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/random_pokemon/viewmodel/random_pokemon_remote_source.dart';

class MockRandomPokemonRemoteSource implements IRandomPokemonRemoteSource {
  final Map<String, Result<PokemonListItem>> _responses = {};

  @override
  Future<Result<PokemonListItem>> fetchRandomPokemon() async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    return _responses['random'] ?? Result.error(Exception('No response set'));
  }

  void setResponse(Result<PokemonListItem> result) {
    _responses['random'] = result;
  }

  void clearResponses() {
    _responses.clear();
  }
}

PokemonListItem createMockPokemonListItem() {
  return PokemonListItem(id: 25, name: 'pikachu');
}
