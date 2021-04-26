import 'package:flutter/material.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/widgets/discover/movies_grid.dart';

class DiscoverView extends StatefulWidget {
  DiscoverView({Key key}) : super(key: key);

  @override
  _DiscoverViewState createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  TextEditingController _textController;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    final nextPageThreshold = 300.0 * 7;
    double _currentThreshold = nextPageThreshold;

    // Loads 20 items every single time
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _currentThreshold) {
        _currentThreshold += nextPageThreshold;
        BlocProvider.of<MoviesBloc>(context)
            .add(NextPageRequested(query: _textController.text));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
            expandedHeight: 80.0,
            flexibleSpace: FlexibleSpaceBar(
                title: Text("Movie Finder", key: Key("Title")),
                background: Image.asset(
                  "assets/images/banner.jpg",
                  fit: BoxFit.cover,
                ))),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          sliver: SliverPersistentHeader(
            floating: true,
            pinned: true,
            delegate: _SearchBarDelegate(
              searchBar: Card(
                child: TextField(
                  key: Key("DiscoverTextField"),
                  controller: _textController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Avengers',
                  ),
                  onSubmitted: (value) {
                    _textController.text = value;
                    FocusScope.of(context).unfocus();
                    BlocProvider.of<MoviesBloc>(context)
                        .add(MoviesRequested(query: _textController.text));
                  },
                ),
              ),
            ),
          ),
        ),
        MoviesGrid(),
      ],
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget searchBar;
  _SearchBarDelegate({this.searchBar});

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(top: 15),
        child: searchBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return false;
  }
}
