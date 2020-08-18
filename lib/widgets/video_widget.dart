import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

//third party
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';
import 'package:vidzone/widgets/waiting_widget.dart';

//model
import '../providers/media_provider.dart';

//screen
import './../screens/third_level_screen/video_screen.dart';

class VideoTileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final platform = Theme.of(context).platform;
    final mediaProvider = Provider.of<MediaProvider>(
      context,
      listen: false,
    );
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: false,
            builder: (ctx) => ChangeNotifierProvider.value(
              value: mediaProvider,
              child: VideoScreen(),
            ),
          ),
        );
      },
      child: Container(
        height: 300,
        child: Card(
          margin: EdgeInsets.only(
            bottom: 0,
            top: 0,
          ),
          elevation: 1,
          child: Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                flex: 2,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: mediaProvider.imageUrl,
                    placeholder: (context, url) => WaitingWidget(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                // child: Image.network(
                //   mediaProvider.imageUrl,
                //   fit: BoxFit.fill,
                //   //loadingBuilder: (context, widget, chunck) => WaitingWidget(),
                // ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          '${timeago.format(mediaProvider.uploadDate, locale: 'en_short', allowFromNow: false)} Ago',
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
