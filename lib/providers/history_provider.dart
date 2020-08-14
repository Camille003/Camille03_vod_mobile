import 'package:flutter/foundation.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//model
import '../models/history_model.dart';

class HistoryProvider with ChangeNotifier {
  String _userId;

  final _firestore = Firestore.instance.collection("history");
  final _identifier = "history";
  HistoryProvider(this._userId);

  List<HistoryModel> _historyItems = [];

  List<HistoryModel> get historyItems {
    return [..._historyItems].reversed.toList();
  }

  Future<void> fetchAndSetHistoryItems() async {
    try {
      final historyArray = [];
      final querySnapShot = await _firestore
          .document(_userId)
          .collection(_identifier)
          .getDocuments();
      if (querySnapShot.documents.isNotEmpty) {
        querySnapShot.documents.forEach((snapShot) {
          historyArray.add(
            HistoryModel.fromFireBase(
              snapShot.data,
            ),
          );
        });
      }
      _historyItems = [...historyArray];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  List<HistoryModel> getRecentItems() {
    if (_historyItems.length > 10) {
      return _historyItems.sublist(
        0,
        11,
      );
    }
    return _historyItems.sublist(
      0,
      _historyItems.length,
    );
  }

  void update(String id) {
    this._userId = id;
  }
}
