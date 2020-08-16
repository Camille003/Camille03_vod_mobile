import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';

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

class MoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: movieProvider.fetchAndSetMovies(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child : WaitingWidget());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            showPopUpError(context);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CustomErrorWidget(),
              ),
            );
          }
          final movieData = movieProvider.movies;
          print(movieData);
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
            return ListView.builder(
              itemBuilder: (context, index) {
                return ChangeNotifierProvider<MediaProvider>.value(
                  value: movieData[index],
                  child: VideoTileWidget(),
                );
              },
              itemCount: movieProvider.movies.length,
            );
          }
        },
      ),
    );
  }
}
