import 'package:moviefinder/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class InfoMovieState extends Equatable {
  const InfoMovieState();

  @override
  List<Object> get props => [];
}

class InfoInitialState extends InfoMovieState {}

class InfoLoadInProgressState extends InfoMovieState {}

class InfoMovieLoadSuccess extends InfoMovieState {
  final Movie movieInfo;

  const InfoMovieLoadSuccess({@required this.movieInfo})
      : assert(movieInfo != null);

  @override
  List<Object> get props => [movieInfo];
}

class InfoLoadFailureState extends InfoMovieState {}
