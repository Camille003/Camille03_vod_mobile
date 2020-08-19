import 'package:flutter/material.dart';

class DownloadVideoScreen extends StatefulWidget {
  static const routeName = "downloadvideoScreen";
  @override
  _DownloadVideoScreenState createState() => _DownloadVideoScreenState();
}

class _DownloadVideoScreenState extends State<DownloadVideoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

/*

//flutter
import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';

import 'package:visibility_detector/visibility_detector.dart';
import 'package:path_provider/path_provider.dart';





//models
import '../../models/comments_model.dart';
import '../../models/media_model.dart';
import '../../models/download_model.dart';

//providers

import '../../providers/download_provider.dart';

//widgets

import '../../widgets/waiting_widget.dart';

//screens
import '../../screens/home_screen.dart';


class VideoScreen extends StatefulWidget with WidgetsBindingObserver {
  //from flutter downloader example
  // final TargetPlatform platform;

  static const routeName = "videoScreen";
  // final mediaId;
  // VideoScreen();

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {


  //for playing the media
  FlickMultiManager flickMultiManager;

  //model
  DonwloadModel _downloadModel

  //providers
  DownloadProvider _downloadProvider
  UserProvider _userProvider;

  @override
  void initState() {
  
    
    //multi manager
    flickMultiManager = FlickMultiManager();
    //media data

    Future.delayed(Duration.zero, () {
      _downloadProvider = Provider.of<DownloadProvider>(context, listen: false);
      _downloadProvider.fetchAndSetMediaContent().then(
            (value) => setState(() {
              
            
              flickManager = FlickManager(
                videoPlayerController: VideoPlayerController.network(
                    'https://res.cloudinary.com/dohp2afc4/video/upload/v1589451729/John_Wick_Official_Trailer__1__2014__-_Keanu_Reeves__Willem_Dafoe_Movie_HD_480p_lkzpys.mp4'),
              );
            }),
          );

     

     
     
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flickManager.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      key: _scaffoldKey,
      body: _mediaData == null
          ? Center(
              child: WaitingWidget(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //video player
                Container(
                  child: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    backgroundColor: Colors.black,
                    elevation: 0,
                    flexibleSpace: Container(
                      color: Colors.transparent,
                      height: 250,
                      width: double.infinity,
                      child: Center(
                        child: VisibilityDetector(
                          key: ObjectKey(flickManager),
                          onVisibilityChanged: (visibility) {
                            if (visibility.visibleFraction == 0 &&
                                this.mounted) {
                              flickManager.flickControlManager.autoPause();
                            } else if (visibility.visibleFraction == 1) {
                              flickManager.flickControlManager.autoResume();
                            }
                          },
                          child: Container(
                            child: FlickVideoPlayer(
                              
                              flickManager: flickManager,
                              flickVideoWithControls: FlickVideoWithControls(
                                controls: FlickPortraitControls(),
                              ),
                              flickVideoWithControlsFullscreen:
                                  FlickVideoWithControls(
                                controls: FlickLandscapeControls(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

*/
