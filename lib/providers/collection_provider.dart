import 'package:flutter/foundation.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';
//model
import '../models/collection_model.dart';

class CollectionProvider with ChangeNotifier {
  String _userId;
  final _firestore = Firestore.instance.collection("collection");
  final _identifier = "collection";
  CollectionProvider(this._userId);

  List<CollectionModel> _collectionItems = [];

  List<CollectionModel> get collectionItems {
    return [..._collectionItems];
  }

  Future<void> fetchAndSetCollectionItems() async {
    final collectionArray = [];
    final querySnapShot = await _firestore
        .document(_userId)
        .collection(_identifier)
        .getDocuments();
    if (querySnapShot.documents.isNotEmpty) {
      querySnapShot.documents.forEach((snapShot) {
        collectionArray.add(
          CollectionModel.fromFireBase(
            snapShot,
          ),
        );
      });
    }
    _collectionItems = [...collectionArray];
    notifyListeners();
    try {} catch (e) {
      throw e;
    }
  }

  Future<void> removeFromCollection(String movieId) async {
    try {} catch (e) {
      throw e;
    }
  }

  
  void update(String id) {
    this._userId = id;
  }
}
