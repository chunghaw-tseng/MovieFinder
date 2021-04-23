import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/widgets/discover/movie_element.dart';

class MoviesGrid extends StatefulWidget {
  MoviesGrid({Key key}) : super(key: key);

  @override
  _MoviesGridState createState() => _MoviesGridState();
}

class _MoviesGridState extends State<MoviesGrid> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      // ignore: missing_return
      builder: (context, state) {
        print("In bloc builder");
        if (state is SearchLoadInProgressState || state is SearchInitialState) {
          return SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()));
        }
        if (state is MoviesLoadSuccess) {
          final movies = state.movies;
          print("Movie Loaded");
          return SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisExtent: 300.0,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => GridMovieElement(
                  result: movies[index],
                  isFav: false,
                  posterURL: movies[index].posterPath,
                  title: movies[index].title),
              childCount: state.totalMovies,
            ),
          );
        }
        if (state is SearchLoadFailureState) {
          return SliverFillRemaining(
              child: Center(
            child: Row(children: [
              Icon(
                Icons.adb_sharp,
                color: Colors.red,
              ),
              Text(
                'Oops! Something went wrong!',
                style: TextStyle(color: Colors.red),
              )
            ]),
          ));
        }
      },
    );
  }
}
