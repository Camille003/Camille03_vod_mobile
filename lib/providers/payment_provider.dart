import 'package:flutter/foundation.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//models
import '../models/payment_model.dart';

class PaymentProvider with ChangeNotifier {
  final _fireStore = Firestore.instance.collection("payments");
  String _userId;

  List<PaymentModel> _payments = [];
  List<PaymentModel> get payments {
    return [..._payments].reversed.toList();
  }

  PaymentProvider(this._userId);

  void update(String id) {
    this._userId = id;
  }

  Future<void> fetchandSetPayment() async {
    try {
      final paymentsArray = [];
      final querySnapShot = await _fireStore
          .where("customerId", isEqualTo: _userId)
          .getDocuments();
      if (querySnapShot.documents.isNotEmpty) {
        querySnapShot.documents.forEach((snapShot) {
          paymentsArray.add(
            PaymentModel.fromFireBaseDocument(
              snapShot.data,
            ),
          );
        });
      }
      _payments = [...paymentsArray];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> makePayment(Map<String, dynamic> paymentData) async {
    try {
      final paymentRef = _fireStore.document();
      final id = paymentRef.documentID;

      final payment = PaymentModel(
        id: id,
        creationDate: paymentData['creationDate'],
        customerId: _userId,
        customerName: paymentData['customerName'],
        price: paymentData['price'],
        accountType: paymentData['accountType'],
      );
      await paymentRef.setData(
        payment.toFireBaseDocument(),
      );

      _payments.add(payment);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
