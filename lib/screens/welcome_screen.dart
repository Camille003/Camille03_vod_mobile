import 'package:flutter/material.dart';
import 'package:vidzone/screens/sign_up.dart';

//screen
import '../screens/login_screen.dart';

//widgets
import '../widgets/main_button_widget.dart';
import '../widgets/svg_widget.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = "welcomeScreen";
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final secColor = theme.accentColor;
    final textTheme = theme.textTheme;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(
            screenHeight * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Welcome to Vidzone",
                style: textTheme.headline1,
              ),
              SvgWidget(
                "assets/images/welcome.svg",
                height: screenHeight * 0.6,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              MainButtonWidget(
                textStyle: textTheme.headline1,
                color: secColor,
                label: "SIGN IN",
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    LoginScreen.routeName,
                  );
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              MainButtonWidget(
                label: "SIGN UP",
                color: secColor,
                textStyle: textTheme.headline1,
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    SigUpScreen.routeName,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
