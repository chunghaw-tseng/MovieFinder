import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';

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
                      return Container(
                        child: Text(info[index].title),
                      );
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
