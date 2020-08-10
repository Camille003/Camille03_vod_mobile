import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:timeago/timeago.dart' as timeago;

//constants
import '../../constants/styles.dart';

//models
import '../../models/media_model.dart';
import '../../models/comments_model.dart';

//providers
import '../../providers/user_provider.dart';
import '../../providers/comment_provider.dart';

//widgets
import '../../widgets/comment_widget.dart';
import '../../widgets/waiting_widget.dart';

//screens
import '../../screens/home_screen.dart';

class VideoScreen extends StatefulWidget {
  static const routeName = "videoScreen";

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  //controller
  TextEditingController _commentController;

  //for playing the media
  String _mediaId;
  MediaModel _mediaModelProvider;
  MediaData _mediaData;

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

  @override
  void initState() {
    //text controller
    _commentController = TextEditingController();
    _scaffoldKey = GlobalKey<ScaffoldState>();

    //comment data
    _commentProvider = Provider.of<CommentsProvider>(context, listen: false);
    _commentProvider.fecthAndSetComments(_mediaId).then((value) {
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

    //media data
    _mediaModelProvider = Provider.of<MediaModel>(context, listen: false);
    Future.delayed(Duration.zero, () {
      _mediaId = ModalRoute.of(context).settings.arguments;
      _mediaModelProvider.fetchAndSetMediaContent().then(
            (value) => setState(() {
              _mediaData = _mediaModelProvider.media;
              _config['numberOfLikes'] = _mediaData.numberOfLikes;
            }),
          );
    });

    super.initState();
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
          : SingleChildScrollView(
              child: Column(
                children: [
                  //video player
                  Container(
                    child: AppBar(
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.of(context).popUntil(
                            ModalRoute.withName(HomeScreen.routeName),
                          );
                        },
                      ),
                      backgroundColor: Colors.black,
                      elevation: 0,
                      flexibleSpace: Container(
                        color: Colors.transparent,
                        height: 300,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            '${_mediaData.streamingUrl}',
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
                    padding: EdgeInsets.only(
                      left: 10,
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Spacer(),

                        Consumer<MediaModel>(
                          builder: (ctx, mediaModel, child) {
                            return FutureBuilder(
                              future: mediaModel.hasBeenLiked(userId),
                              builder: (ctx, snapshot) => snapshot.data
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
                                      badgeColor: theme.accentColor,
                                    ),
                            );
                          },
                        ),

                        //download
                        IconButton(
                          iconSize: 23,
                          icon: Icon(
                            Icons.file_download,
                            color: Colors.black54,
                          ),
                          onPressed: () {},
                        ),

                        //add to collection
                        Consumer<MediaModel>(
                          builder: (ctx, mediaModel, child) {
                            return FutureBuilder<bool>(
                              future: mediaModel.hasBeenSaved(userId),
                              builder: (ctx, snapshot) => snapshot.data
                                  ? Badge(
                                      badgeContent: Text('Save'),
                                      child: Icon(
                                        Icons.playlist_add,
                                      ),
                                      badgeColor: theme.accentColor,
                                    )
                                  : Badge(
                                      badgeContent: Text('Saved'),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.thumb_up,
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
                                      badgeColor: theme.accentColor,
                                    ),
                            );
                          },
                        ),

                        // description
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Description',
                                style: textTheme.bodyText2,
                              ),
                              Text(
                                _mediaData.description,
                                style: textTheme.bodyText1,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),

                        //comments block
                        Container(
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
                            height: 300,
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
                                            commentText:
                                                _commentsArray[index].text,
                                            username:
                                                _commentsArray[index].username,
                                            creationDate: _commentsArray[index]
                                                .creationDate,
                                          );
                                        },
                                        itemCount: _commentsArray.length,
                                      ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

                          String commentText = _commentController.text;
                          var comment = CommentModel(
                            id: DateTime.now().toString(),
                            creationDate: DateTime.now(),
                            text: commentText,
                            username: username,
                          );
                          await _commentProvider.createComment(
                            comment,
                            _mediaId,
                          );
                          _commentsArray.insert(0, comment);
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
