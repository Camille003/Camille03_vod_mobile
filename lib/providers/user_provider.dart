//flutter
import 'package:flutter/foundation.dart';

//third party
import 'package:cloud_firestore/cloud_firestore.dart';

//model
import '../models/user_model.dart';

final _fireStore = Firestore.instance;

class UserProvider with ChangeNotifier {
  UserModel _user;
  String _id;

  UserModel get user {
    return _user;
  }

  void update(String id) {
    this._id = id;
    print(this._id);
  }

  UserProvider(this._id);

  Future<void> fetchAndSetUser() async {
    try {
      final firebaseDocument =
          await _fireStore.collection("users").document(_id).get();
      if (firebaseDocument.exists) {
        _user = UserModel.fromFireBaseDocument(firebaseDocument.data);
        print(_user.accountType);
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
