import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/models/media_model.dart';
import 'package:vidzone/widgets/no_content_widget.dart';

//widgets
import '../../widgets/video_widget.dart';
import '../../widgets/waiting_widget.dart';

//providers
import '../../providers/trailer_provider.dart';

class TrailerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trailerProvider =
        Provider.of<TrailerProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: trailerProvider.fetchAndSetTrailers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return WaitingWidget();
          } else if (snapshot.hasError) {
            //error widget
          }

          final trailerData = trailerProvider.trailers;
          if (trailerData.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: NoContentWidget(
                  'No trailers avalaible. Stay tuned',
                ),
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ChangeNotifierProvider<MediaModel>.value(
                value: trailerData[index],
                child: VideoTileWidget(),
              );
            },
            itemCount: trailerProvider.trailers.length,
          );
        },
      ),
    );
  }
}
