import 'package:flutter/material.dart';

//third party
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeAgo;

//enum
import '../emums/account_type_enum.dart';

class PaymentWidget extends StatelessWidget {
  final String id;
  final double price;
  final AccountType accountType;
  final DateTime dateTime;

  const PaymentWidget({
    @required this.id,
    @required this.price,
    @required this.accountType,
    @required this.dateTime,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Order number: $id',
          ),
          Text(
            'Account type: $accountType',
          ),
          Text(
            'Price: $accountType',
          ),
          Text(
            timeAgo.format(
              dateTime,
            ),
          ),
          Text(
            'Valid from: ${DateFormat.yMMMd().format(dateTime)} -  ${DateFormat.yMMMd(dateTime.add(Duration(days: 30)))}',
          ),
        ],
      ),
    );
  }
}
