import 'package:flutter/material.dart';
import 'package:moviefinder/models/models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moviefinder/views/moviedetails_view.dart';

class GridMovieElement extends StatelessWidget {
  final Results result;
  final String posterURL;
  final String title;
  final bool isFav;

  const GridMovieElement(
      {Key key,
      @required this.posterURL,
      @required this.title,
      this.isFav,
      this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailsView(
                    title: title, posterURL: posterURL, id: result.id)),
          );
        },
        child: Card(
            child: Stack(
          children: <Widget>[
            Hero(
              tag: result.id,
              child: Center(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: 'https://image.tmdb.org/t/p/w300/$posterURL',
                      errorWidget: (context, url, error) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            Text("No poster to load")
                          ]),
                    )),
              ),
            ),
            // Vote average stars
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                  width: 60,
                  child: Card(
                    elevation: 5,
                    color: Color(0xffbda96b),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        Text(
                          "${this.result.voteAverage}",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )));
  }
}
