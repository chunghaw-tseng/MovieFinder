import 'package:flutter/material.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/repository/repositories.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository moviesRepository;
  List<Results> searchResults = [];
  int _currentPage = 1;

  MoviesBloc({@required this.moviesRepository})
      : assert(moviesRepository != null),
        super(MoviesSearchInitialState());

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    // Search Movies
    if (event is MoviesRequested) {
      yield MoviesSearchLoadInProgressState();
      try {
        final MovieSearch movies =
            await moviesRepository.getMovies(event.query, _currentPage);
        searchResults = [];
        searchResults.addAll(movies.results);
        yield MoviesSearchLoadSuccess(
            movies: searchResults, totalMovies: movies.totalResults);
      } catch (_) {
        yield MoviesSearchLoadFailureState();
      }
    } else if (event is NextPageRequested) {
      try {
        _currentPage += 1;
        final MovieSearch movies =
            await moviesRepository.getMovies(event.query, _currentPage);
        searchResults.addAll(movies.results);
        yield MoviesSearchLoadSuccess(
            movies: searchResults, totalMovies: movies.totalResults);
      } catch (_) {
        yield MoviesSearchLoadFailureState();
      }
    }
  }
}
