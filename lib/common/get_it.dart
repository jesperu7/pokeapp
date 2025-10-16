import 'package:get_it/get_it.dart';
import 'package:pokeapp/favorites/model/data/favorites_local_source.dart';
import 'package:pokeapp/favorites/viewmodel/favorites_view_model.dart';
import 'package:pokeapp/network/network_client.dart';
import 'package:pokeapp/poke_library/model/data/poke_library_remote_source.dart';
import 'package:pokeapp/poke_library/viewmodel/poke_library_view_model.dart';
import 'package:pokeapp/pokemon_details/model/data/pokemon_details_remote_source.dart';
import 'package:pokeapp/pokemon_details/viewmodel/pokemon_details_view_model.dart';
import 'package:pokeapp/random_pokemon/model/data/random_pokemon_remote_source.dart';
import 'package:pokeapp/random_pokemon/viewmodel/random_pokemon_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetItInitialization {
  Future<void> init() async {
    final getIt = GetIt.I;

    final networkClient = NetworkClient();
    final prefs = await SharedPreferences.getInstance();

    final randomPokemonRemoteSource = RandomPokemonRemoteSource(networkClient);
    final randomPokemonVM = RandomPokemonViewModel(randomPokemonRemoteSource);
    getIt.registerSingleton<RandomPokemonViewModel>(randomPokemonVM);

    final detailsRemoteSource = PokemonDetailsRemoteSource(networkClient);
    final detailsVm = PokemonDetailsViewModel(detailsRemoteSource);
    getIt.registerSingleton<PokemonDetailsViewModel>(detailsVm);

    final favoritesLocalSource = FavoritesLocalSource(prefs);
    final favoritesVM = FavoritesViewModel(favoritesLocalSource);
    getIt.registerSingleton<FavoritesViewModel>(favoritesVM);

    final generationsRemoteSource = PokeLibraryRemoteSource(networkClient);
    final generationsVM = PokeLibraryViewModel(generationsRemoteSource);
    getIt.registerSingleton<PokeLibraryViewModel>(generationsVM);
  }
}
