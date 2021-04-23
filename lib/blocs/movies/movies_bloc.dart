import 'package:flutter/material.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/repository/repositories.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final MoviesRepository moviesRepository;
  List<Results> searchPages = [];
  int _currentPage = 1;

  MoviesBloc({@required this.moviesRepository})
      : assert(moviesRepository != null),
        super(SearchInitialState());

  @override
  Stream<MoviesState> mapEventToState(MoviesEvent event) async* {
    // Search Movies
    if (event is MoviesRequested) {
      yield SearchLoadInProgressState();
      try {
        debugPrint("Getting New Movies ${event.query}");
        final MovieSearch movies =
            await moviesRepository.getMovies(event.query, _currentPage);
        searchPages = [];
        searchPages.addAll(movies.results);
        debugPrint("Received movies size ${movies.results.length}");
        yield MoviesLoadSuccess(
            movies: searchPages, totalMovies: movies.totalResults);
      } catch (_) {
        yield SearchLoadFailureState();
      }
    } else if (event is NextPageRequested) {
      try {
        debugPrint("Getting Next Page");
        _currentPage += 1;
        final MovieSearch movies =
            await moviesRepository.getMovies(event.query, _currentPage);
        searchPages.addAll(movies.results);
        debugPrint("Received movies size ${searchPages.length}");
        yield MoviesLoadSuccess(movies: searchPages);
      } catch (_) {
        yield SearchLoadFailureState();
      }
    }
  }
}
