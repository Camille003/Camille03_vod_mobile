import 'package:flutter/material.dart';

//third
import 'package:intl/intl.dart';

//screen
import '../screens/fouth_level_screen/downloads_video_screen.dart';

class DownloadWidget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final DateTime downloadDate;
  final String id;

  final String author;
  const DownloadWidget({
    @required this.id,
    @required this.author,
    @required this.imageUrl,
    @required this.downloadDate,
    @required this.name,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          DownloadVideoScreen.routeName,
          arguments: id,
        );
      },
      child: Container(
        decoration: BoxDecoration(),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 100,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name[0].toUpperCase() +name.substring(1)}',
                      softWrap: true,
                      style: theme.textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      author,
                      softWrap: true,
                      style: theme.textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat().format(
                        downloadDate,
                      ),
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
