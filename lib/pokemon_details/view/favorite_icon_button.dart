import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/favorites/viewmodel/favorites_view_model.dart';

class FavoriteIconButton extends StatelessWidget {
  final PokemonListItem pokemon;

  const FavoriteIconButton({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final favVM = GetIt.I<FavoritesViewModel>();

    return ValueListenableBuilder<List<PokemonListItem>>(
      valueListenable: favVM.favoritesListenable,
      builder: (context, value, child) {
        final isFav = value.any((e) => e.id == pokemon.id);

        return IconButton(
          onPressed: () => _toggleFavorite(isFav),
          icon: Icon(isFav ? Icons.star : Icons.star_border_outlined, size: 36),
        );
      },
    );
  }

  void _toggleFavorite(bool isFav) {
    final favVM = GetIt.I<FavoritesViewModel>();
    if (isFav) {
      favVM.removeFavorite(pokemon.id);
    } else {
      favVM.addFavorite(pokemon);
    }
  }
}