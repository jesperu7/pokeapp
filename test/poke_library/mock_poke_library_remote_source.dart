import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/poke_library/model/pokemon_filters_response.dart';
import 'package:pokeapp/poke_library/model/data/poke_library_remote_source.dart';

class MockPokeLibraryRemoteSource implements IPokeLibraryRemoteSource {
  final Map<String, Result<PokemonFiltersResponse>> _filterResponses = {};
  final Map<String, Result<List<PokemonListItem>>> _generationResponses = {};
  final Map<String, Result<List<PokemonListItem>>> _typeResponses = {};
  final Map<String, Result<List<PokemonListItem>>> _allPokemonResponses = {};

  @override
  Future<Result<PokemonFiltersResponse>> fetchFilters() async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    return _filterResponses['filters'] ?? Result.error(Exception('No filters response set'));
  }

  @override
  Future<Result<List<PokemonListItem>>> fetchPokemonForGeneration(String genName) async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    return _generationResponses['gen_$genName'] ??
        Result.error(Exception('No generation response set'));
  }

  @override
  Future<Result<List<PokemonListItem>>> fetchPokemonForType(String typeName) async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    return _typeResponses['type_$typeName'] ?? Result.error(Exception('No type response set'));
  }

  @override
  Future<Result<List<PokemonListItem>>> fetchAllPokemonItems() async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    return _allPokemonResponses['all_pokemon'] ??
        Result.error(Exception('No all pokemon response set'));
  }

  void setFiltersResponse(Result<PokemonFiltersResponse> result) {
    _filterResponses['filters'] = result;
  }

  void setGenerationResponse(String genName, Result<List<PokemonListItem>> result) {
    _generationResponses['gen_$genName'] = result;
  }

  void setTypeResponse(String typeName, Result<List<PokemonListItem>> result) {
    _typeResponses['type_$typeName'] = result;
  }

  void setAllPokemonResponse(Result<List<PokemonListItem>> result) {
    _allPokemonResponses['all_pokemon'] = result;
  }

  void clearResponses() {
    _filterResponses.clear();
    _generationResponses.clear();
    _typeResponses.clear();
    _allPokemonResponses.clear();
  }
}

PokemonListItem createMockPokemonListItem({int id = 25, String name = 'pikachu'}) {
  return PokemonListItem(id: id, name: name);
}

PokemonFiltersResponse createMockFiltersResponse() {
  return PokemonFiltersResponse(
    types: ['electric', 'fire'],
    generations: ['generation-i', 'generation-ii'],
  );
}

List<PokemonListItem> createMockPokemonList() {
  return [
    createMockPokemonListItem(id: 1, name: 'bulbasaur'),
    createMockPokemonListItem(id: 2, name: 'ivysaur'),
  ];
}
