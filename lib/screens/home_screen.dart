import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidzone/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "homeScreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final userProd = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Center(
        child: Text(
          'Home screen',
        ),
      ),
    );
  }
}
