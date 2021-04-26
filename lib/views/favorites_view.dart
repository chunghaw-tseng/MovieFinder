import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/widgets/favorites/favorite_item.dart';

class FavoritesView extends StatefulWidget {
  FavoritesView({Key key}) : super(key: key);

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FavoriteBloc>(context).add(FavoriteMoviesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
              pinned: true,
              floating: true,
              expandedHeight: 80.0,
              title: Text("My Favorites"),
              flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset(
                "assets/images/banner.jpg",
                fit: BoxFit.cover,
              ))),
          BlocBuilder<FavoriteBloc, FavoriteState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is FavoriteLoadInProgressState) {
                return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (state is FavoriteMovieLoadSuccess) {
                final info = state.favMovies;
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Dismissible(
                          key: Key("Favorite$index"),
                          child: FavoriteItem(
                            title: info[index].title,
                            posterURL: info[index].posterPath,
                            voteAverage: info[index].voteAverage,
                            genres: info[index].genresString,
                            releaseDate: info[index].releaseDate,
                            movieID: info[index].id,
                          ),
                          onDismissed: (direction) {
                            BlocProvider.of<FavoriteBloc>(context)
                                .add(FavoriteMovieDeleted(id: info[index].id));
                          },
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ));
                    },
                    childCount: info.length,
                  ),
                );
              }
              if (state is InfoLoadFailureState) {
                return SliverFillRemaining(
                    child: Center(
                        child: Row(
                  children: [
                    Icon(
                      Icons.adb_sharp,
                      color: Colors.red,
                    ),
                    Text(
                      'Oops! Something went wrong!',
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                )));
              }
            },
          ),
        ],
      ),
    );
  }
}
