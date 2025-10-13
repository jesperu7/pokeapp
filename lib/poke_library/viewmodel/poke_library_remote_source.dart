import 'package:dio/dio.dart';
import 'package:pokeapp/common/model/poke_api_resource.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/network_client.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/poke_library/model/filter_list_response.dart';
import 'package:pokeapp/poke_library/model/pokemon_filters_response.dart';

abstract interface class IPokeLibraryRemoteSource {
  Future<Result<PokemonFiltersResponse>> fetchFilters();
  Future<Result<List<PokemonListItem>>> fetchPokemonForGeneration(String genName);
  Future<Result<List<PokemonListItem>>> fetchPokemonForType(String typeName);
  Future<Result<List<PokemonListItem>>> fetchAllPokemonItems();
}

class PokeLibraryRemoteSource implements IPokeLibraryRemoteSource {
  final NetworkClient _client;

  PokeLibraryRemoteSource(this._client);

  @override
  Future<Result<PokemonFiltersResponse>> fetchFilters() async {
    try {
      final typesFuture = _client.get('/type/');
      final gensFuture = _client.get('/generation/');

      final responses = await Future.wait<Response>([typesFuture, gensFuture]);
      final typeJson = responses[0].json;
      final genJson = responses[1].json;
      final types = FilterListResponse.fromJson(typeJson).results.map((e) => e.name).toList();
      final gens = FilterListResponse.fromJson(genJson).results.map((e) => e.name).toList();

      return Result.ok(PokemonFiltersResponse(types: types, generations: gens));
    } catch (e) {
      return Result.error(Exception('Failed to fetch filters: $e'));
    }
  }

  @override
  Future<Result<List<PokemonListItem>>> fetchPokemonForGeneration(String genName) async {
    try {
      final res = await _client.get('/generation/$genName/');

      final species = res.data['pokemon_species'] as List<dynamic>;

      final sorted =
          species
              .map((e) => PokeAPIResource.fromJson(e))
              .map((e) => PokemonListItem.fromAPIResource(e))
              .toList(growable: false)
            ..sort((a, b) => a.id.compareTo(b.id));

      return Result.ok(sorted);
    } catch (e) {
      return Result.error(Exception('Failed to fetch Pokémon for given generation: $e'));
    }
  }

  @override
  Future<Result<List<PokemonListItem>>> fetchPokemonForType(String typeName) async {
    try {
      final res = await _client.get('/type/$typeName/');
      final pokeListJson = res.json['pokemon'] as List<dynamic>;

      final sorted =
          pokeListJson
              .map((e) => PokeAPIResource.fromJson(e['pokemon']))
              .map((e) => PokemonListItem.fromAPIResource(e))
              .toList(growable: false)
            ..sort((a, b) => a.id.compareTo(b.id));

      return Result.ok(sorted);
    } catch (e) {
      return Result.error(Exception('Failed to fetch Pokémon for given generation: $e'));
    }
  }

  @override
  Future<Result<List<PokemonListItem>>> fetchAllPokemonItems() async {
    try {
      final res = await _client.get(
        '/pokemon-species/',
        queryParameters: {'limit': 20000, 'offset': 0},
      );
      final data = res.data as Map<String, dynamic>;
      final results =
          (data['results'] as List)
              .map((e) => PokeAPIResource.fromJson(e as Map<String, dynamic>))
              .map(PokemonListItem.fromAPIResource)
              .toList()
            ..sort((a, b) => a.id.compareTo(b.id));
      return Result.ok(results);
    } catch (e) {
      return Result.error(Exception('Failed to fetch Pokémon species: $e'));
    }
  }
}

