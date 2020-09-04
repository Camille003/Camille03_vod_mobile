import 'package:flutter/material.dart';

//widget
import '../widgets/category_chip_widget.dart';

PreferredSize buildAppBarBottom(
    BuildContext context, List<CategoryChipWidget> catObjects) {
  final theme = Theme.of(context);
  return PreferredSize(
    preferredSize: const Size.fromHeight(48.0),
    child: Theme(
      data: theme.copyWith(accentColor: Colors.white),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 0.5,
              color: Colors.grey[200],
            ),
          ),
        ),
        height: 48.0,
        alignment: Alignment.center,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 7),
          scrollDirection: Axis.horizontal,
          children: catObjects,
        ),
      ),
    ),
  );
}
