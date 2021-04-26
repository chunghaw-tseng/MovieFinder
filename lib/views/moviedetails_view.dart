import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moviefinder/widgets/moviedetails/movieInfo.dart';

class MovieDetailsView extends StatefulWidget {
  final String posterURL;
  final String title;
  final int id;
  MovieDetailsView({Key key, this.posterURL, this.title, this.id})
      : super(key: key);

  @override
  _MovieDetailsViewState createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InfoMovieBloc>(context)
        .add(InfoMovieRequested(id: widget.id));
    BlocProvider.of<FavoriteBloc>(context).add(FavoriteMoviesRequested());
  }

  // On loading A RenderFlex overflowed by 400 pixels on the right.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: widget.id,
        child: Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: true,
                expandedHeight: 500.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
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
                    imageUrl:
                        'https://image.tmdb.org/t/p/w300/${widget.posterURL}',
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
              ),
              BlocBuilder<InfoMovieBloc, InfoMovieState>(
                // ignore: missing_return
                builder: (context, state) {
                  if (state is InfoLoadInProgressState ||
                      state is InfoInitialState) {
                    return SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state is InfoMovieLoadSuccess) {
                    final info = state.movieInfo;
                    // Maybe this
                    return SliverToBoxAdapter(child: MovieInfo(current: info));
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
        ),
      ),
    );
  }
}
