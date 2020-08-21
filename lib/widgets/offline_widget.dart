
import 'package:flutter/material.dart';


class OfflineWidget extends StatelessWidget {
  const OfflineWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
       height:20,
       width: double.infinity,
      color: Colors.grey,
      child: Text(
        'Offline',
        textAlign: TextAlign.center,
      ),
      
    );
  }
}
