import 'dart:async';
import 'dart:convert';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IFavoritesLocalSource {
  Future<void> storeFavorites(List<PokemonListItem> favorites);
  List<PokemonListItem>? fetchStoredFavorites();
}

class FavoritesLocalSource implements IFavoritesLocalSource {
  final SharedPreferences _prefs;

  FavoritesLocalSource(this._prefs);

  static const _favoritesKey = 'favorites';

  @override
  Future<void> storeFavorites(List<PokemonListItem> favorites) async {
    final jsonString = jsonEncode(favorites.toJson());
    await _prefs.setString(_favoritesKey, jsonString);
  }

  @override
  List<PokemonListItem>? fetchStoredFavorites() {
    final jsonString = _prefs.getString(_favoritesKey);
    if (jsonString == null) return null;
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return PokemonListItem.fromJsonList(jsonList);
  }
}




