import 'package:flutter/foundation.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_state.dart';
import 'package:pokeapp/pokemon_details/viewmodel/pokemon_details_remote_source.dart';

class PokemonDetailsViewModel {
  final IPokemonDetailsRemoteSource _remoteSource;

  PokemonDetailsViewModel(this._remoteSource);

  final ValueNotifier<PokemonDetailsState> _detailsNotifier = ValueNotifier(
    PokemonDetailsLoading(),
  );

  ValueListenable<PokemonDetailsState> get detailsListenable => _detailsNotifier;

  void _setLoading() => _detailsNotifier.value = PokemonDetailsLoading();

  void _setError() => _detailsNotifier.value = PokemonDetailsError();

  void _setBundle(PokemonDetailsBundle bundle) =>
      _detailsNotifier.value = PokemonDetailsLoaded(bundle);

  Future<void> fetchPokemonDetails(String nameOrId) async {
    _setLoading();

    final res = await _remoteSource.fetchPokemonDetails(nameOrId);
    res is Ok<PokemonDetailsBundle> ? _setBundle(res.value) : _setError();
  }
}
