import 'package:flutter/material.dart';
import './svg_widget.dart';

class NoContentWidget extends StatelessWidget {
  final String label;
  const NoContentWidget(this.label);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 459,
      child: Column(
        children: [
          SvgWidget(
            'assets/images/no_data.svg',
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
