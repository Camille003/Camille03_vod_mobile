//flutter
import 'package:flutter/material.dart';

//helpers
import '../helpers/color_hex.dart';

class InputWidget extends StatelessWidget {
  final Function onSaved;
  final Function validator;
  final bool showText;
  final FocusNode focusNode;
  final TextEditingController controller;
  final Function onSubmitted;
  final String labelText;
  final Color color;
  final InputDecoration styles;
  final TextInputAction action;

  const InputWidget({
    Key key,
    @required this.onSaved,
    @required this.validator,
    @required this.showText,
    @required this.focusNode,
     this.controller,
    @required this.onSubmitted,
    @required this.labelText,
    @required this.color,
    @required this.styles,
    @required this.action,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 15,
      ),
      width: double.infinity * 0.7,
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        keyboardType:
            !showText ? TextInputType.emailAddress : TextInputType.text,
        textInputAction: action,
        cursorColor: HexColor('#CC5500'),
        focusNode: focusNode,
        obscureText: showText,
        onFieldSubmitted: onSubmitted,
        controller: controller,
        decoration: styles.copyWith(
          labelText: labelText,
          labelStyle: TextStyle(
            color: color,
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: color,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
