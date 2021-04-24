import 'package:flutter/material.dart';
import 'package:moviefinder/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviefinder/repository/repositories.dart';
import 'package:moviefinder/widgets/discover/movies_grid.dart';

class DiscoverView extends StatefulWidget {
  final Image bannerImg;
  DiscoverView({Key key, this.bannerImg}) : super(key: key);

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
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
                title: Text("Movie Finder"), background: widget.bannerImg)),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          sliver: SliverPersistentHeader(
            pinned: true,
            delegate: _SearchBarDelegate(
              Card(
                child: TextField(
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
  _SearchBarDelegate(this._searchBar);

  final Widget _searchBar;

  @override
  double get minExtent => 55;
  @override
  double get maxExtent => 55;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.transparent,
      child: _searchBar,
    );
  }

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return false;
  }
}
