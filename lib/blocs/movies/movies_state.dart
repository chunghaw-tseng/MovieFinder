import 'package:moviefinder/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class MoviesSearchInitialState extends MoviesState {}

class MoviesSearchLoadInProgressState extends MoviesState {}

/// Movie Search Load Success
class MoviesSearchLoadSuccess extends MoviesState {
  final List<Results> movies;
  final int totalMovies;

  const MoviesSearchLoadSuccess({@required this.movies, this.totalMovies})
      : assert(movies != null);

  @override
  List<Object> get props => [movies, totalMovies];
}

class MoviesSearchLoadFailureState extends MoviesState {}
