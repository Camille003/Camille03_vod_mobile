import 'package:flutter/material.dart';

import '../emums/account_type_enum.dart';
import '../emums/user_status_enum.dart';

//third party

import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = Firestore.instance;

class UserModel {
  final String id;
  final String name;
  final String imageUrl;
  final String email;
  final DateTime creationDate;
  final AccountType accountType;
  final UserStatus status;
  final String password;

  DateTime nextPaymentDate;

  UserModel({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.creationDate,
    this.accountType = AccountType.Premium,
    this.status = UserStatus.Active,
    this.nextPaymentDate,
    @required this.password,
    @required this.email,
  });

  void nextPayment() {
    nextPaymentDate = creationDate.add(
      Duration(days: 30),
    );
  }

  Map<String, dynamic> toFireBaseDocument() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'creationDate': creationDate.toIso8601String(),
      'accountType': (accountType == AccountType.Free)
          ? "FREE"
          : (accountType == AccountType.Basic) ? "BASIC" : "PREMIUM",
      'status': (status == UserStatus.Active) ? "ACTIVE" : "DISABLED",
      'password': password,
      'email': email,
      'nextPaymentDate': nextPaymentDate
    };
  }

  static UserModel fromFireBaseDocument(Map<String, dynamic> firebaseDocument) {
    return UserModel(
      id: firebaseDocument['id'],
      name: firebaseDocument['name'],
      email: firebaseDocument['email'],
      password: firebaseDocument['password'],
      accountType: (firebaseDocument['accountType'] == "FREE")
          ? AccountType.Free
          : (firebaseDocument['accountType'] == "BASIC")
              ? AccountType.Basic
              : AccountType.Premium,
      status: (firebaseDocument['status'] == "ACTIVE")
          ? UserStatus.Active
          : UserStatus.Disabled,
      creationDate: DateTime.parse(
        firebaseDocument['creationDate'],
      ),
      imageUrl: firebaseDocument['imageUrl'],
      nextPaymentDate: DateTime.parse(
        firebaseDocument['nextPaymentDate'],
      ),
    );
  }

  static Future<void> createUser(Map<String, dynamic> userData) async {
    try {
      final UserModel user = UserModel(
        id: userData['id'],
        name: userData['displayName'],
        imageUrl: userData['imageUrl'],
        creationDate: DateTime.parse(
          userData['creationDate'],
        ),
        password: userData['password'],
        email: userData['email'],
      );

      user.nextPayment();

      final userRef = _fireStore.collection("users").document(user.id);
      await userRef.setData(user.toFireBaseDocument());
    } catch (e) {
      throw e;
    }
  }

  Future<void> makePayment(
      AccountType accountType, DateTime paymentDate) async {
    try {
      final userRef = _fireStore.collection("users").document(id);

      await userRef.updateData(
        {
          "accountType": (accountType == AccountType.Free)
              ? "FREE"
              : (accountType == AccountType.Basic) ? "BASIC" : "PREMIUM",
          "nextPaymentDate": paymentDate
              .add(
                Duration(days: 30),
              )
              .toIso8601String(),
        },
      );
    } catch (e) {
      throw e;
    }
  }
}
