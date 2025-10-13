import 'package:flutter_test/flutter_test.dart';
import 'package:pokeapp/common/model/pokemon_list_item.dart';
import 'package:pokeapp/favorites/viewmodel/favorites_view_model.dart';

import 'mock_favorites_local_source.dart';

void main() {
  late MockFavoritesLocalSource fakeLocalSource;
  late FavoritesViewModel viewModel;
  late List<PokemonListItem> testFavorites;

  setUp(() {
    fakeLocalSource = MockFavoritesLocalSource();
    viewModel = FavoritesViewModel(fakeLocalSource);
    testFavorites = [
      PokemonListItem(id: 1, name: 'Pikachu'),
      PokemonListItem(id: 2, name: 'Bulbasaur'),
    ];
  });

  group('FavoritesViewModel', () {
    test('initializes with empty favorites when storage is empty', () {
      expect(viewModel.favoritesListenable.value, isEmpty);
    });

    test('initializes with stored favorites from local source', () {
      fakeLocalSource.setFavoritesForTest(testFavorites);
      viewModel = FavoritesViewModel(fakeLocalSource);

      expect(viewModel.favoritesListenable.value, equals(testFavorites));
    });

    test('addFavorite adds new item and updates storage', () async {
      final newItem = PokemonListItem(id: 3, name: 'Charmander');

      await viewModel.addFavorite(newItem);

      expect(viewModel.favoritesListenable.value, contains(newItem));
      expect(viewModel.favoritesListenable.value.length, 1);
      expect(fakeLocalSource.fetchStoredFavorites(), contains(newItem));
    });

    test('addFavorite does not add duplicate item', () async {
      final item = PokemonListItem(id: 1, name: 'Pikachu');
      await viewModel.addFavorite(item);

      await viewModel.addFavorite(item);

      expect(viewModel.favoritesListenable.value.length, 1);
      expect(viewModel.favoritesListenable.value, contains(item));
      expect(fakeLocalSource.fetchStoredFavorites()?.length, 1);
    });

    test('removeFavorite removes item and updates storage', () async {
      fakeLocalSource.setFavoritesForTest(testFavorites);
      viewModel = FavoritesViewModel(fakeLocalSource);

      await viewModel.removeFavorite(1);

      expect(viewModel.favoritesListenable.value.length, 1);
      expect(viewModel.favoritesListenable.value, isNot(contains(testFavorites[0])));
      expect(fakeLocalSource.fetchStoredFavorites()?.length, 1);
      expect(fakeLocalSource.fetchStoredFavorites(), isNot(contains(testFavorites[0])));
    });

    test('removeFavorite does nothing if item does not exist', () async {
      fakeLocalSource.setFavoritesForTest(testFavorites);
      viewModel = FavoritesViewModel(fakeLocalSource);

      await viewModel.removeFavorite(999);

      expect(viewModel.favoritesListenable.value.length, 2);
      expect(viewModel.favoritesListenable.value, equals(testFavorites));
      expect(fakeLocalSource.fetchStoredFavorites(), equals(testFavorites));
    });

    test('favoritesListenable notifies listeners on change', () async {
      final newItem = PokemonListItem(id: 3, name: 'Charmander');
      var notifiedValues = <List<PokemonListItem>>[];
      viewModel.favoritesListenable.addListener(() {
        notifiedValues.add(viewModel.favoritesListenable.value);
      });

      await viewModel.addFavorite(newItem);

      expect(notifiedValues, [
        [newItem],
      ]);
    });
  });
}