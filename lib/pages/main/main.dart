import 'package:course_ripper/pages/main/screen/home.dart';
import 'package:course_ripper/pages/main/screen/map.dart';
import 'package:course_ripper/util/color/hex_code.dart';
import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex;

  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomeScreen(),
          MapScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: HexColor("#262626"),
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() {
            _selectedIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: [
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              // activeColor: Colors.indigo,
              activeColor: Colors.white),
          BottomNavyBarItem(
              icon: Icon(Icons.category),
              title: Text("storage"),
              // activeColor: Colors.deepPurpleAccent,
              activeColor: Colors.white),
        ],
      ),
    );
  }
}
