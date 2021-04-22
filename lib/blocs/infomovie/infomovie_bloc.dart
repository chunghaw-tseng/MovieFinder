import 'package:flutter/material.dart';
import 'package:flutter_template/blocs/blocs.dart';
import 'package:flutter_template/model/models.dart';
import 'package:flutter_template/repository/repositories.dart';
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
        debugPrint("Getting Movie Details");
        final Movie movieInfo = await moviesRepository.getMovieData(event.id);
        debugPrint("Received movies size ${movieInfo}");
        yield InfoMovieLoadSuccess(movieInfo: movieInfo);
      } catch (_) {
        yield InfoLoadFailureState();
      }
    }
  }
}
