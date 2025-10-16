import 'package:flutter/foundation.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/favorites/model/data/favorites_local_source.dart';

class FavoritesViewModel {
  final IFavoritesLocalSource _localSource;

  FavoritesViewModel(this._localSource) {
    fetchStoredFavorites();
  }

  final ValueNotifier<List<PokemonListItem>> _favoritesNotifier = ValueNotifier([]);

  ValueListenable<List<PokemonListItem>> get favoritesListenable => _favoritesNotifier;

  Future<void> fetchStoredFavorites() async {
      final items = _localSource.fetchStoredFavorites();
      _favoritesNotifier.value = items ?? [];
  }

  Future<void> addFavorite(PokemonListItem item) async {
    final list = List<PokemonListItem>.from(_favoritesNotifier.value);
    if (!list.any((e) => e.id == item.id)) {
      list.add(item);
      _favoritesNotifier.value = list;
      await _localSource.storeFavorites(list);
    }
  }

  Future<void> removeFavorite(int id) async {
    final list = List<PokemonListItem>.from(_favoritesNotifier.value);
    list.removeWhere((e) => e.id == id);
    _favoritesNotifier.value = list;
    await _localSource.storeFavorites(list);
  }
}