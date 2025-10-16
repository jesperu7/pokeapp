import 'dart:math';

import 'package:pokeapp/common/model/poke_api_resource.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/network_client.dart';
import 'package:pokeapp/network/result.dart';

abstract interface class IRandomPokemonRemoteSource {
  Future<Result<PokemonListItem>> fetchRandomPokemon();
}

class RandomPokemonRemoteSource implements IRandomPokemonRemoteSource {
  final NetworkClient _client;

  RandomPokemonRemoteSource(this._client);

  final _rng = Random();

  @override
  Future<Result<PokemonListItem>> fetchRandomPokemon() async {
    try {
      final countRes = await _client.get('/pokemon-species/', queryParameters: {'limit': 1});
      final count = countRes.data['count'] as int;

      final offset = _rng.nextInt(count);
      final pickRes = await _client.get(
        '/pokemon-species/',
        queryParameters: {'limit': 1, 'offset': offset},
      );

      final results = pickRes.data['results'] as List<dynamic>;
      final spec = PokeAPIResource.fromJson(results.first as Map<String, dynamic>);
      return Result.ok(PokemonListItem.fromAPIResource(spec));
    } catch (e) {
      return Result.error(Exception('Error fetching random pokemon'));
    }
  }
}
