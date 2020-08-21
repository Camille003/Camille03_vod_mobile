//flutter
import 'package:flutter/foundation.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';
//model
import '../models/collection_model.dart';

class CollectionProvider with ChangeNotifier {
  CollectionProvider(this._userId);

  List<CollectionModel> _collectionItems = [];
  final _firestore = Firestore.instance.collection("collection");
  

  final _identifier = "collection";

  String _userId;

  List<CollectionModel> get collectionItems {
    return [..._collectionItems].reversed.toList();
  }

  Future<void> fetchAndSetCollectionItems() async {
  

    try {
      final collectionArray = [];
      final querySnapShot = await _firestore
          .document(_userId)
          .collection(_identifier)
          .getDocuments();
      if (querySnapShot.documents.isNotEmpty) {
        querySnapShot.documents.forEach((snapShot) {
          collectionArray.add(
            CollectionModel.fromFireBase(
              snapShot.data,
            ),
          );
        });
      }
      _collectionItems = [...collectionArray];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  //remove from watch later
  Future<void> removeFromWatchLater(String movieId) async {
    try {
      final playLisRef = _firestore
          .document(_userId)
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
