import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';

sealed class PokemonDetailsState {}

class PokemonDetailsLoading extends PokemonDetailsState {}

class PokemonDetailsError extends PokemonDetailsState {}

class PokemonDetailsLoaded extends PokemonDetailsState {
  final PokemonDetailsBundle bundle;

  PokemonDetailsLoaded(this.bundle);
}
