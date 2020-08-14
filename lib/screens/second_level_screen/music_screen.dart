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
import '../../providers/music_provider.dart';

class MusicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final musicProvider = Provider.of<MusicProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: musicProvider.fetchAndSetMusic(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: WaitingWidget());
          } else if (snapshot.hasError) {
           // showPopUpError(context);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CustomErrorWidget(),
              ),
            );
          }
          final musicData = musicProvider.musics;
          if (musicData.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: NoContentWidget(
                  'No music avalaible. Stay tuned',
                ),
              ),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              return ChangeNotifierProvider<MediaProvider>.value(
                value: musicData[index],
                child: VideoTileWidget(),
              );
            },
            itemCount: musicProvider.musics.length,
          );
        },
      ),
    );
  }
}
