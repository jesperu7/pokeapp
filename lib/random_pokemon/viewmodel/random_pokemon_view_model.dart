import 'package:flutter/foundation.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/random_pokemon/model/random_pokemon_state.dart';
import 'package:pokeapp/random_pokemon/model/data/random_pokemon_remote_source.dart';

class RandomPokemonViewModel {
  final IRandomPokemonRemoteSource _remoteSource;

  RandomPokemonViewModel(this._remoteSource);

  final _stateNotifier = ValueNotifier<RandomPokemonState>(RandomPokemonLoading());

  ValueListenable<RandomPokemonState> get randomPokemonListenable => _stateNotifier;

  void _setLoading() => _stateNotifier.value = RandomPokemonLoading();

  void _setError() => _stateNotifier.value = RandomPokemonError();

  void _setPokemon(PokemonListItem item) => _stateNotifier.value = RandomPokemonLoaded(item);

  Future<void> fetchRandomPokemon() async {
    _setLoading();
    final res = await _remoteSource.fetchRandomPokemon();
    res is Ok<PokemonListItem> ? _setPokemon(res.value) : _setError();
  }
}
