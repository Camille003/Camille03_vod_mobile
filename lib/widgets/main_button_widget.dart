import 'package:flutter/material.dart';

class MainButtonWidget extends StatelessWidget {
  const MainButtonWidget({
    Key key,
    @required this.color,
    @required this.onTap,
    @required this.textStyle,
    this.icon,
    this.label,
  }) : super(key: key);
  final Color color;
  final Function onTap;
  final IconData icon;
  final String label;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity * 0.7,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: color,
        radius: 300,
        child: icon == null
            ? Center(
                child: Text(
                  label,
                  style: textStyle,
                ),
              )
            : Icon(
                icon,
                color: Colors.black,
                size: 23,
              ),
      ),
    );
  }
}
