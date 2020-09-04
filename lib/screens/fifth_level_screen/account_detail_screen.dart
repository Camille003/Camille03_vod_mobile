import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//enum types
import '../../emums/account_type_enum.dart';

//models
import '../../models/user_model.dart';

class AccountDetailScreen extends StatelessWidget {
  final UserModel user;
  AccountDetailScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            elevation: 5,
            shape: CircleBorder(),
            child: Container(
              height: 100,
              width: 100,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  user.imageUrl,
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                title: Text(
                  'Name: ${user.name}',
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                title: Text(
                  'Name: ${user.email}',
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                title: Text(
                  'Account: ${user.accountType == AccountType.Premium ? "Premium" : "Basic"}',
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                title: Text(
                  'Next payment due on: ${DateFormat.yMMMd().format(user.nextPaymentDate)}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
