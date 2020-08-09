import 'package:flutter/widgets.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//models
import '../models/media_model.dart';

class MovieProvider with ChangeNotifier {
  final _fireStore = Firestore.instance;
  final _identifier = "media";

  List<MediaModel> _movies = [];
  List<MediaModel> get movies {
    return [..._movies];
  }

  Future<void> fetchAndSetMovies({String category = "All"}) async {
    try {
      final movies1 = [];
      final moviesSnapshot = await _fireStore
          .collection(_identifier)
          .where(
            "category",
            isEqualTo: category,
          )
          .where(
            "type",
            isEqualTo: "video",
          )
          .getDocuments();
      final movieItems = moviesSnapshot.documents;
      movieItems.forEach((movieItem) {
        movies1.add(
          MediaModel.fromFireBaseDocument(movieItem),
        );
      });

      _movies = [...movies1];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  MediaModel getMediaById(String id) {
    return _movies.firstWhere((mediaElement) => mediaElement.id == id);
  }
}
