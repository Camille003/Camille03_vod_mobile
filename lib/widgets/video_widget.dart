import 'package:flutter/material.dart';

//third party
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

//model
import '../models/media_model.dart';

class VideoTileWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<MediaModel>(context, listen: false);
    return GestureDetector(
      onTap: () {},
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
                    mediaProvider.imageUrl,
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
                    Text(
                      mediaProvider.name,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          mediaProvider.author,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${mediaProvider.numberOfViews} views',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${mediaProvider.numberOfLikes} likes',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        Spacer(),
                        Text(
                          '${timeago.format(mediaProvider.uploadDate, locale: 'en_short')} Ago',
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
          ),
        ),
      ),
    );
  }
}
