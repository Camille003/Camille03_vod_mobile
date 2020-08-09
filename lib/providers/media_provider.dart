import 'package:cloud_firestore/cloud_firestore.dart';

class MediaProvider {
  final _media = Firestore.instance.collection("media");
  final _playListRefs = Firestore.instance.collection("collection");
  final _likesRef = Firestore.instance.collection("likes");

  //check if saved
  Future<bool> hasBeenSaved(String userId, String vidId) async {
    try {
      final playlistQuerySnapshot = await _playListRefs
          .document(userId)
          .collection("collection")
          .document(vidId)
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
  Future<bool> hasBeenLiked(String vidId, String userId) async {
    try {
      final likedDocument = await _likesRef
          .document(userId)
          .collection("likes")
          .document(vidId)
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
  Future<void> likeVideo(String userId, String vidId) async {
    try {
      final mediaRef = _media.document(vidId);

      await mediaRef.updateData(
        {
          'numberOfLikes': FieldValue.increment(
            1,
          ),
        },
      );
      await _likesRef.document(userId).setData(
        {
          'vidId': vidId,
        },
      );
    } catch (e) {
      print("Get video");
      throw e;
    }
  }

  //+1 view
  Future<void> addView(String userId, String vidId) async {
    try {
      final mediaRef = _media.document(vidId);
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

  //get history

  //add to watch later
  Future<void> addToWatchLater(String userId, String movieId) async {
  
    try {
      final playList = _playListRefs
          .document(userId)
          .collection("collection")
          .document(movieId);

      await playList.setData({
        'id' : movieId
      });
    } catch (e) {
      throw e;
    }
  }

  //remove from watch later
  Future<void> removeFromWatchLater(String userId, String movieId) async {
    try {
      final playLisRef = _playListRefs
          .document(userId)
          .collection("collection")
          .document(movieId);

      final doc = await playLisRef.get();

      if (doc.exists) {
        await playLisRef.delete();
      }
    } catch (e) {
      throw (e);
    }
  }
}
