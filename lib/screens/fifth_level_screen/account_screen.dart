import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';


//providers
import '../../providers/user_provider.dart';

//widgets
import '../../widgets/waiting_widget.dart';

//screens
import './account_detail_screen.dart';
import './lock_screen.dart';

//helpers
import '../../helpers/payment_pop_up.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = "accountScreen";
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isAuth = false;
  UserProvider _provider;
  bool _isLoading;

  bool checkPassword(String entredPassword) {
    final password = _provider.user.password;
    if (password == entredPassword) {
      setState(() {
        _isAuth = true;
      });
      return true;
    }
    return false;
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _provider = Provider.of<UserProvider>(context, listen: false);
    _provider.fetchAndSetUser().then(
          (value) => setState(
            () {
              _isLoading = false;
            },
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: buildAppBar(context,"Account" ,center :true),
      body: _isLoading
          ? Center(
              child: WaitingWidget(),
            )
          : !_isAuth
              ? LockScreen(
                  checkPassword,
                )
              : AccountDetailScreen(
                  _provider.user,
                ),
    );
  }
}
