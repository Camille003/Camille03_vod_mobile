import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

Future<void> showPopUpError(BuildContext context) async {
  return CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    title: "Oops...",
    text: "Sorry, something went wrong",
  );
}
