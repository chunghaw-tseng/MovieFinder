import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/repository/repositories.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:moviefinder/blocs/movies/movies.dart';

class MockMoviesBloc extends MockBloc<MoviesEvent, MoviesState>
    implements MoviesBloc {}

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  MoviesBloc moviesBloc;
  MockMoviesRepository moviesRepository;

  setUp(() {
    moviesRepository = MockMoviesRepository();
    moviesBloc = MoviesBloc(moviesRepository: moviesRepository);
  });

  group('MovieBloc', () {
    var movieResult = MovieSearch(
        page: 1, totalPages: 1, totalResults: 1, results: [Results()]);
    var movieResult2 = MovieSearch(
        page: 1,
        totalPages: 1,
        totalResults: 3,
        results: [Results(), Results(), Results()]);
    var movieResultPage2 = MovieSearch(
        page: 1,
        totalPages: 1,
        totalResults: 4,
        results: [Results(), Results(), Results(), Results()]);

    blocTest(
      'emits [] when bloc started',
      build: () => moviesBloc,
      expect: () => [],
    );

    blocTest(
        'emits [SearchLoadInProgressState, MoviesLoadSuccess] when successful',
        build: () {
          when(moviesRepository.getMovies("", 1))
              .thenAnswer((_) async => movieResult);
          return MoviesBloc(moviesRepository: moviesRepository);
        },
        act: (bloc) => bloc.add(MoviesRequested(query: "")),
        expect: () => [
              MoviesSearchLoadInProgressState(),
              MoviesSearchLoadSuccess(
                  movies: movieResult.results,
                  totalMovies: movieResult.totalResults)
            ]);
    blocTest(
        'emits [SearchLoadInProgressState, MoviesSearchLoadFailureState] when failure',
        build: () {
          when(moviesRepository.getMovies(any, any))
              .thenThrow(SocketException("No internet"));
          return MoviesBloc(moviesRepository: moviesRepository);
        },
        act: (bloc) => bloc.add(MoviesRequested(query: "")),
        expect: () => [
              MoviesSearchLoadInProgressState(),
              MoviesSearchLoadFailureState()
            ]);

    blocTest('resets results when new query was emitted',
        build: () {
          when(moviesRepository.getMovies("test", 1))
              .thenAnswer((_) async => movieResult2);
          var moviesBloc = MoviesBloc(moviesRepository: moviesRepository);
          moviesBloc.searchResults = [Results()];
          return moviesBloc;
        },
        act: (bloc) => bloc.add(MoviesRequested(query: "test")),
        expect: () => [
              MoviesSearchLoadInProgressState(),
              MoviesSearchLoadSuccess(
                  movies: movieResult2.results,
                  totalMovies: movieResult2.totalResults)
            ]);

    blocTest('adds up results when new page was emitted',
        build: () {
          when(moviesRepository.getMovies("", 2))
              .thenAnswer((_) async => movieResultPage2);
          var moviesBloc = MoviesBloc(moviesRepository: moviesRepository);
          moviesBloc.searchResults = [Results()];
          return MoviesBloc(moviesRepository: moviesRepository);
        },
        act: (bloc) => {bloc.add(NextPageRequested(query: ""))},
        expect: () => [
              MoviesSearchLoadSuccess(
                  movies: movieResultPage2.results,
                  totalMovies: movieResultPage2.totalResults)
            ]);
  });
}
