import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//third
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

//widgets
import './waiting_widget.dart';

//provider
import '../providers/media_provider.dart';

//screen
import '../screens/third_level_screen/video_screen.dart';

class ArchivedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaProvider = Provider.of<MediaProvider>(context, listen: false);
    final theme = Theme.of(
      context,
    );
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ChangeNotifierProvider.value(
              value: mediaProvider,
              child: VideoScreen(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                height: 100,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: mediaProvider.imageUrl,
                    placeholder: (context, url) => WaitingWidget(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.error,
                    ),
                  ),
                  // child: Image.network(
                  //   mediaProvider.imageUrl,
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${mediaProvider.name[0].toUpperCase() + mediaProvider.name.substring(1)}',
                      softWrap: true,
                      style: theme.textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      mediaProvider.author,
                      softWrap: true,
                      style: theme.textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat().format(mediaProvider.uploadDate),
                      softWrap: true,
                      style: theme.textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
