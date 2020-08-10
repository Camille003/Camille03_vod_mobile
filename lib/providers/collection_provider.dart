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

  //remove from watch later
  Future<void> removeFromWatchLater(String userId, String movieId) async {
    try {
      final playLisRef = _firestore
          .document(userId)
          .collection("collection")
          .document(movieId);

      final doc = await playLisRef.get();

      if (doc.exists) {
        await playLisRef.delete();
      }

      _collectionItems.removeWhere(
        (collectionItem) => collectionItem.id == movieId,
      );

      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  void update(String id) {
    this._userId = id;
  }
}
