import 'package:flutter/material.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/repository/repositories.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class InfoMovieBloc extends Bloc<InfoMovieEvent, InfoMovieState> {
  final MoviesRepository moviesRepository;

  InfoMovieBloc({@required this.moviesRepository})
      : assert(moviesRepository != null),
        super(InfoInitialState());

  @override
  Stream<InfoMovieState> mapEventToState(InfoMovieEvent event) async* {
    if (event is InfoMovieRequested) {
      yield InfoLoadInProgressState();
      try {
        final Movie movieInfo = await moviesRepository.getMovieData(event.id);
        yield InfoMovieLoadSuccess(movieInfo: movieInfo);
      } catch (_) {
        yield InfoLoadFailureState();
      }
    }
  }
}
