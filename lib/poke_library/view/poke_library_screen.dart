import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/common/view/pokemon_image_widget.dart';
import 'package:pokeapp/poke_library/model/pokemon_grid_state.dart';
import 'package:pokeapp/poke_library/view/text_search_field_widget.dart';
import 'package:pokeapp/poke_library/viewmodel/poke_library_view_model.dart';
import 'package:pokeapp/pokemon_details/view/pokemon_details_page.dart';

class PokeLibraryScreen extends StatefulWidget {
  const PokeLibraryScreen({super.key});

  @override
  State<PokeLibraryScreen> createState() => _PokeLibraryScreenState();
}

class _PokeLibraryScreenState extends State<PokeLibraryScreen> {
  final vm = GetIt.I<PokeLibraryViewModel>();

  @override
  void initState() {
    super.initState();
    vm.fetchAllPokemonItems();
    vm.fetchFilters();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: vm.libraryNotifier,
      builder: (_, state, __) => switch (state) {
        PokemonGridLoaded(pokemon: var p) => _PokemonGridWidget(pokemon: p.toList()),
        PokemonGridError() => _PokemonGridErrorWidget(retry: vm.resetOrRefetch),
        PokemonGridLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _PokemonGridErrorWidget extends StatelessWidget {
  final VoidCallback retry;

  const _PokemonGridErrorWidget({required this.retry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Error fetching pokemon'),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: retry, child: Text('Retry')),
        ],
      ),
    );
  }
}

class _PokemonGridWidget extends StatelessWidget {
  final List<PokemonListItem> pokemon;

  const _PokemonGridWidget({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSearchFieldWidget(),
        if (pokemon.isEmpty)
          Center(child: Text('No Pokemon to display'))
        else
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: pokemon.length,
              itemBuilder: (context, index) {
                final item = pokemon[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () => _pokemonTapped(context, item.name),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: PokemonImageWidget(id: item.id, fit: BoxFit.contain),
                        ),
                        Text(
                          '#${item.id} ${item.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  void _pokemonTapped(BuildContext context, String name) {
    final route = MaterialPageRoute(builder: (_) => PokemonDetailsPage(nameOrId: name));
    Navigator.of(context).push(route);
  }
}
