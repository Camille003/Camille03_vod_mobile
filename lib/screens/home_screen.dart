import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//provider
import '../providers/user_provider.dart';

//screens
import './movies_screen.dart';
import './music_screen.dart';
import './trailers_screen.dart';
import './library_screen.dart';
import './news_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  void onTap(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _screens = [
    MoviesScreen(),
    MusiScreen(),
    TrailersScreen(),
    NewsScreen(),
    LibraryScreen()
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final userProd = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _screens,
                onPageChanged: onTap,
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            CupertinoTabBar(
              activeColor: Theme.of(context).accentColor,
              currentIndex: _pageIndex,
              onTap: onTap,
              iconSize: 20,
              items: [
                BottomNavigationBarItem(
                  title: Text('Movies'),
                  icon: Icon(
                    Icons.movie,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text('Music'),
                  icon: Icon(
                    Icons.music_video,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text('Trailer'),
                  icon: const Icon(
                    Icons.explore,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text('News'),
                  icon: Icon(
                    Icons.new_releases,
                  ),
                ),
                BottomNavigationBarItem(
                  title: Text('Library'),
                  icon: Icon(
                    Icons.library_books,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
