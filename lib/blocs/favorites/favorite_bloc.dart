import 'package:moviefinder/blocs/favorites/favorites.dart';
import 'package:moviefinder/db/database.dart';
import 'package:moviefinder/models/models.dart';
import 'package:bloc/bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  List<Movie> favorites;
  FavoriteBloc() : super(FavoriteLoadInProgressState());

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteMoviesRequested) {
      yield* _mapFavoriteLoadedToState();
    } else if (event is FavoriteMovieAdded) {
      yield* _mapFavoriteAddedToState(event.movie);
    } else if (event is FavoriteMovieDeleted) {
      yield* _mapFavoriteDeletedToState(event.id);
    } else if (event is FavoriteMovieFound) {
      yield* _mapFavoriteStatusToState(event.id);
    }
  }

  Stream<FavoriteState> _mapFavoriteLoadedToState() async* {
    try {
      final List<Movie> favorites = await DBProvider.db.getallFavoriteMovies();
      yield FavoriteMovieLoadSuccess(favMovies: favorites);
    } catch (_) {
      yield FavoriteLoadFailureState();
    }
  }

  // Stream to check if the movie has been favorited
  Stream<FavoriteState> _mapFavoriteStatusToState(int id) async* {
    try {
      final List<Movie> isFav = await DBProvider.db.findFavoriteMovie(id);
      print("Gotten favorite response $isFav");
      yield FavoriteMovieLoadSuccess(favMovies: isFav);
    } catch (e) {
      yield FavoriteLoadFailureState();
    }
  }

  Stream<FavoriteState> _mapFavoriteAddedToState(Movie movie) async* {
    if (state is FavoriteMovieLoadSuccess) {
      final List<Movie> updatedMovies =
          await DBProvider.db.newFavoriteMovie(movie);
      yield FavoriteMovieLoadSuccess(favMovies: updatedMovies);
    }
  }

  Stream<FavoriteState> _mapFavoriteDeletedToState(int id) async* {
    if (state is FavoriteMovieLoadSuccess) {
      final List<Movie> updatedMovies = DBProvider.db.deleteFavoriteMovie(id);
      yield FavoriteMovieLoadSuccess(favMovies: updatedMovies);
    }
  }
}
