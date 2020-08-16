import 'package:flutter/material.dart';

//enum types
import '../../emums/account_type_enum.dart';

//models
import '../../models/user_model.dart';

class AccountDetailScreen extends StatelessWidget {
  final UserModel user;
  AccountDetailScreen(this.user);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.imageUrl),
            child: Icon(
              Icons.person_outline,
            ),
          ),
        ),
        ListTile(
          title: Text(
            user.name,
          ),
        ),
        ListTile(
          title: Text(
            user.email,
          ),
        ),
        ListTile(
          title: Text(
              '${user.accountType == AccountType.Premium ? "Premium" : "Basic"}'),
        ),
        ListTile(
          title: Text('Next payment ${user.nextPayment}'),
        ),
      ],
    );
  }
}
