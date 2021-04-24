import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/widgets/favorites/favorite_item.dart';

class FavoritesView extends StatefulWidget {
  final Image bannerImg;
  FavoritesView({Key key, this.bannerImg}) : super(key: key);

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
              expandedHeight: 60.0,
              title: Text("My Favorites"),
              flexibleSpace: FlexibleSpaceBar(background: widget.bannerImg)),
          BlocBuilder<FavoriteBloc, FavoriteState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is FavoriteLoadInProgressState) {
                return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()));
              }
              if (state is FavoriteMovieLoadSuccess) {
                final info = state.favMovies;
                print("Favorites $info");
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Dismissible(
                          key: Key(info[index].title),
                          direction: DismissDirection.endToStart,
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
                        child: Text(
                  'Something went wrong!',
                  style: TextStyle(color: Colors.red),
                )));
              }
            },
          ),
        ],
      ),
    );
  }
}
