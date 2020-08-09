import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/models/media_model.dart';
import 'package:vidzone/widgets/no_content_widget.dart';
import 'package:vidzone/widgets/video_widget.dart';
import 'package:vidzone/widgets/waiting_widget.dart';
//providers
import '../../providers/movie_provider.dart';

class MoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: movieProvider.fetchAndSetMovies(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return WaitingWidget();
          } else if (snapshot.hasError) {
            //error widget
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
            return ListView.builder(
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider<MediaModel>.value(
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
