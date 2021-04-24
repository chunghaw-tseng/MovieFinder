import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviefinder/views/moviedetails_view.dart';

class FavoriteItem extends StatelessWidget {
  final String title;
  final String genres;
  final String posterURL;
  final double voteAverage;
  final String releaseDate;
  final int movieID;
  const FavoriteItem(
      {Key key,
      this.title,
      this.genres,
      this.posterURL,
      this.voteAverage,
      this.movieID,
      this.releaseDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailsView(
                    title: title, posterURL: posterURL, id: movieID)),
          )
        },
        child: Card(
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: movieID,
                child: Container(
                  height: 150,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: 'https://image.tmdb.org/t/p/w300$posterURL',
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$title",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Color(0xffbda96b)),
                          Text("$voteAverage")
                        ],
                      ),
                      Text(
                        "$releaseDate",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Text("$genres"),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
