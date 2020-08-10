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
    return Container(
      height: 150,
      width: 150,
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
            ),
          ),
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
    );
  }
}
