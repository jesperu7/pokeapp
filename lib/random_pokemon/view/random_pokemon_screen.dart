import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/common/view/default_error_card_widget.dart';
import 'package:pokeapp/common/view/pokemon_display_card_widget.dart';
import 'package:pokeapp/pokemon_details/view/pokemon_details_page.dart';
import 'package:pokeapp/random_pokemon/model/random_pokemon_state.dart';
import 'package:pokeapp/random_pokemon/viewmodel/random_pokemon_view_model.dart';

class RandomPokemonScreen extends StatefulWidget {
  const RandomPokemonScreen({super.key});

  @override
  State<RandomPokemonScreen> createState() => _RandomPokemonScreenState();
}

class _RandomPokemonScreenState extends State<RandomPokemonScreen> {
  final _vm = GetIt.I<RandomPokemonViewModel>();

  @override
  void initState() {
    super.initState();
    _vm.fetchRandomPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: _vm.randomPokemonListenable,
        builder: (_, state, __) => switch (state) {
          RandomPokemonLoading() => Center(child: CircularProgressIndicator()),
          RandomPokemonError() => DefaultErrorCardWidget(onRetry: _vm.fetchRandomPokemon),
          RandomPokemonLoaded(item: final it) => PokemonDisplayCardWidget(
            item: it,
            onDetails: () => _openDetailsPage(it),
            onAnother: _vm.fetchRandomPokemon,
          ),
        },
      ),
    );
  }

  void _openDetailsPage(PokemonListItem item) async {
    final route = MaterialPageRoute(builder: (_) => PokemonDetailsPage(nameOrId: item.name));
    Navigator.of(context).push(route);
  }
}
