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
        width: double.infinity,
        height: 250,
        child: Row(
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    author,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
