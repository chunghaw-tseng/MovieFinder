import 'package:moviefinder/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class MoviesState extends Equatable {
  const MoviesState();

  @override
  List<Object> get props => [];
}

class SearchInitialState extends MoviesState {}

class SearchLoadInProgressState extends MoviesState {}

/// Movie Search Load Success
class MoviesLoadSuccess extends MoviesState {
  final List<Results> movies;
  final int totalMovies;

  const MoviesLoadSuccess({@required this.movies, this.totalMovies})
      : assert(movies != null);

  @override
  List<Object> get props => [movies, totalMovies];
}

class SearchLoadFailureState extends MoviesState {}
