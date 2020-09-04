import 'package:flutter/material.dart';
import 'package:vidzone/helpers/app_bar_helper.dart';

import '../../constants/policy_constant.dart';

class PolicyScreen extends StatelessWidget {
  static const routeName = "policyScreen";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: buildAppBar(
        context,
        'Policy',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                terms_of_use,
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
