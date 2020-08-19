//dart
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

//flutter
import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:vidzone/models/download_model.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:expandable/expandable.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

//constants
import '../../constants/styles.dart';

//models
import '../../models/comments_model.dart';
import '../../models/media_model.dart';

//providers
import '../../providers/media_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/comment_provider.dart';
import '../../providers/download_provider.dart';

//widgets
import '../../widgets/comment_widget.dart';
import '../../widgets/waiting_widget.dart';

//screens
import '../../screens/home_screen.dart';

const debug = true;

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
//for downloads
  ReceivePort _port = ReceivePort();
  String _localPath;

  //timer
  Timer _additionTimer;

  //controller
  TextEditingController _commentController;

  //for playing the media
  FlickManager flickManager;
  MediaProvider _mediaModelProvider;
  MediaModel _mediaData;

  //providers
  CommentsProvider _commentProvider;
  UserProvider _userProvider;

  //user data
  String username;
  String userId;

  //scaffold
  GlobalKey<ScaffoldState> _scaffoldKey;

  //data
  List<CommentModel> _commentsArray;

  //dirty hacks
  Map<String, dynamic> _config = {
    'numerOfLikes': 0,
  };

  //for downloads
  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
    });
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  void initState() {
    //Timer to add videos to recent

    //for download
    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    //text controller
    _commentController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    //media data

    Future.delayed(Duration.zero, () {
      _mediaModelProvider = Provider.of<MediaProvider>(context, listen: false);
      _mediaModelProvider.fetchAndSetMediaContent().then(
            (value) => setState(() {
              _mediaData = _mediaModelProvider.media;
              _config['numberOfLikes'] = _mediaData.numberOfLikes;
              flickManager = FlickManager(
                videoPlayerController: VideoPlayerController.network(
                    'https://res.cloudinary.com/dohp2afc4/video/upload/v1589451729/John_Wick_Official_Trailer__1__2014__-_Keanu_Reeves__Willem_Dafoe_Movie_HD_480p_lkzpys.mp4'),
              );
            }),
          );

      //comment data
      _commentProvider = Provider.of<CommentsProvider>(context, listen: false);
      _commentProvider
          .fecthAndSetComments(_mediaModelProvider.id)
          .then((value) {
        setState(() {
          _commentsArray = _commentProvider.comments;
        });
      });

      //user data
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      _userProvider.fetchAndSetUser().then((value) {
        username = _userProvider.user.name;
        userId = _userProvider.user.id;
      });

      //set up timer to fire up after 10 seconds
      _additionTimer = Timer(Duration(seconds: 10), () {
        _mediaModelProvider.addView(userId);
        _mediaModelProvider.watched(userId);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flickManager.dispose();
    _commentController.dispose();
    IsolateNameServer.removePortNameMapping('downloader_send_port');

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

                //show data box
                Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                  ),
                  child: Text(
                    '${_mediaData.name} - ${_mediaData.author}',
                    style: textTheme.bodyText2,
                  ),
                ),

                //show extra info
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        '${_mediaData.numberOfViews} views',
                        style: textTheme.bodyText2,
                      ),
                      Spacer(),
                      Text(
                        '${timeago.format(_mediaData.uploadDate, locale: 'en_short')} ago',
                        style: textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),

                //likes download save
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Spacer(),

                      Consumer<MediaProvider>(
                        builder: (ctx, mediaModel, child) {
                          return FutureBuilder(
                            future: mediaModel.hasBeenLiked(userId),
                            builder: (ctx, snapshot) => snapshot
                                        .connectionState ==
                                    ConnectionState.none
                                ? WaitingWidget()
                                : snapshot.data == true
                                    ? Badge(
                                        badgeContent:
                                            Text('${mediaModel.numberOfLikes}'),
                                        child: Icon(
                                          Icons.thumb_up,
                                        ),
                                        badgeColor: theme.accentColor,
                                      )
                                    : Badge(
                                        badgeContent:
                                            Text('${mediaModel.numberOfLikes}'),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.thumb_up,
                                          ),
                                          onPressed: () async {
                                            await mediaModel.likeVideo(
                                              userId,
                                            );

                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Liked',
                                                  style: TextStyle(
                                                    color: theme.accentColor,
                                                  ),
                                                ),
                                                backgroundColor: Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),

                      //download
                      Consumer<DownloadProvider>(
                        builder: (ctx, downloadData, child) {
                          return FutureBuilder(
                            future: downloadData.hasBeenDownloaded(
                              _mediaData.id,
                            ),
                            builder: (ctx, snapshot) => snapshot
                                        .connectionState ==
                                    ConnectionState.none
                                ? WaitingWidget()
                                : snapshot.data == true
                                    ? Badge(
                                        child: Icon(
                                          Icons.file_download,
                                        ),
                                        badgeColor: theme.accentColor,
                                      )
                                    : Badge(
                                        showBadge: false,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.file_download,
                                          ),
                                          onPressed: () async {
                                            print("Downloading");

                                            PermissionStatus permission;
                                            //1 check if we have permisions
                                            final isGranted = await Permission
                                                .storage.isGranted;

                                            //2 if we do not , request
                                            if (!isGranted) {
                                              permission = await Permission
                                                  .storage
                                                  .request();
                                            }

                                            //3 if not given terminate
                                            if (permission.isDenied) {
                                              return;
                                            }
                                            //5 if we do download
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Downloading',
                                                  style: TextStyle(
                                                    color: theme.accentColor,
                                                  ),
                                                ),
                                                backgroundColor: Colors.black,
                                              ),
                                            );
                                            print("Local path");
                                            _localPath =
                                                (await _findLocalPath()) +
                                                    Platform.pathSeparator +
                                                    'Download';

                                            final savedDir =
                                                Directory(_localPath);
                                            bool hasExisted =
                                                await savedDir.exists();
                                            if (!hasExisted) {
                                              savedDir.create();
                                            }

                                            await FlutterDownloader.enqueue(
                                              fileName:
                                                  _mediaData.name + ".mp4",
                                              url:
                                                  'https://res.cloudinary.com/dohp2afc4/video/upload/v1589451729/John_Wick_Official_Trailer__1__2014__-_Keanu_Reeves__Willem_Dafoe_Movie_HD_480p_lkzpys.mp4',
                                              savedDir: _localPath,
                                              showNotification: true,
                                              openFileFromNotification: true,
                                            );

                                            // 6 add to document database

                                            await downloadData
                                                .download(DownloadModel(
                                              id: _mediaData.id,
                                              name: _mediaData.name,
                                              imageUrl: '',
                                              author: _mediaData.author,
                                              downloadPath: savedDir.path +
                                                  "/" +
                                                  _mediaData.name +
                                                  ".mp4",
                                            ));
                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Download Complete',
                                                  style: TextStyle(
                                                    color: theme.accentColor,
                                                  ),
                                                ),
                                                backgroundColor: Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          );
                        },
                      ),
                      //

                      SizedBox(
                        width: 15,
                      ),

                      //       //add to collection
                      Consumer<MediaProvider>(
                        builder: (ctx, mediaModel, child) {
                          return FutureBuilder<bool>(
                            future: mediaModel.hasBeenSaved(userId),
                            builder: (ctx, snapshot) => snapshot
                                        .connectionState ==
                                    ConnectionState.none
                                ? WaitingWidget()
                                : snapshot.data == true
                                    ? Badge(
                                        showBadge: false,
                                        child: Icon(
                                          Icons.library_add,
                                        ),
                                        badgeColor: theme.accentColor,
                                      )
                                    : Badge(
                                        showBadge: false,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.library_add,
                                          ),
                                          onPressed: () async {
                                            await mediaModel.addToWatchLater(
                                              userId,
                                            );

                                            _scaffoldKey.currentState
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Saved',
                                                  style: TextStyle(
                                                    color: theme.accentColor,
                                                  ),
                                                ),
                                                backgroundColor: Colors.black,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // description

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ExpandablePanel(
                    theme: ExpandableThemeData(
                        useInkWell: true, iconPadding: EdgeInsets.all(0)),
                    header: Container(
                      padding: EdgeInsets.all(0),
                      margin: EdgeInsets.all(0),
                      child: Text(
                        'Description',
                        style: textTheme.bodyText2,
                      ),
                    ),
                    collapsed: Text(
                      _mediaData.description.substring(0, 30) + "...",
                      softWrap: true,
                      style: textTheme.bodyText1,
                    ),
                    expanded: Text(
                      _mediaData.description,
                      style: textTheme.bodyText1,
                      softWrap: true,
                    ),
                  ),
                ),

                //comments block
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(
                        'Comments',
                        style: textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    //     height: 300,
                    child: _commentsArray == null
                        ? Text(
                            'Loading',
                            style: textTheme.bodyText2,
                          )
                        : _commentsArray.isEmpty
                            ? Text(
                                'Be the first to comment',
                                style: textTheme.bodyText1,
                              )
                            : ListView.builder(
                                itemBuilder: (context, index) {
                                  return CommentWidget(
                                    commentText: _commentsArray[index].text,
                                    username: _commentsArray[index].username,
                                    creationDate:
                                        _commentsArray[index].creationDate,
                                  );
                                },
                                itemCount: _commentsArray.length,
                              ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: theme.accentColor,
        backgroundColor: theme.primaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          maxLines: 4,
                          minLines: 2,
                          keyboardType: TextInputType.multiline,
                          controller: _commentController,
                          // textInputAction: TextInputAction.done,
                          decoration: basicInputStyle.copyWith(
                            labelText: 'Add a comment',
                            labelStyle: textTheme.bodyText2,
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.accentColor,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: theme.accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                        ),
                        onPressed: () async {
                          if (_commentController.text.trim().isEmpty) {
                            return;
                          }
                          FocusScope.of(context).requestFocus(
                            FocusNode(),
                          );
                          String commentText = _commentController.text;
                          var comment = CommentModel(
                            id: DateTime.now().toString(),
                            creationDate: DateTime.now(),
                            text: commentText,
                            username: username,
                          );
                          await _commentProvider.createComment(
                            comment,
                            _mediaModelProvider.id,
                          );
                          setState(() {
                            _commentsArray.insert(0, comment);
                          });

                          _commentController.text = '';

                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.chat_bubble,
        ),
      ),
    );
  }
}

//Former desc
// Container(
//   // height: 150,
//   padding: EdgeInsets.symmetric(
//     horizontal: 10,
//     vertical: 5,
//   ),
//   child: Column(
//     mainAxisSize: MainAxisSize.min,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Text(
//         'Description',
//         style: textTheme.bodyText2,
//       ),
//       Text(
//         _mediaData.description,
//         style: textTheme.bodyText1,
//         softWrap: true,
//       ),
//     ],
//   ),
// ),
