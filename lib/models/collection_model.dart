import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CollectionModel {
  final String id;
  final String name;
  final String imageUrl;
  final String author;

  CollectionModel({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.author,
  });

  CollectionModel.fromFireBase(Map<String,dynamic> snapshot)
      : id = snapshot['id'],
        name = snapshot['name'],
        imageUrl = snapshot['imageUrl'],
        author = snapshot['author'];

  Map<String, String> toFireBaseDocument() {
    return {
      'id': id,
      'name': name,
      'author': author,
      'imageUrl': imageUrl,
    };
  }
}
