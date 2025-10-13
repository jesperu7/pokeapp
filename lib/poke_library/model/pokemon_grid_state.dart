import 'package:pokeapp/common/model/pokemon_list_item.dart';

sealed class PokemonGridState {}

class PokemonGridLoaded extends PokemonGridState {
  final Iterable<PokemonListItem> pokemon;

  PokemonGridLoaded(this.pokemon);
}

class PokemonGridError extends PokemonGridState {}

class PokemonGridLoading extends PokemonGridState {}

