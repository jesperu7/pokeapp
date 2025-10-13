import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/random_pokemon/model/random_pokemon_state.dart';
import 'package:pokeapp/random_pokemon/viewmodel/random_pokemon_view_model.dart';

import 'mock_random_pokemon_remote_source.dart';

void main() {
  late MockRandomPokemonRemoteSource fakeRemoteSource;
  late RandomPokemonViewModel viewModel;
  late PokemonListItem mockPokemon;

  setUp(() {
    fakeRemoteSource = MockRandomPokemonRemoteSource();
    viewModel = RandomPokemonViewModel(fakeRemoteSource);
    mockPokemon = createMockPokemonListItem();
  });

  group('RandomPokemonViewModel', () {
    test('initial state is loading', () {
      expect(viewModel.randomPokemonListenable.value, isA<RandomPokemonLoading>());
    });

    test('fetchRandomPokemon sets loaded state on successful fetch', () async {
      fakeRemoteSource.setResponse(Ok(mockPokemon));

      await viewModel.fetchRandomPokemon();

      expect(viewModel.randomPokemonListenable.value, isA<RandomPokemonLoaded>());
      expect(
        (viewModel.randomPokemonListenable.value as RandomPokemonLoaded).item,
        equals(mockPokemon),
      );
    });

    test('fetchRandomPokemon sets error state on failed fetch', () async {
      fakeRemoteSource.setResponse(Result.error(Exception('API error')));

      await viewModel.fetchRandomPokemon();

      expect(viewModel.randomPokemonListenable.value, isA<RandomPokemonError>());
    });

    test('fetchRandomPokemon notifies listeners on state changes', () async {
      fakeRemoteSource.setResponse(Ok(mockPokemon));
      final notifiedStates = <RandomPokemonState>[];
      notifiedStates.add(viewModel.randomPokemonListenable.value);
      viewModel.randomPokemonListenable.addListener(() {
        notifiedStates.add(viewModel.randomPokemonListenable.value);
      });

      await viewModel.fetchRandomPokemon();

      expect(notifiedStates, [
        isA<RandomPokemonLoading>(),
        isA<RandomPokemonLoading>(),
        isA<RandomPokemonLoaded>(),
      ]);
      expect((notifiedStates.last as RandomPokemonLoaded).item, equals(mockPokemon));
    });

    test('fetchRandomPokemon handles sequential calls correctly', () async {
      final secondPokemon = PokemonListItem(id: 26, name: 'raichu');
      fakeRemoteSource.setResponse(Ok(mockPokemon));
      await viewModel.fetchRandomPokemon();
      fakeRemoteSource.setResponse(Ok(secondPokemon));

      await viewModel.fetchRandomPokemon();

      expect(viewModel.randomPokemonListenable.value, isA<RandomPokemonLoaded>());
      expect(
        (viewModel.randomPokemonListenable.value as RandomPokemonLoaded).item,
        equals(secondPokemon),
      );
    });
  });
}
