import 'package:flutter/material.dart';
import 'package:vidzone/helpers/app_bar_helper.dart';
import '../../constants/privacy_constant.dart';

class PrivacyScreen extends StatelessWidget {
  static const routeName = "privacyScreen";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: buildAppBar(
        context,
        'Privacy',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                privacy,
                style: theme.textTheme.bodyText2,
              ),
            ),
            Container(
              child: Text(
                'Privacy Policy created with GetTerms.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
