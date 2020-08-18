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
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              shape: CircleBorder(),
              child: Container(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(user.imageUrl),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  user.name,
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  user.email,
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  '${user.accountType == AccountType.Premium ? "Premium" : "Basic"}',
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  'Next payment ${DateFormat.yMMMd().format(user.nextPaymentDate)}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
