import 'package:flutter/material.dart';

//screen
import '../screens/third_level_screen/video_screen.dart';

class ArchivedWidget extends StatelessWidget {
  final String author;
  final String id;
  final String name;
  final String imageUrl;
  const ArchivedWidget({
    @required this.id,
    @required this.author,
    @required this.name,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          VideoScreen.routeName,
        );
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  name,
                 softWrap: true,
                ),
                Text(
                  author,
                  softWrap: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
