import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:animated_list_view_scroll/animated_list_view_scroll.dart';
import 'package:connectivity_widget/connectivity_widget.dart';

//helpers
import '../../helpers/error_pop_up_helper.dart';
import '../../helpers/media_item_app_bar.dart';

//providers
import '../../providers/movie_provider.dart';

//models
import '../../providers/media_provider.dart';

//widgets
import '../../widgets/error_widget.dart';
import '../../widgets/no_content_widget.dart';
import '../../widgets/video_widget.dart';
import '../../widgets/waiting_widget.dart';
import '../../widgets/no_connection_widget.dart';
import '../../widgets/offline_widget.dart';
import '../../widgets/category_chip_widget.dart';

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOnline = true;

  List<CategoryChipWidget> _categories;
  List<MediaProvider> _allMovies = [];
  List<MediaProvider> _selectedMovies = [];

  void _selectMovies(String id) {
    if (_allMovies.isNotEmpty) {
      setState(() {
        _selectedMovies =
            _allMovies.where((movieData) => movieData.category == id).toList();
      });

      final chipIndex = _categories.indexWhere((categoryChip) {
        return categoryChip.id == id;
      });
      print(chipIndex);
      if (chipIndex != -1) {
        final selectedChip = _categories[chipIndex];
        final newChipArrays = [..._categories];
        final newChip = CategoryChipWidget(
          label: selectedChip.label,
          id: selectedChip.id,
          onTap: _selectMovies,
          color: Colors.black87,
        );

        _categories = newChipArrays.map((chip) {
          return CategoryChipWidget(
              label: chip.label, onTap: _selectMovies, id: chip.id);
        }).toList();

        setState(() {
          _categories[chipIndex] = newChip;
          print("Done");
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categories = [
      'Action',
      'Comedy',
      'Drama',
      'Fantasy',
      'Horror',
      'Mystery',
      'Romance',
      'Thriller',
      'Western',
    ]
        .map(
          (e) => CategoryChipWidget(
            label: e,
            id: e,
            onTap: _selectMovies,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: buildAppBarBottom(context, _categories),
      key: _scaffoldKey,
      body: ConnectivityWidget(
        showOfflineBanner: true,
        offlineCallback: () {
          setState(() {
            _isOnline = false;
          });
        },
        onlineCallback: () {
          setState(() {
            _isOnline = true;
          });
        },
        offlineBanner: OfflineWidget(),
        builder: (context, isOnline) => isOnline
            ? _selectedMovies.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider<MediaProvider>.value(
                        value: _selectedMovies[index],
                        child: VideoTileWidget(isOnline),
                      );
                    },
                    itemCount: _selectedMovies.length,
                  )
                : FutureBuilder(
                    future: movieProvider.fetchAndSetMovies(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: WaitingWidget());
                      } else if (snapshot.hasError) {
                        showPopUpError(context);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CustomErrorWidget(),
                          ),
                        );
                      }
                      final movieData = movieProvider.movies;

                      if (movieData.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: NoContentWidget(
                              'No movies avalaible. Stay tuned',
                            ),
                          ),
                        );
                      } else {
                        _allMovies = movieData;
                        return AnimatedListViewScroll(
                          itemCount: movieProvider.movies.length, //REQUIRED
                          itemHeight: 310,
                          animationOnReverse: true,
                          animationDuration: Duration(milliseconds: 200),
                          itemBuilder: (context, index) {
                            return AnimatedListViewItem(
                              key: GlobalKey(), //REQUIRED
                              index: index, //REQUIRED
                              animationBuilder: (context, index, controller) {
                                Animation<Offset> animation = Tween<Offset>(
                                  begin: Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(
                                  controller,
                                );

                                return SlideTransition(
                                  position: animation,
                                  child: ChangeNotifierProvider<
                                      MediaProvider>.value(
                                    value: movieData[index],
                                    child: VideoTileWidget(
                                      isOnline,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  )
            : NoConnectionWidget(),
      ),
    );
  }
}
