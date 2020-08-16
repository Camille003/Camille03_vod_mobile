import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/request_model.dart';

class RequestProvider with ChangeNotifier {
  String _userId;
  final _firestore = Firestore.instance.collection("requests");

  String get userId {
    return _userId;
  }

  Stream<QuerySnapshot> fetchData()  {
    try {
      return  _firestore.where("customerId" , isEqualTo:  "").snapshots();
    } catch (e) {
      throw e;
    }
  }

  Future<void> createRequest(Map<String, dynamic> requestData) async {
    try {
      final requestRef = _firestore.document();

      await requestRef.setData(
        RequestModel(
          id: requestRef.documentID,
          customerName: requestData['customerName'],
          customerId: _userId,
          body: requestData['body'],
          creationDate: requestData['creationDate'],
        ).toFireBaseDoc(),
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void update(String userId) {
    this._userId = userId;
  }
}
