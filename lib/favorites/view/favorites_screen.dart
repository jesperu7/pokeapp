import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/common/view/pokemon_display_card_widget.dart';
import 'package:pokeapp/favorites/viewmodel/favorites_view_model.dart';
import 'package:pokeapp/pokemon_details/view/pokemon_details_page.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = GetIt.I<FavoritesViewModel>();
    return ValueListenableBuilder(
      valueListenable: vm.favoritesListenable,
      builder: (context, favorites, child) {
        if (favorites.isEmpty) {
         return const Center(child: Text('No favorites added yet!'));
        }

        return ListView.builder(
          itemBuilder: (context, index) {
            return PokemonDisplayCardWidget(
              item: favorites[index],
              onDetails: () => _openDetailsPage(context, favorites[index]),
            );
          },
          itemCount: favorites.length,
        );
      },
    );
  }

  void _openDetailsPage(BuildContext context, PokemonListItem item) {
    final route = MaterialPageRoute(builder: (_) => PokemonDetailsPage(nameOrId: item.name));
    Navigator.of(context).push(route);
  }
}
