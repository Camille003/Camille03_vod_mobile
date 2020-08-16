import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';

//providers
import '../../providers/user_provider.dart';

//widgets
import '../../widgets/waiting_widget.dart';

import './account_detail_screen.dart';
import './lock_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isAuth = false;
  UserProvider _provider;
  bool _isLoading;

  void checkPassword(String entredPassword) {
    final password = _provider.user.password;
    if (password == entredPassword) {
      setState(() {
        _isAuth = true;
      });
      return;
    }
    return;
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _provider = Provider.of<UserProvider>(context);
    _provider.fetchAndSetUser().then(
          (value) => setState(
            () {
              _isLoading = true;
            },
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account',
          style: theme.appBarTheme.textTheme.headline1,
        ),
      ),
      body: _isLoading
          ? Center(
              child: WaitingWidget(),
            )
          : _isAuth
              ? LockScreen(
                  checkPassword,
                )
              : AccountDetailScreen(
                  _provider.user,
                ),
    );
  }
}
