import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:moviefinder/models/models.dart';
import 'package:moviefinder/widgets/moviedetails/rating_widget.dart';
import 'package:moviefinder/widgets/moviedetails/vertical_information.dart';

class MovieInfo extends StatefulWidget {
  final Movie current;
  MovieInfo({Key key, @required this.current}) : super(key: key);

  @override
  _MovieInfoState createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  String getGenres() {
    var genresList = [];
    for (var genre in widget.current.genres) genresList.add(genre.toString());
    return genresList.join(" ,");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(width: 32.0, height: 0.0),
                    Text(
                      widget.current.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    BlocBuilder<FavoriteBloc, FavoriteState>(
                        // ignore: missing_return
                        builder: (context, state) {
                      if (state is FavoriteMovieLoadSuccess) {
                        print("Success Favorites");
                        final info = state.favMovies;
                        print("Favorites $info");
                        return IconButton(
                            onPressed: () {
                              if (info.isNotEmpty) {
                                BlocProvider.of<FavoriteBloc>(context).add(
                                    FavoriteMovieDeleted(
                                        id: widget.current.id));
                              } else {
                                BlocProvider.of<FavoriteBloc>(context).add(
                                    FavoriteMovieAdded(movie: widget.current));
                              }
                            },
                            icon: Icon(
                              info.isNotEmpty
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 32.0,
                              color: Colors.red,
                            ));
                      }
                    }),
                  ]),
            ),
            Text(
              getGenres(),
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            RatingWidget(rating: widget.current.voteAverage),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              VerticalInformation(
                  label: "Duration", info: "${widget.current.runtime}"),
              VerticalInformation(
                  label: "Release", info: "${widget.current.releaseDate}"),
              VerticalInformation(
                  label: "Status", info: "${widget.current.status}"),
            ]),
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(widget.current.overview),
            )
          ],
        )));
  }
}
