import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/helpers/error_pop_up_helper.dart';
import 'package:vidzone/providers/media_provider.dart';
import 'package:vidzone/widgets/error_widget.dart';
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
            return Center(child : WaitingWidget());
          } else if (snapshot.hasError) {
             //showPopUpError(context);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CustomErrorWidget(),
              ),
            );
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
              return ChangeNotifierProvider<MediaProvider>.value(
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
