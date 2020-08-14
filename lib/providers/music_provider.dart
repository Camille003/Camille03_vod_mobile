import 'package:flutter/widgets.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//provider
import './media_provider.dart';

//models
import 'media_provider.dart';

class MusicProvider  with ChangeNotifier {
  final _fireStore = Firestore.instance;
  final _identifier = "media";

  List<MediaProvider> _musics = [];
  List<MediaProvider> get musics {
    return [..._musics];
  }

  Future<void> fetchAndSetMusic({String category = "All"}) async {
    try {
      final musics1 = [];
      final moviesSnapshot = await _fireStore
          .collection(_identifier)
          .where(
            "type",
            isEqualTo: "music",
          )
          .getDocuments();
      final musicItems = moviesSnapshot.documents;
      musicItems.forEach((musicItem) {
        musics1.add(
          MediaProvider.fromFireBaseDocument(musicItem.data),
        );
      });

      _musics = [...musics1];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  MediaProvider getMediaById(String id) {
    return _musics.firstWhere((mediaElement) => mediaElement.id == id);
  }
}
