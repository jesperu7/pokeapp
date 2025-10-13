import 'package:pokeapp/common/model/pokemon_list_item.dart';

sealed class RandomPokemonState {}

class RandomPokemonLoading extends RandomPokemonState {}

class RandomPokemonLoaded extends RandomPokemonState {
  final PokemonListItem item;

  RandomPokemonLoaded(this.item);
}

class RandomPokemonError extends RandomPokemonState {}
