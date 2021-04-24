import 'package:moviefinder/models/movie.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object> get props => [];
}

class FavoriteMoviesRequested extends FavoriteEvent {}

class FavoriteMovieDeleted extends FavoriteEvent {
  final int id;

  const FavoriteMovieDeleted({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class FavoriteMovieFound extends FavoriteEvent {
  final int id;

  const FavoriteMovieFound({@required this.id}) : assert(id != null);

  @override
  List<Object> get props => [id];
}

class FavoriteMovieAdded extends FavoriteEvent {
  final Movie movie;

  const FavoriteMovieAdded({@required this.movie}) : assert(movie != null);

  @override
  List<Object> get props => [movie];
}
