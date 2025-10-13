import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokeapp/common/view/default_error_card_widget.dart';
import 'package:pokeapp/common/view/pokemon_image_widget.dart';
import 'package:pokeapp/common/helper_methods.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_state.dart';
import 'package:pokeapp/pokemon_details/view/about_tab.dart';
import 'package:pokeapp/pokemon_details/view/evolution_tab.dart';
import 'package:pokeapp/pokemon_details/view/favorite_icon_button.dart';
import 'package:pokeapp/pokemon_details/view/stats_tab.dart';
import 'package:pokeapp/pokemon_details/viewmodel/pokemon_details_view_model.dart';

class PokemonDetailsPage extends StatefulWidget {
  final String nameOrId;

  const PokemonDetailsPage({super.key, required this.nameOrId});

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage> {
  final _vm = GetIt.I<PokemonDetailsViewModel>();

  @override
  void initState() {
    _vm.fetchPokemonDetails(widget.nameOrId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ValueListenableBuilder(
          valueListenable: _vm.detailsListenable,
          builder: (context, value, child) => switch (value) {
            PokemonDetailsLoading() => const Center(child: CircularProgressIndicator()),
            PokemonDetailsError() => DefaultErrorCardWidget(
              onRetry: () => _vm.fetchPokemonDetails(widget.nameOrId),
            ),
            PokemonDetailsLoaded(bundle: var b) => _PokemonDetailsWidget(details: b),
          },
        ),
      ),
    );
  }
}



class _PokemonDetailsWidget extends StatelessWidget {
  final PokemonDetailsBundle details;

  const _PokemonDetailsWidget({required this.details});

  @override
  Widget build(BuildContext context) {
    final p = details.pokemon;
    final mainType = p.types.first.typeName;
    final color = HelperMethods.typeColor(mainType);

    return DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerScrolled) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 280,
              backgroundColor: color,
              title: Text(
                '#${p.id.toString().padLeft(4, "0")} ${HelperMethods.cap(p.name)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              actions: [FavoriteIconButton(pokemon: p.toListItem)],
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: PokemonImageWidget(id: p.id, height: 220, fit: BoxFit.contain),
                ),
              ),
              bottom: const TabBar(
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'About'),
                  Tab(text: 'Stats'),
                  Tab(text: 'Evolution'),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              AboutTab(bundle: details),
              StatsTab(pokemon: p),
              EvolutionTab(root: details.evolution),
            ],
          ),
        ),
    );
  }
}
