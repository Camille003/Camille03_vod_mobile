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
  String errorMessage = "";
  void onTap() {
    if (_controller.text.isEmpty) {
      return;
    }
    if (widget.checkPassword(_controller.text)) {
      _controller.text = '';
      return;
    } else {
      setState(() {
        errorMessage = "Invalid credentials";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.all(
        10,
      ),
      width: double.infinity,
      height: media.size.height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please authenticate yourself',
          ),
          TextFormField(
            textAlign: TextAlign.center,
            controller: _controller,
            decoration: InputDecoration(
              errorText: errorMessage,
              suffixIcon: Icon(
                Icons.vpn_key,
              ),
              labelText: 'Enter your passwod',
            ),
          ),
          SizedBox(
            height: 30,
          ),
          MainButtonWidget(
            label: 'Confirm',
            color: theme.accentColor,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              onTap();
            },
            textStyle: theme.textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
