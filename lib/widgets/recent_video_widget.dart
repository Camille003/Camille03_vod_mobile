import 'package:flutter/material.dart';

class RecentItemWidget extends StatelessWidget {
  final String imageUrl;
  final String author;
  final String name;

  const RecentItemWidget({
    @required this.imageUrl,
    @required this.author,
    @required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${name[0].toUpperCase() + name.substring(1)}',
            softWrap: true,
            style: theme.textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            author,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
