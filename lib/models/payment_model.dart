import 'package:flutter/foundation.dart';
import '../emums/account_type_enum.dart';

class PaymentModel {
  final String id;
  final String customerName;
  final String customerId;
  final DateTime creationDate;
  final double price;
  final AccountType accountType;

  const PaymentModel({
    @required this.id,
    @required this.creationDate,
    @required this.customerId,
    @required this.customerName,
    @required this.price,
    @required this.accountType,
  });

  PaymentModel.fromFireBaseDocument(Map<String, dynamic> snapshot)
      : id = snapshot['id'],
        customerId = snapshot['customerId'],
        customerName = snapshot['customerName'],
        creationDate = DateTime.tryParse(snapshot['creationDate']),
        price = snapshot['price'],
        accountType = (snapshot['accountType'] == "FREE")
            ? AccountType.Free
            : (snapshot['accountType'] == "BASIC")
                ? AccountType.Basic
                : AccountType.Premium;

  Map<String, dynamic> toFireBaseDocument() {
    return {
      'id': id,
      'customerName': customerName,
      'customerId': customerId,
      'creationDate': creationDate.toIso8601String(),
      'price': price.toStringAsFixed(2),
      'accountType': (accountType == AccountType.Free)
          ? "FREE"
          : (accountType == AccountType.Basic) ? "BASIC" : "PREMIUM",
    };
  }
}
