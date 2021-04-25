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
  findMovieID(List<Movie> favorites) {
    for (Movie movie in favorites) {
      if (movie.id == widget.current.id) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Material(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(width: 32.0, height: 0.0),
                    Expanded(
                      child: Text(
                        widget.current.title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    BlocBuilder<FavoriteBloc, FavoriteState>(
                        // ignore: missing_return
                        builder: (context, state) {
                      if (state is FavoriteLoadInProgressState) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is FavoriteMovieLoadSuccess) {
                        final fav = state.favMovies;
                        return Card(
                            key: Key("FavoriteBtn"),
                            child: IconButton(
                                onPressed: () {
                                  if (findMovieID(fav)) {
                                    BlocProvider.of<FavoriteBloc>(context).add(
                                        FavoriteMovieDeleted(
                                            id: widget.current.id));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${widget.current.title} deleted from favorites")));
                                  } else {
                                    BlocProvider.of<FavoriteBloc>(context).add(
                                        FavoriteMovieAdded(
                                            movie: widget.current));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "${widget.current.title} added to favorites")));
                                  }
                                },
                                icon: Icon(
                                  findMovieID(fav)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 32.0,
                                  color: Colors.red,
                                )));
                      }
                    }),
                  ]),
            ),
            Text(
              widget.current.genresString,
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            RatingWidget(rating: widget.current.voteAverage),
            Row(children: [
              Expanded(
                child: VerticalInformation(
                    label: "Duration", info: "${widget.current.runtime}"),
              ),
              Expanded(
                child: VerticalInformation(
                    label: "Release", info: "${widget.current.releaseDate}"),
              ),
              Expanded(
                child: VerticalInformation(
                    label: "Status", info: "${widget.current.status}"),
              ),
            ]),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 15),
              child: Text(widget.current.overview),
            )
          ],
        )));
  }
}
