import 'package:animated_list_view_scroll/animated_list_view_scroll.dart';
import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';


import 'package:vidzone/helpers/error_pop_up_helper.dart';



//widgets
import '../../widgets/video_widget.dart';
import '../../widgets/waiting_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/no_content_widget.dart';

//providers
import '../../providers/music_provider.dart';
import '../../providers/media_provider.dart';

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
           showPopUpError(context);
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

          return   AnimatedListViewScroll(
          
              itemCount: musicProvider.musics.length, //REQUIRED
              itemHeight: 300,
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
                      child: ChangeNotifierProvider<MediaProvider>.value(
                        value: musicData[index],
                        child: VideoTileWidget(),
                      ),
                    );
                  },
                );
              },
            );
          // return ListView.builder(
          //   itemBuilder: (context, index) {
          //     return ChangeNotifierProvider<MediaProvider>.value(
          //       value: musicData[index],
          //       child: VideoTileWidget(),
          //     );
          //   },
          //   itemCount: musicProvider.musics.length,
          // );
        },
      ),
    );
  }
}
