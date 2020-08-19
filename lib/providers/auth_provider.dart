//   Future<void> signIn(String email, String password) async {
//     try {
//       final AuthResult authResult = await _firebaseAuth
//           .signInWithEmailAndPassword(email: email, password: password);

//       final userData = {
//         'id': authResult.user.uid,
//         'email': authResult.user.email,
//       };
//       await _storeCongurationData(userData['email'], userData['id']);
//       _setData(userData);

//       notifyListeners();
//     } on AuthException catch (e) {
//       print(e);
//       throw e.message;
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthProvider with ChangeNotifier {
  bool isLoggedIn = false;
  String _id;
  String get id {
    return _id;
  }

  Future<void> signUp(String password) async {
    //1 use google auth
    final GoogleSignInAccount account = await _googleSignIn.signIn();

    //2 get the data and create user on firebase
    final AuthResult authResult = await _auth.createUserWithEmailAndPassword(
      email: account.email,
      password: password,
    );


    //3 store the result in a map
    final userData = {
      'id': authResult.user.uid,
      'email': account.email,
      'displayName': account.displayName,
      'imageUrl': account.photoUrl,
      'password': password,
      'creationDate': DateTime.now().toIso8601String(),
    };

    //4 create user and store in cluod firestore
    await UserModel.createUser(userData);

    //get prefs and store id localy
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = await prefs.setString('id', userData['id']);
    _id = userData['id'];

    //notify listeners and proxy providers
    notifyListeners();
  }

  Future<String> autoLogin() async {
    //1 get instance of shared prefs
    final prefs = await SharedPreferences.getInstance();

    //2 chek if key id is stored on device
    if (prefs.containsKey('id')) {
     
      isLoggedIn = true;
      _id = prefs.getString('id');
     return "login";
    }

    //if not return false
   
    return "not logged in";
  }
}
