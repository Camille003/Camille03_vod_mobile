import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MediaModel with ChangeNotifier {
  final String id;
  final String name; //

  final String author; //
  final String description; //

  final String imageUrl;
  final String streamingUrl;
  final int duration;

  final int numberOfLikes;
  final int numberOfViews;
  final DateTime uploadDate;

  MediaModel({
    this.id,
    this.name,
    this.author,
    this.description,
    this.imageUrl,
    this.streamingUrl,
    this.duration,
    this.numberOfLikes,
    this.numberOfViews,
    this.uploadDate,
  });

  static MediaModel fromFireBaseDocument(DocumentSnapshot firebaseDocument) {
    return MediaModel(
      id: firebaseDocument['id'],
      name: firebaseDocument['name'],
      author: (firebaseDocument['author']),
      description: (firebaseDocument['description']),
      imageUrl: firebaseDocument['imageUrl'],
      streamingUrl: (firebaseDocument['streamingUrl']),
      duration: (firebaseDocument['duration']) / 60,
      numberOfLikes: firebaseDocument['numberOfLikes'],
      numberOfViews: firebaseDocument['numberOfViews'],
      uploadDate: DateTime.parse(
        firebaseDocument['uploadDate'],
      ),
    );
  }
}
