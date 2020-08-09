import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentModel {
  final String id;
  final DateTime creationDate;
  final String text;
  final String username;

  CommentModel({
    @required this.id,
    @required this.creationDate,
    @required this.text,
    @required this.username,
  });

  Map<String, String> toFireBaseDocument() {
    return {
      'creationDate': creationDate.toIso8601String(),
      'text': text,
      'username': username,
      'id': id,
    };
  }

  static CommentModel fromFireBaseDocument(DocumentSnapshot data) {
    return CommentModel(
      id: data['id'],
      creationDate: DateTime.parse(
        data['creationDate'],
      ),
      text: data['text'],
      username: data['username'],
    );
  }
}
