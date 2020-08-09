import 'package:flutter/widgets.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//models
import '../models/media_model.dart';

class MovieProvider with ChangeNotifier {
  final _fireStore = Firestore.instance;
  final _identifier = "media";

  List<MediaModel> _musics = [];
  List<MediaModel> get musics {
    return [..._musics];
  }

  Future<void> fetchAndSetMovies({String category = "All"}) async {
    try {
      final musics1 = [];
      final moviesSnapshot = await _fireStore
          .collection(_identifier)
          .where(
            "category",
            isEqualTo: category,
          )
          .where(
            "type",
            isEqualTo: "music",
          )
          .getDocuments();
      final musicItems = moviesSnapshot.documents;
      musicItems.forEach((musicItem) {
        musics1.add(
          MediaModel.fromFireBaseDocument(musicItem),
        );
      });

      _musics = [...musics1];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  MediaModel getMediaById(String id) {
    return _musics.firstWhere((mediaElement) => mediaElement.id == id);
  }
}
