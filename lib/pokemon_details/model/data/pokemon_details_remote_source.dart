import 'package:dio/dio.dart';
import 'package:pokeapp/network/network_client.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';

abstract interface class IPokemonDetailsRemoteSource {
  Future<Result<PokemonDetailsBundle>> fetchPokemonDetails(String nameOrId);
}

class PokemonDetailsRemoteSource implements IPokemonDetailsRemoteSource {
  final NetworkClient _client;

  PokemonDetailsRemoteSource(this._client);

  @override
  Future<Result<PokemonDetailsBundle>> fetchPokemonDetails(String nameOrId) async {
    try {
      final pFuture = _client.get('/pokemon/$nameOrId/');
      final sFuture = _client.get('/pokemon-species/$nameOrId/');

      final responses = await Future.wait<Response>([pFuture, sFuture]);
      final pMap = responses[0].data;
      final sMap = responses[1].data;

      final pokemon = Pokemon.fromJson(pMap);
      final species = PokemonSpecies.fromJson(sMap);

      EvolutionNode? evolution;
      final evoUrl = species.evolutionChainUrl;
      if (evoUrl != null && evoUrl.isNotEmpty) {
        final evoRes = await _client.get(evoUrl);
        final chain = (evoRes.data)['chain'] as Map<String, dynamic>;
        evolution = EvolutionNode.fromChainJson(chain);
      }

      final details = PokemonDetailsBundle(pokemon: pokemon, species: species, evolution: evolution);
      return Result.ok(details);
    } catch (e) {
      return Result.error(Exception('Failed to fetch Pokémon: $e'));
    }
  }
}