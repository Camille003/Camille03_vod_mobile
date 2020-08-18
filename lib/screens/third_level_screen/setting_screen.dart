import 'package:flutter/material.dart';
import 'package:vidzone/helpers/payment_pop_up.dart';

//screens
import '../fifth_level_screen/account_screen.dart';
import '../fouth_level_screen/payments_screen.dart';
import '../fouth_level_screen/policy_screen.dart';
import '../fouth_level_screen/privacy_screen.dart';
import '../fouth_level_screen/request_screen.dart';

//widgets
import '../../widgets/setting_tile_widget.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = "settingPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: buildAppBar(
        context,
        'Settings',
      ),
      body: Column(
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
      ),
    );
  }
}
