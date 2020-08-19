import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context, String title, { center = true}) {
  return AppBar(
    centerTitle: center,
    title: Text(
      title,
      style: Theme.of(context).appBarTheme.textTheme.headline1,
    ),
  );
}
