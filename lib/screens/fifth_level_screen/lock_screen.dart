import 'package:flutter/material.dart';

//widget
import '../../widgets/main_button_widget.dart';

class LockScreen extends StatefulWidget {
  static const routeName = "lockScreen";
  final Function checkPassword;
  LockScreen(this.checkPassword);
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final _controller = TextEditingController();
  void onTap() {
    if (_controller.text.isEmpty) {
      return;
    }
    widget.checkPassword(_controller.text);
    _controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    return Container(
      width: double.infinity,
      height: media.size.height * 0.8,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.vpn_key,
              ),
              labelText: 'Enter your passwod',
            ),
          ),
          MainButtonWidget(
            color: theme.accentColor,
            onTap: onTap,
            textStyle: theme.textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
