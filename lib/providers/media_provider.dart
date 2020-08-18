import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

//models
import '../models/collection_model.dart';
import '../models/media_model.dart';
// import '../models/download_model.dart';
import '../models/history_model.dart';

final _fireStore = Firestore.instance.collection("media");
final _playListRef = Firestore.instance.collection("collection");
final _likesRef = Firestore.instance.collection("likes");
final _hsitoryRef = Firestore.instance.collection("history");

class MediaProvider with ChangeNotifier {
  final String id;
  final String name;
  final String author;
  final String imageUrl;
  final int duration;

  final int numberOfViews;
  final DateTime uploadDate;

  int numberOfLikes;

  MediaModel _media;

  MediaModel get media {
    return _media;
  }

  MediaProvider({
    this.id,
    this.name,
    this.author,
    this.imageUrl,
    this.duration,
    this.numberOfLikes,
    this.numberOfViews,
    this.uploadDate,
  });

  MediaProvider.fromFireBaseDocument(Map<String, dynamic> firebaseDocument)
      : id = firebaseDocument['id'],
        name = firebaseDocument['name'],
        author = (firebaseDocument['author']),
        imageUrl = firebaseDocument['imageUrl'],
        duration = (firebaseDocument['duration']),
        numberOfLikes = firebaseDocument['numberOfLikes'],
        numberOfViews = firebaseDocument['numberOfViews'],
        uploadDate = DateTime.parse(firebaseDocument['uploadDate']);

 static  Future<MediaProvider> fetchMediaDataForCollection(String id) async {
    try {
      final document = await _fireStore.document(id).get();

      if (!document.exists) {
        return null;
      }
      return MediaProvider.fromFireBaseDocument(document.data);
    } catch (e, s) {
      print(e);
      print(s);
      throw e;
    }
  }

  Future<void> fetchAndSetMediaContent() async {
    try {
      final document = await _fireStore.document(id).get();

      if (document.exists) {
        _media = MediaModel.fromFireBaseDocument(document.data);
        print("Exists");
      }

      notifyListeners();
    } catch (e, s) {
      print(e);
      print(s);
      throw e;
    }
  }

  //check if saved
  Future<bool> hasBeenSaved(String userId) async {
    print("has been saved  runnig");

    try {
      final playlistQuerySnapshot = await _playListRef
          .document(userId)
          .collection("collection")
          .document(id)
          .get();

      if (!playlistQuerySnapshot.exists) {
        print(playlistQuerySnapshot.data);
        return false;
      }
      return true;
    } catch (e) {
      print("Get video");
      throw e;
    }
  }

  //check if video has been liked
  Future<bool> hasBeenLiked(String userId) async {
    print("has been liked  runnig");
    try {
      final likedDocument = await _likesRef
          .document(userId)
          .collection("likes")
          .document(id)
          .get();

      if (!likedDocument.exists) {
        return false;
      }
      return true;
    } catch (e) {
      print("Get video");
      throw e;
    }
  }

//like a video
  Future<void> likeVideo(String userId) async {
    print("Like video runnig");
    try {
      final mediaRef = _fireStore.document(
        id,
      );

      await mediaRef.updateData(
        {
          'numberOfLikes': FieldValue.increment(
            1,
          ),
        },
      );
      await _likesRef.document(userId).collection("likes").document(id).setData(
        {
          'id': id,
        },
      );

      numberOfLikes = numberOfLikes + 1;

      notifyListeners();
    } catch (e) {
      print("Get video");
      throw e;
    }
  }

  //+1 view
  Future<void> addView(String userId) async {
    try {
      final mediaRef = _fireStore.document(
        id,
      );
      await mediaRef.updateData(
        {
          'numberOfViews': FieldValue.increment(
            1,
          ),
        },
      );
    } catch (e) {
      print("Get video");
      throw e;
    }
  }

  //add to user watched collection
  Future<void> watched(String userId) async {
    print("add to watched  runnig");
    try {
      await _hsitoryRef
          .document(userId)
          .collection("history")
          .document(id)
          .setData(
            HistoryModel(
              id: id,
              name: name,
              imageUrl: imageUrl,
              author: author,
            ).toFireBaseDocument(),
          );
    } catch (e) {
      throw e;
    }
  }

  //add to watch later
  Future<void> addToWatchLater(String userId) async {
    print("add to collection  runnig");
    try {
      final playList =
          _playListRef.document(userId).collection("collection").document(id);

      CollectionModel model = CollectionModel(
        id: id,
        name: name,
        imageUrl: imageUrl,
        author: author,
      );

      await playList.setData(
        model.toFireBaseDocument(),
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
