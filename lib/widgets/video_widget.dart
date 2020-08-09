import 'package:flutter/material.dart';

class VideoTileWidget extends StatelessWidget {
   final String imageUrl;
  final String id;
  final int numberOfViews;
  final String name;
  final String creationDate;
  final int numberOfLikes;
  final String author;
  final int numberOfComments;
  final String description;
  final String streamingUrl;
  final Function addToPlayList;
  final Function download;

  const VideoTileWidget({@required this.imageUrl,@required  this.id,@required  this.numberOfViews,@required  this.name,@required  this.creationDate,@required  this.numberOfLikes,@required  this.author,@required  this.numberOfComments,@required  this.description,@required  this.streamingUrl,@required  this.addToPlayList,@required  this.download,}) ;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  (){},
          child: Container(
            height: 300,
        child: Card(
           margin: EdgeInsets.only(
          bottom: 15,
          top: 0,
        ),
        elevation: 1,
        child: Column(
            children: [
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 5,
                  bottom: 17,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Container(
                          child: PopupMenuButton(
                            onSelected: (String string) async {
                             

                              // if (string == "Downlod") {
                              //   print("Downloading !!!");
                              //   return;
                              // }

                        
                              // Scaffold.of(context).hideCurrentSnackBar();
                              // if (await VideoProvider()
                              //     .hasBeenSaved(userId, id)) {
                              //   Scaffold.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text('Already in collection'),
                              //     ),
                              //   );
                              // } else {
                              //   await VideoProvider()
                              //       .addToWatchLater(vidMap, userId, id);
                              //   Scaffold.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text('Added to colection'),
                              //     ),
                              //   );
                              // }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: ListTile(
                                  title: Text('Download'),
                                ),
                                value: 'Downlod',
                                enabled: true,
                                height: 30,
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  title: Text('Watch later'),
                                ),
                                value: 'Watch later',
                                enabled: true,
                                height: 30,
                              ),
                            ],
                            icon: IconButton(
                              icon: Icon(
                                Icons.more_vert,
                              ),
                              color: Colors.black87,
                              onPressed: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '$author',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$numberOfViews views',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '$numberOfLikes likes',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        Spacer(),
                        Text(
                          '${timeago.format(DateTime.parse(creationDate), locale: 'en_short')} Ago',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),,
        ),
      ),
    );
  }
}