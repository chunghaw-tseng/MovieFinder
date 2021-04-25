import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:moviefinder/blocs/favorites/favorites.dart';
import 'package:moviefinder/db/database.dart';
import 'package:bloc_test/bloc_test.dart';

class MockFavoriteBloc extends MockBloc<FavoriteEvent, FavoriteState>
    implements FavoriteBloc {}

class MockFavoritesDB extends Mock implements DBProvider {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  FavoriteBloc favBloc;
  MockFavoritesDB favoritesDB;
  final channel = "plugins.flutter.io/path_provider";

  setUpAll(() async {
    favBloc = FavoriteBloc();
    favoritesDB = MockFavoritesDB();
    final directory = await Directory.systemTemp.createTemp();
    MethodChannel(channel)
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getTemporaryDirectory') {
        return directory.path;
      }
      return null;
    });
  });

  group('FavoriteBloc', () {
    blocTest(
      'emits [] when bloc started',
      build: () => favBloc,
      expect: () => [],
    );

    blocTest('should emit FavoriteLoadFailureState if repository throws errors',
        build: () {
          when(favoritesDB.getallFavoriteMovies())
              .thenThrow(Exception('Error'));
          return FavoriteBloc();
        },
        act: (bloc) => bloc.add(FavoriteMoviesRequested()),
        expect: () => [FavoriteLoadFailureState()]);

    /// More tests would go here
  });
}
