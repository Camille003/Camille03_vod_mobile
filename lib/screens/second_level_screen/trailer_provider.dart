import 'package:flutter/widgets.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidzone/providers/media_provider.dart';

//models
import '../../models/media_model.dart';

class TrailerProvider extends MediaProvider with ChangeNotifier {
  final _fireStore = Firestore.instance;
  final _identifier = "media";

  List<MediaModel> _trailers = [];
  List<MediaModel> get trailers {
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
          MediaModel.fromFireBaseDocument(trailerItem.data),
        );
      });

      _trailers = [...trailer1];
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  MediaModel getMediaById(String id) {
    return _trailers.firstWhere((mediaElement) => mediaElement.id == id);
  }
}
