import 'package:flutter/material.dart';

//screen
import '../screens/third_level_screen/downloads_screen.dart';

//widget
import './svg_widget.dart';

class NoConnectionWidget extends StatelessWidget {
  // const NoConnectionWidget({

  // });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SvgWidget(
            "assets/images/no_connection.svg",
          ),
          Text(
            'Ooops seems you are not connected to the internet',
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Visit your downloads',
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 200,
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  DownloadScreen.routeName,
                );
              },
              child: Text(
                'Donwloads',
                style: theme.textTheme.bodyText2.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
