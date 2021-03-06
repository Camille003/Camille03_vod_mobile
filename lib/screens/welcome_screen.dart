

import 'package:flutter/material.dart';


//widgets
import '../widgets/svg_widget.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = "welcomeScreen";
  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
   
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
               SizedBox(
                height: screenHeight * 0.02,
              ),
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
             
            ],
          ),
        ),
      ),
    );
  }
}
