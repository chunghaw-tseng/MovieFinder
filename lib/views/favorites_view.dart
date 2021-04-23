import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';

class FavoritesView extends StatefulWidget {
  FavoritesView({Key key}) : super(key: key);

  @override
  _FavoritesViewState createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    // BlocProvider.of<FavoriteBloc>(context).add(FavoriteMoviesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: 30.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Movie Finder"),
              )),
          // BlocBuilder<FavoriteBloc, FavoriteState>(
          //   // ignore: missing_return
          //   builder: (context, state) {
          //     if (state is FavoriteLoadInProgressState) {
          //       return SliverFillRemaining(
          //           child: Center(child: CircularProgressIndicator()));
          //     }
          //     if (state is FavoriteMovieLoadSuccess) {
          //       final info = state.responseData;
          //       print("Favorites $info");
          //       return SliverList(
          //         delegate: SliverChildBuilderDelegate(
          //           (BuildContext context, int index) {
          //             return Container(
          //               child: Text(info[index].title),
          //             );
          //           },
          //           childCount: info.length,
          //         ),
          //       );
          //     }
          //     if (state is InfoLoadFailureState) {
          //       return SliverFillRemaining(
          //           child: Center(
          //               child: Text(
          //         'Something went wrong!',
          //         style: TextStyle(color: Colors.red),
          //       )));
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
