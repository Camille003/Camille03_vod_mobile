import 'package:flutter/widgets.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//models
import 'media_provider.dart';

//provider
import './media_provider.dart';

class MovieProvider  with ChangeNotifier {
  final _fireStore = Firestore.instance;
  final _identifier = "media";

  List<MediaProvider> _movies = [];
  List<MediaProvider> get movies {
    return [..._movies];
  }

  Future<void> fetchAndSetMovies({String category = "All"}) async {
    try {
      final movies1 = [];
      final moviesSnapshot = await _fireStore
          .collection(_identifier)
          .where(
            "type",
            isEqualTo: "video",
          )
          .getDocuments();
      final movieItems = moviesSnapshot.documents;
      movieItems.forEach((movieItem) {
        movies1.add(
          MediaProvider.fromFireBaseDocument(movieItem.data),
        );
      });

      _movies = [...movies1];
      notifyListeners();
    } catch (e,s) {
      print(e);
       print(s);
      throw e;
    }
  }

  MediaProvider getMediaById(String id) {
    return _movies.firstWhere((mediaElement) => mediaElement.id == id);
  }
}
