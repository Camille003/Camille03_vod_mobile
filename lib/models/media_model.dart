import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MediaModel with ChangeNotifier {
  final String id;
  final String name; //
  final String type; // |video | music | trailer
  final String author; //
  final String description; //
  final String
      category; // music will have its genres movies and trailer have theirs

  final String tags; //

  final String imageUrl;
  final String streamingUrl;
  final int duration;
  final int numberOfComments;
  final int numberOfLikes;
  final int numberOfViews;
  final DateTime uploadDate;

  MediaModel({
    this.id,
    this.name,
    this.type,
    this.author,
    this.description,
    this.category,
    this.tags,
    this.imageUrl,
    this.streamingUrl,
    this.duration,
    this.numberOfComments,
    this.numberOfLikes,
    this.numberOfViews,
    this.uploadDate,
  });

  static MediaModel fromFireBaseDocument(
      DocumentSnapshot firebaseDocument) {
    return MediaModel(
      id: firebaseDocument['id'],
      name: firebaseDocument['name'],
      type: (firebaseDocument['type']),
      category: firebaseDocument['category'],
      author: (firebaseDocument['author']),
      description: (firebaseDocument['description']),
      tags: (firebaseDocument['tags']),
      imageUrl: firebaseDocument['imageUrl'],
      streamingUrl: (firebaseDocument['streamingUrl']),
      duration: (firebaseDocument['duration']) / 60,
      numberOfComments: firebaseDocument['numberOfComments'],
      numberOfLikes: firebaseDocument['numberOfLikes'],
      numberOfViews: firebaseDocument['numberOfViews'],
      uploadDate: DateTime.parse(
        firebaseDocument['uploadDate'],
      ),
    );
  }
}
