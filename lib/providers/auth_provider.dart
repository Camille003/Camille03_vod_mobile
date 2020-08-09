// import 'dart:convert';

// import 'package:flutter/foundation.dart';

// //third parties
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user_model.dart';

// final GoogleSignIn _googleSignIn = GoogleSignIn();
// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// class AuthProvider with ChangeNotifier {
//   String _email;
//   String _id;
//   bool get isLoggedIn {
//     if (_email != null) {
//       print(true);
//       return true;
//     }

//     return false;
//   }

//   String get id {
//     return _id;
//   }

//   String get email {
//     return _email;
//   }

//   Future<void> signUp(String password) async {
//     try {
//       final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

//       final AuthResult authResult =
//           await _firebaseAuth.createUserWithEmailAndPassword(
//               email: googleUser.email, password: password);

//       final userData = {
//         'id': authResult.user.uid,
//         'email': googleUser.email,
//         'displayName': googleUser.displayName,
//         'password': password,
//         'imageUrl': googleUser.photoUrl,
//         'creationDate': DateTime.now().toIso8601String()
//       };

//       print(userData);

//       await UserModel.createUser(userData);
//       await sharedPrefs.setString(
//       'id',
//       id,
//     );
//     await sharedPrefs.setString(
//       'email',
//       email,
//     );
//      _email = userData['email'];
//     _id = userData['id'];

//       notifyListeners();
//     } on AuthException catch (e) {
//       throw e.message;
//     } catch (e) {
//       throw e;
//     }
//   }

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

//   Future<bool> autoLogin() async {
//     final prefs = await SharedPreferences.getInstance();
//     if (!prefs.containsKey('email')) {
//       print("Doesnot contain");
//       return false;
//     }
//     _email = prefs.getString('email');
//     _id = prefs.getString('id');

//     return true;
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidzone/models/user_model.dart';

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
      'diaplayName': account.displayName,
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
      print("Found key");
      isLoggedIn = true;
      return "login";
    }

    //if not return false
     print("No found");
    return "not logged in";
  }
}
