import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_bundle.dart';
import 'package:pokeapp/pokemon_details/model/pokemon_details_state.dart';
import 'package:pokeapp/pokemon_details/viewmodel/pokemon_details_view_model.dart';

import 'mock_pokemon_details_remote_source.dart';

void main() {
  late MockPokemonDetailsRemoteSource fakeRemoteSource;
  late PokemonDetailsViewModel viewModel;
  late PokemonDetailsBundle mockBundle;

  setUp(() {
    fakeRemoteSource = MockPokemonDetailsRemoteSource();
    viewModel = PokemonDetailsViewModel(fakeRemoteSource);
    mockBundle = createMockPokemonDetailsBundle();
  });

  group('PokemonDetailsViewModel', () {
    test('initial state is loading', () {
      expect(viewModel.detailsListenable.value, isA<PokemonDetailsLoading>());
    });

    test('fetchPokemonDetails sets loaded state on successful fetch', () async {
      fakeRemoteSource.setResponse('25', Ok(mockBundle));

      await viewModel.fetchPokemonDetails('25');

      expect(viewModel.detailsListenable.value, isA<PokemonDetailsLoaded>());
      expect(
        (viewModel.detailsListenable.value as PokemonDetailsLoaded).bundle,
        equals(mockBundle),
      );
    });

    test('fetchPokemonDetails sets error state on failed fetch', () async {
      fakeRemoteSource.setResponse('invalid', Result.error(Exception('API error')));

      await viewModel.fetchPokemonDetails('invalid');

      expect(viewModel.detailsListenable.value, isA<PokemonDetailsError>());
    });

    test('fetchPokemonDetails notifies listeners on state changes', () async {
      fakeRemoteSource.setResponse('25', Ok(mockBundle));
      var notifiedStates = <PokemonDetailsState>[];
      viewModel.detailsListenable.addListener(() {
        notifiedStates.add(viewModel.detailsListenable.value);
      });

      await viewModel.fetchPokemonDetails('25');

      expect(notifiedStates, [
        isA<PokemonDetailsLoading>(),
        isA<PokemonDetailsLoaded>(),
      ]);
      expect(
        (notifiedStates[1] as PokemonDetailsLoaded).bundle,
        equals(mockBundle),
      );
    });

    test('fetchPokemonDetails handles sequential calls correctly', () async {
      final secondBundle = createMockPokemonDetailsBundle();
      fakeRemoteSource.setResponse('25', Ok(mockBundle));
      fakeRemoteSource.setResponse('26', Ok(secondBundle));

      await viewModel.fetchPokemonDetails('25');
      await viewModel.fetchPokemonDetails('26');

      expect(viewModel.detailsListenable.value, isA<PokemonDetailsLoaded>());
      expect(
        (viewModel.detailsListenable.value as PokemonDetailsLoaded).bundle,
        equals(secondBundle),
      );
    });
  });
}