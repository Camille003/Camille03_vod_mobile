import 'package:flutter/material.dart';
import 'package:vidzone/widgets/svg_widget.dart';

class CustomErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 450,
      child: Column(
        children: [
          SvgWidget(
            'assets/images/error.svg',
          ),
          Text(
            'An error occured',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
    );
  }
}
