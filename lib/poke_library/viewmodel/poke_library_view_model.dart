import 'package:flutter/foundation.dart';
import 'package:fuzzy_bolt/fuzzy_bolt.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/poke_library/model/library_filter.dart';
import 'package:pokeapp/poke_library/model/pokemon_filters_response.dart';
import 'package:pokeapp/poke_library/model/pokemon_grid_state.dart';
import 'package:pokeapp/poke_library/viewmodel/poke_library_remote_source.dart';

class PokeLibraryViewModel {
  final IPokeLibraryRemoteSource _remoteSource;

  PokeLibraryViewModel(this._remoteSource);

  final ValueNotifier<PokemonGridState> _libraryNotifier = ValueNotifier(PokemonGridLoading());

  ValueListenable<PokemonGridState> get libraryNotifier => _libraryNotifier;

  final ValueNotifier<PokemonFiltersResponse?> _filterNotifier = ValueNotifier(null);

  ValueListenable<PokemonFiltersResponse?> get filterListenable => _filterNotifier;

  Iterable<PokemonListItem>? _allItemsCache;
  Iterable<PokemonListItem> _searchFilterCache = [];

  LibraryFilter filter = NoFilter();

  void _setLoading() => _libraryNotifier.value = PokemonGridLoading();

  void _setError() => _libraryNotifier.value = PokemonGridError();

  void _setItems(List<PokemonListItem> items) => _libraryNotifier.value = PokemonGridLoaded(items);

  Future<void> fetchFilters() async {
    final res = await _remoteSource.fetchFilters();
    if (res is Ok<PokemonFiltersResponse>) {
      _filterNotifier.value = res.value;
    }
  }

  Future<void> fetchAllPokemonItems() async {
    _setLoading();
    final res = await _remoteSource.fetchAllPokemonItems();
    switch (res) {
      case Ok<List<PokemonListItem>>():
        _allItemsCache = res.value.toList(growable: false);
        _setItems(res.value);
      case Error<List<PokemonListItem>>():
        _setError();
    }
  }

  Future<void> applyFilter(LibraryFilter f) async {
    switch (f) {
      case TypeFilter():
        filter = f;
        await fetchPokemonForType(f.value);
      case GenerationFilter():
        filter = f;
        await fetchPokemonForGeneration(f.value);
      case NoFilter():
        resetOrRefetch();
    }
  }

  Future<void> fetchPokemonForType(String type) async {
    final res = await _remoteSource.fetchPokemonForType(type);
    switch (res) {
      case Ok<List<PokemonListItem>>():
        _setItems(res.value);
        _searchFilterCache = res.value;
      case Error<List<PokemonListItem>>():
        _setError();
    }
  }

  Future<void> fetchPokemonForGeneration(String gen) async {
    final res = await _remoteSource.fetchPokemonForGeneration(gen);
    switch (res) {
      case Ok<List<PokemonListItem>>():
        _setItems(res.value);
        _searchFilterCache = res.value;
      case Error<List<PokemonListItem>>():
        _setError();
    }
  }

  void resetOrRefetch() async {
    filter = NoFilter();
    _allItemsCache != null
        ? _setItems(_allItemsCache!.toList(growable: false))
        : fetchAllPokemonItems();
  }

  void resetSearch() {
    _setItems(_searchFilterCache.toList());
  }

  void applySearchWord(String search) async {
    final all = _searchFilterCache.toList();
    final q = search.trim().toLowerCase();

    if (q.isEmpty) {
      resetSearch();
      return;
    }

    if (q.length == 1) {
      final res = all
          .where((p) => p.name.toLowerCase().startsWith(q) || p.name.toLowerCase().contains(q))
          .toList();
      _setItems(res);
      return;
    }

    final results = await FuzzyBolt.search<PokemonListItem>(
      all,
      q,
      selectors: [(u) => u.name],
      strictThreshold: 0.70,
      typeThreshold: 0.40,
      enableStemming: false,
      enableCleaning: false,
      maxResults: 500,
    );

    if (results.isEmpty) {
      final res = all.where((p) => p.name.toLowerCase().contains(q)).toList();
      _setItems(res);
    } else {
      _setItems(results);
    }
  }
}
