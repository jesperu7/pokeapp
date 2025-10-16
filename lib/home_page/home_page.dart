import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokeapp/favorites/view/favorites_screen.dart';
import 'package:pokeapp/poke_library/view/filter_panel_widget.dart';
import 'package:pokeapp/poke_library/view/poke_library_screen.dart';
import 'package:pokeapp/random_pokemon/view/random_pokemon_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: SvgPicture.asset('assets/logo.svg', height: 50)),
      ),
      floatingActionButton: HomePageTabs.values[_selectedIndex].showActionButton
          ? FloatingActionButton(onPressed: _showFilters, child: const Icon(Icons.list_sharp))
          : null,

      body: IndexedStack(
        index: _selectedIndex,
        children: const [RandomPokemonScreen(), PokeLibraryScreen(), FavoritesScreen()],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shuffle), label: 'Random'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => const FilterPanelWidget(),
    );
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);
}

enum HomePageTabs {
  randomPokemonScreen(false),
  pokeLibraryScreen(true),
  favoritesScreen(false);

  final bool showActionButton;

  const HomePageTabs(this.showActionButton);
}
