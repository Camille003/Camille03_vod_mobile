import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:animated_list_view_scroll/animated_list_view_scroll.dart';

//helpers
import '../../helpers/error_pop_up_helper.dart';

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

class MoviesScreen extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(
      context,
      listen: false,
    );

    return Scaffold(
      key: _scaffoldKey,
      body: ConnectivityWidget(
        showOfflineBanner: true,
        offlineCallback: () {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                'Offline',
              ),
            ),
          );
        },
        onlineCallback: () {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                'Online',
              ),
            ),
          );
        },
        offlineBanner: OfflineWidget(),
        builder: (context, isOnline) => isOnline
            ? FutureBuilder(
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
                              child:
                                  ChangeNotifierProvider<MediaProvider>.value(
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
