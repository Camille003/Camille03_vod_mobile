// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';

class DownloadModel {
  final String id;
  final String name;
  final String imageUrl;
  final String author;
  final String downloadPath;
  final DateTime downloadDate;

  DownloadModel({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.author,
    @required this.downloadPath,
    @required this.downloadDate,
  });

  DownloadModel.fromSembast(Map<String, dynamic> snapshot)
      : id = snapshot['id'],
        name = snapshot['name'],
        imageUrl = snapshot['imageUrl'],
        author = snapshot['author'],
        downloadDate = DateTime.tryParse(
          snapshot['downloadDate'],
        ),
        downloadPath = snapshot['downloadPath'];

  Map<String, String> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'author': author,
      'downloadPath': downloadPath,
      'downloadDate': downloadDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    print(
      jsonEncode({}),
    );
  }
}
