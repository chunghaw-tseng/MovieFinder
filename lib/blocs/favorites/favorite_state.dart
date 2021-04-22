import 'package:moviefinder/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteLoadInProgressState extends FavoriteState {}

class FavoriteMovieLoadSuccess extends FavoriteState {
  final List<Movie> favMovies;

  const FavoriteMovieLoadSuccess({@required this.favMovies})
      : assert(favMovies != null);

  @override
  List<Object> get props => [favMovies];
}

class FavoriteLoadFailureState extends FavoriteState {}
