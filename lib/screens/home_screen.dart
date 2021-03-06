import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';

//provider
import '../providers/user_provider.dart';

//screens
import './second_level_screen/movies_screen.dart';
import './second_level_screen/music_screen.dart';
import './second_level_screen/trailers_screen.dart';
import './second_level_screen/library_screen.dart';
import './second_level_screen/news_screen.dart';
import './third_level_screen/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  bool isLoading = false;
  void onTap(int pageIndex) {
    _pageController.jumpToPage(
      pageIndex,
    );
    setState(() {
      _pageIndex = pageIndex;
    });
  }

  List<Widget> _screens = [
    MoviesScreen(),
    MusicScreen(),
    TrailerScreen(),
    NewsScreen(),
    LibraryScreen()
  ];
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    super.initState();
    _pageController = PageController();
    Provider.of<UserProvider>(context, listen: false)
        .fetchAndSetUser()
        .then((value) => setState(() {
              isLoading = false;
           
            }));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final _tabBar = CupertinoTabBar(
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
            Icons.info,
          ),
        ),
        BottomNavigationBarItem(
          title: Text('Library'),
          icon: Icon(
            Icons.library_books,
          ),
        )
      ],
    );
   
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          'Vidzone',
          style: Theme.of(context).appBarTheme.textTheme.headline1.copyWith(
                fontSize: 22,
              ),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(
          //     Icons.search,
          //     color: Colors.black54,
          //   ),
          //   onPressed: null,
          // ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.black54,
            ),
            onPressed: () {},
          ),
          if (!isLoading)
            Consumer<UserProvider>(
              builder: (context, userProd, child) {
                return IconButton(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(
                      userProd.user.imageUrl,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      SettingScreen.routeName,
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _screens,
              onPageChanged: onTap,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          _tabBar
        ],
      ),
    );
  }
}
