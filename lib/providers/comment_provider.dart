import 'package:flutter/widgets.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//models
import '../models/comments_model.dart';

class CommentsProvider with ChangeNotifier {
  final _fireStore = Firestore.instance;
  final _identifier = "comments";

  List<CommentModel> _comments = [];

  List<CommentModel> get comments {
    return [..._comments];
  }

  Future<void> createComment(CommentModel comment, String movieId) async {
    try {
      final response = await _fireStore
          .collection(_identifier)
          .document(movieId)
          .collection(_identifier)
          .add(comment.toFireBaseDocument());
      if (response.documentID.isNotEmpty) {
        print("No error");
      } else {
        print("Error from here");
        throw "Error";
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> fecthAndSetComments(String movieId) async {
    List commentList = [];
    try {
      final commentsQuerySnapshot = await _fireStore
          .collection(_identifier)
          .document(movieId)
          .collection(_identifier)
          .getDocuments();

      if (commentsQuerySnapshot.documents.isNotEmpty) {
        commentsQuerySnapshot.documents.forEach((commentDocumentSnapshot) {
          commentList
              .add(CommentModel.fromFireBaseDocument(commentDocumentSnapshot));
        });
        // commentList.reversed.toList();
        _comments = [...commentList.reversed.toList()];
      }

      notifyListeners();
    } catch (e) {
      print("Error from get data");
      print(e.toString());
      throw e;
    }
  }
}
