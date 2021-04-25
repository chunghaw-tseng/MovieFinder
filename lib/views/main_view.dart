import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'favorites_view.dart';
import './discover_view.dart';

class MainView extends StatefulWidget {
  MainView({Key key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  List<Widget> _widgetOptions = [];
  Image _banner;

  @override
  void initState() {
    super.initState();
    _banner = Image.asset(
      "assets/images/banner.jpg",
      fit: BoxFit.cover,
    );
    _widgetOptions = [DiscoverView(), FavoritesView()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Preloading the banner as it sometimes takes time
    precacheImage(_banner.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Padding(
              padding: EdgeInsets.only(top: 20),
              child: _widgetOptions.elementAt(_selectedIndex)),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Color(0xfffaf9f5),
        color: Color(0xFFb8c0ca),
        buttonBackgroundColor: Color(0xFFb8c0ca),
        items: [
          Icon(
            Icons.sensor_door_rounded,
            size: 30,
            key: Key("DiscoverPage"),
            color: Color(0xfffaf9f5),
          ),
          Icon(
            Icons.star,
            size: 30,
            key: Key("FavoritePage"),
            color: Color(0xfffaf9f5),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
