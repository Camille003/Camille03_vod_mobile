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
    final theme = Theme.of(context);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Container(
         // height: 150,
         padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order number: $id',
                style: theme.textTheme.bodyText2,
              ),
              Text(
                'Account type: $accountType',
                style: theme.textTheme.bodyText2,
              ),
              Text(
                'Price: $price',
                style: theme.textTheme.bodyText2,
              ),
              Text(
                '${timeAgo.format(
                  dateTime,
                )}',
                style: theme.textTheme.bodyText2,
              ),
              Text(
                'Valid from: ${DateFormat.yMMMd().format(dateTime)} -  ${DateFormat.yMMMd().format(dateTime.add(Duration(days: 30)))}',
                style: theme.textTheme.bodyText2,
              ),
            ],
          ),
        ),
      
    );
  }
}
