import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/network/result.dart';
import 'package:pokeapp/poke_library/model/library_filter.dart';
import 'package:pokeapp/poke_library/model/pokemon_filters_response.dart';
import 'package:pokeapp/poke_library/model/pokemon_grid_state.dart';
import 'package:pokeapp/poke_library/viewmodel/poke_library_view_model.dart';

import 'mock_poke_library_remote_source.dart';

void main() {
  late MockPokeLibraryRemoteSource fakeRemoteSource;
  late PokeLibraryViewModel viewModel;
  late PokemonFiltersResponse mockFilters;
  late List<PokemonListItem> mockPokemonList;

  setUp(() {
    fakeRemoteSource = MockPokeLibraryRemoteSource();
    mockFilters = createMockFiltersResponse();
    mockPokemonList = createMockPokemonList();
    fakeRemoteSource.setFiltersResponse(Ok(mockFilters));
    fakeRemoteSource.setAllPokemonResponse(Ok(mockPokemonList));
    viewModel = PokeLibraryViewModel(fakeRemoteSource);
  });

  group('PokeLibraryViewModel', () {
    test('initial state is loading', () {
      expect(viewModel.libraryNotifier.value, isA<PokemonGridLoading>());
    });

    test('fetchFilters sets filter notifier', () async {
      fakeRemoteSource.setFiltersResponse(Ok(mockFilters));
      await viewModel.fetchFilters();
      expect(viewModel.filterListenable.value, equals(mockFilters));
    });

    test('fetchAllPokemonItems sets loaded state on success', () async {
      fakeRemoteSource.setAllPokemonResponse(Ok(mockPokemonList));
      await viewModel.fetchAllPokemonItems();
      expect(viewModel.libraryNotifier.value, isA<PokemonGridLoaded>());
      expect(
        (viewModel.libraryNotifier.value as PokemonGridLoaded).pokemon,
        equals(mockPokemonList),
      );
    });

    test('fetchAllPokemonItems sets error state on failure', () async {
      fakeRemoteSource.setAllPokemonResponse(Error(Exception('Error')));
      await viewModel.fetchAllPokemonItems();
      expect(viewModel.libraryNotifier.value, isA<PokemonGridError>());
    });

    test('fetchPokemonForType sets loaded state on success', () async {
      fakeRemoteSource.setTypeResponse('electric', Ok(mockPokemonList));
      await viewModel.fetchPokemonForType('electric');
      expect(viewModel.libraryNotifier.value, isA<PokemonGridLoaded>());
      expect(
        (viewModel.libraryNotifier.value as PokemonGridLoaded).pokemon,
        equals(mockPokemonList),
      );
    });

    test('fetchPokemonForType sets error state on failure', () async {
      fakeRemoteSource.setTypeResponse('electric', Error(Exception('Error')));
      await viewModel.fetchPokemonForType('electric');
      expect(viewModel.libraryNotifier.value, isA<PokemonGridError>());
    });

    test('fetchPokemonForGeneration sets loaded state on success', () async {
      fakeRemoteSource.setGenerationResponse('generation-i', Ok(mockPokemonList));
      await viewModel.fetchPokemonForGeneration('generation-i');
      expect(viewModel.libraryNotifier.value, isA<PokemonGridLoaded>());
      expect(
        (viewModel.libraryNotifier.value as PokemonGridLoaded).pokemon,
        equals(mockPokemonList),
      );
    });

    test('fetchPokemonForGeneration sets error state on failure', () async {
      fakeRemoteSource.setGenerationResponse('generation-i', Error(Exception('Error')));
      await viewModel.fetchPokemonForGeneration('generation-i');
      expect(viewModel.libraryNotifier.value, isA<PokemonGridError>());
    });

    test('applyFilter with TypeFilter fetches Pokémon for type', () async {
      fakeRemoteSource.setTypeResponse('electric', Ok(mockPokemonList));
      await viewModel.applyFilter( TypeFilter('electric'));
      expect(viewModel.filter, isA<TypeFilter>());
      expect(viewModel.libraryNotifier.value, isA<PokemonGridLoaded>());
      expect(
        (viewModel.libraryNotifier.value as PokemonGridLoaded).pokemon,
        equals(mockPokemonList),
      );
    });

    test('applyFilter with GenerationFilter fetches Pokémon for generation', () async {
      fakeRemoteSource.setGenerationResponse('generation-i', Ok(mockPokemonList));
      await viewModel.applyFilter( GenerationFilter('generation-i'));
      expect(viewModel.filter, isA<GenerationFilter>());
      expect(viewModel.libraryNotifier.value, isA<PokemonGridLoaded>());
      expect(
        (viewModel.libraryNotifier.value as PokemonGridLoaded).pokemon,
        equals(mockPokemonList),
      );
    });

    test('applyFilter with NoFilter uses cached items', () async {
      fakeRemoteSource.setAllPokemonResponse(Ok(mockPokemonList));
      await viewModel.fetchAllPokemonItems();
      await viewModel.applyFilter( NoFilter());
      expect(viewModel.filter, isA<NoFilter>());
      expect(viewModel.libraryNotifier.value, isA<PokemonGridLoaded>());
      expect(
        (viewModel.libraryNotifier.value as PokemonGridLoaded).pokemon,
        equals(mockPokemonList),
      );
    });

    test('fetchAllPokemonItems notifies listeners on state changes', () async {
      fakeRemoteSource.setAllPokemonResponse(Ok(mockPokemonList));
      final notifiedStates = <PokemonGridState>[];
      notifiedStates.add(viewModel.libraryNotifier.value);
      viewModel.libraryNotifier.addListener(() {
        notifiedStates.add(viewModel.libraryNotifier.value);
      });

      await viewModel.fetchAllPokemonItems();

      expect(notifiedStates, [
        isA<PokemonGridLoading>(),
        isA<PokemonGridLoading>(),
        isA<PokemonGridLoaded>(),
      ]);
      expect((notifiedStates.last as PokemonGridLoaded).pokemon, equals(mockPokemonList));
    });
  });
}
