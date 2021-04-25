import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:moviefinder/blocs/infomovie/infomovie.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/repository/repositories.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

class MockInfoMoviesBloc extends MockBloc<InfoMovieEvent, InfoMovieState>
    implements InfoMovieBloc {}

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  InfoMovieBloc infoBloc;
  MockMoviesRepository moviesRepository;

  setUp(() {
    moviesRepository = MockMoviesRepository();
    infoBloc = InfoMovieBloc(moviesRepository: moviesRepository);
  });

  group('InfoMovieBloc', () {
    var infoMovieResult = Movie();

    blocTest(
      'emits [] when bloc started',
      build: () => infoBloc,
      expect: () => [],
    );

    blocTest(
        'emits [InfoLoadInProgressState, InfoMovieLoadSuccess] when successful',
        build: () {
          when(moviesRepository.getMovieData(1))
              .thenAnswer((_) async => infoMovieResult);
          return InfoMovieBloc(moviesRepository: moviesRepository);
        },
        act: (bloc) => bloc.add(InfoMovieRequested(id: 1)),
        expect: () => [
              InfoLoadInProgressState(),
              InfoMovieLoadSuccess(
                movieInfo: infoMovieResult,
              )
            ]);

    blocTest(
        'emits [InfoLoadInProgressState, InfoLoadFailureState] when failure',
        build: () {
          when(moviesRepository.getMovieData(any))
              .thenThrow(SocketException("No internet"));
          return InfoMovieBloc(moviesRepository: moviesRepository);
        },
        act: (bloc) => bloc.add(InfoMovieRequested(id: 1)),
        expect: () => [InfoLoadInProgressState(), InfoLoadFailureState()]);
  });
}
