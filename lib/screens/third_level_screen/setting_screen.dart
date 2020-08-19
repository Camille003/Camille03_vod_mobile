import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//helpers
import 'package:vidzone/helpers/app_bar_helper.dart';

//providers
import '../../providers/user_provider.dart';

//screens
import '../fouth_level_screen/account_screen.dart';
import '../fouth_level_screen/payments_screen.dart';
import '../fouth_level_screen/policy_screen.dart';
import '../fouth_level_screen/privacy_screen.dart';
import '../fouth_level_screen/request_screen.dart';
import '../fifth_level_screen/lock_screen.dart';

//widgets
import '../../widgets/setting_tile_widget.dart';
import '../../widgets/waiting_widget.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = "settingPage";

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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

  Widget buildSettings() {
    return Column(
      children: [
        Expanded(
          child: SettingsTile(
            description: 'Manage your accounts personal details',
            descriptionIcon: Icons.person_outline,
            title: 'Account',
            destination: AccountScreen.routeName,
          ),
        ),
        Expanded(
          child: SettingsTile(
            description: 'Chat out your concerns',
            descriptionIcon: Icons.chat_bubble_outline,
            title: 'Requests',
            destination: RequestScreen.routeName,
          ),
        ),
        Expanded(
          child: SettingsTile(
            description: 'Switch accounts and get the best.',
            descriptionIcon: Icons.payment,
            title: 'Payments',
            destination: PaymentScreen.routeName,
          ),
        ),
        Expanded(
          child: SettingsTile(
            description: 'Find out what for and how your data is being used',
            descriptionIcon: Icons.priority_high,
            title: 'Privacy policy',
            destination: PolicyScreen.routeName,
          ),
        ),
        Expanded(
          child: SettingsTile(
            description:
                'Find out the purpose aof vidzone and how to properly use it',
            descriptionIcon: Icons.priority_high,
            title: 'Terms of usage',
            destination: PrivacyScreen.routeName,
          ),
        ),
      ],
    );
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
      appBar: buildAppBar(
        context,
        'Settings',
      ),
      body: _isLoading
          ? Center(
              child: WaitingWidget(),
            )
          : !_isAuth
              ? LockScreen(
                  checkPassword,
                )
              : buildSettings(),
    );
  }
}
