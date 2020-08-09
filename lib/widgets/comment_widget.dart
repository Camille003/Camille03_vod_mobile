import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentWidget extends StatelessWidget {
  final String username;
  final DateTime creationDate;
  final String commentText;

  const CommentWidget({
    Key key,
    @required this.username,
    @required this.creationDate,
    @required this.commentText,
  }) ;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5,
      ),
      height: 75,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$username',
                style: theme.textTheme.bodyText2,
              ),
              Text(
                '${timeago.format(creationDate, locale: 'en')}',
                style: theme.textTheme.bodyText2,
              ),
            ],
          ),
          SizedBox(
            height: 2,
          ),
          Expanded(
            child: Text(
              '$commentText',
              style: theme.textTheme.bodyText2,
              softWrap: true,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Divider(
            color: Colors.black,
            height: 1,
          ),
        ],
      ),
    );
  }
}
