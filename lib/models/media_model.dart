import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MediaData {
  final String id;
  final String name;
  final String author;
  final String imageUrl;
  final int duration;
  final int numberOfLikes;
  final int numberOfViews;
  final DateTime uploadDate;
  final String description;
  final String streamingUrl;

  MediaData.fromFireBaseDocument(DocumentSnapshot fireBaseDoc)
      : id = fireBaseDoc['id'],
        name = fireBaseDoc['name'],
        author = fireBaseDoc['author'],
        imageUrl = fireBaseDoc['imageUrl'],
        description = fireBaseDoc['description'],
        duration = fireBaseDoc['duration'],
        numberOfLikes = fireBaseDoc['numberOfLikes'],
        numberOfViews = fireBaseDoc['numberOfViews'],
        uploadDate = DateTime.parse(fireBaseDoc['uploadDate']),
        streamingUrl = fireBaseDoc['streamingUrl'];
}

class MediaModel with ChangeNotifier {
  final _fireStore = Firestore.instance.collection("media");
  final _playListRef = Firestore.instance.collection("collection");
  final _likesRef = Firestore.instance.collection("likes");

  final String id;
  final String name;
  final String author;
  final String imageUrl;
  final int duration;
   int numberOfLikes;
  final int numberOfViews;
  final DateTime uploadDate;

  MediaData _media;

  MediaData get media {
    return _media;
  }

  MediaModel({
    this.id,
    this.name,
    this.author,
    this.imageUrl,
    this.duration,
    this.numberOfLikes,
    this.numberOfViews,
    this.uploadDate,
  });

  MediaModel.fromFireBaseDocument(DocumentSnapshot firebaseDocument)
      : id = firebaseDocument['id'],
        name = firebaseDocument['name'],
        author = (firebaseDocument['author']),
        imageUrl = firebaseDocument['imageUrl'],
        duration = (firebaseDocument['duration']) / 60,
        numberOfLikes = firebaseDocument['numberOfLikes'],
        numberOfViews = firebaseDocument['numberOfViews'],
        uploadDate = DateTime.parse(firebaseDocument['uploadDate']);

  Future<void> fetchAndSetMediaContent() async {
    try {
      final document = await _fireStore.document(id).get();
      _media = MediaData.fromFireBaseDocument(document);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  //check if saved
  Future<bool> hasBeenSaved(String userId) async {
    try {
      final playlistQuerySnapshot = await _playListRef
          .document(userId)
          .collection("collection")
          .document(id)
          .get();

      if (!playlistQuerySnapshot.exists) {
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
      await _likesRef.document(userId).setData(
        {
          'vidId': id,
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

  //add to watch later
  Future<void> addToWatchLater(String userId) async {
    try {
      final playList =
          _playListRef.document(userId).collection("collection").document(id);

      await playList.setData({
        'id': id,
      });

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
