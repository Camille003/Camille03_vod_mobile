import 'package:flutter/material.dart';

class CategoryChipWidget extends StatelessWidget {
  CategoryChipWidget({
    Key key,
    @required this.label,
    this.color,
    @required this.id,
    @required this.onTap,
  }) : super(key: key);
  final String label;
  final Function onTap;
  final String id;
  Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(id);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3),
        child: Chip(
          backgroundColor: color != null ? Colors.grey[350] : Colors.grey[200],
          label: Text(
            label,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: color != null ? Colors.black87 : Colors.black54,
                ),
          ),
          key: ValueKey(
            label,
          ),
        ),
      ),
    );
  }
}
