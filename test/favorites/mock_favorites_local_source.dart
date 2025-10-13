import 'dart:convert';

import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/favorites/viewmodel/favorites_local_source.dart';

class MockFavoritesLocalSource implements IFavoritesLocalSource {

  Map<String, String> _store = {};
  static const _favoritesKey = 'favorites';

  @override
  Future<void> storeFavorites(List<PokemonListItem> favorites) async {
    final jsonString = jsonEncode(favorites.toJson());
    _store = {_favoritesKey: jsonString};
  }

  @override
  List<PokemonListItem>? fetchStoredFavorites() {
    final jsonString = _store[_favoritesKey];
    if (jsonString == null) return null;
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return PokemonListItem.fromJsonList(jsonList);
  }

  void setFavoritesForTest(List<PokemonListItem> favorites) {
    final jsonString = jsonEncode(favorites.toJson());
    _store['favorites'] = jsonString;
  }

  void clearFavoritesForTest() {
    _store.clear();
  }
}