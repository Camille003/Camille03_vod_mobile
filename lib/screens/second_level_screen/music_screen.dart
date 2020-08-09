import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/models/media_model.dart';


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
            return WaitingWidget();
          } else if (snapshot.hasError) {
            //error widget
          }
          final musicData = musicProvider.musics;
          return ListView.builder(
            itemBuilder: (context, index) {
              return ChangeNotifierProvider<MediaModel>.value(value: musicData[index] , child : VideoTileWidget(),);
            },
            itemCount: musicProvider.musics.length,
          );
        },
      ),
    );
  }
}
