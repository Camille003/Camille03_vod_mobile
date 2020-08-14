import 'package:flutter/material.dart';
import '../../widgets/setting_tile_widget.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = "settingPage";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).appBarTheme.textTheme.headline1,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SettingsTile(
              description: 'Manage your accounts personal details',
              descriptionIcon: Icons.person_outline,
              title: 'Account',
              destination: '',
            ),
          ),
          Expanded(
            child: SettingsTile(
              description: 'Chat out your concerns',
              descriptionIcon: Icons.chat_bubble_outline,
              title: 'Requests',
              destination: '',
            ),
          ),
          
          Expanded(
            child: SettingsTile(
              description: 'Switch accounts and get the best.',
              descriptionIcon: Icons.payment,
              title: 'Payments',
              destination: '',
            ),
          ),
          Expanded(
            child: SettingsTile(
              description: 'Find out what for and how your data is being used',
              descriptionIcon: Icons.priority_high,
              title: 'Privacy policy',
              destination: '',
            ),
          ),
          Expanded(
            child: SettingsTile(
              description: 'Find out the purpose aof vidzone and how to properly use it',
              descriptionIcon: Icons.priority_high,
              title: 'Terms of usage',
              destination: '',
            ),
          ),
        ],
      ),
    );
  }
}
