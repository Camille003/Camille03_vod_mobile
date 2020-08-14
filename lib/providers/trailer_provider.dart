import 'package:flutter/widgets.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';
import './media_provider.dart';

//models
import 'media_provider.dart';

class TrailerProvider with ChangeNotifier {
  final _fireStore = Firestore.instance;
  final _identifier = "media";

  List<MediaProvider> _trailers = [];
  List<MediaProvider> get trailers {
    return [..._trailers];
  }

  Future<void> fetchAndSetTrailers({String category = "All"}) async {
    try {
      final trailer1 = [];
      final moviesSnapshot = await _fireStore
          .collection(_identifier)
          .where(
            "type",
            isEqualTo: "trailer",
          )
          .getDocuments();
      final trailerItems = moviesSnapshot.documents;
      trailerItems.forEach((trailerItem) {
        trailer1.add(
          MediaProvider.fromFireBaseDocument(trailerItem.data),
        );
      });

      _trailers = [...trailer1];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  MediaProvider getMediaById(String id) {
    return _trailers.firstWhere((mediaElement) => mediaElement.id == id);
  }
}
