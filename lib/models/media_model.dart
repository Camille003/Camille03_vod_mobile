class MediaModel {
  final String id;
  final String name;
  final String author;
  final String imageUrl;
  final int duration;
  final int numberOfLikes;
  final int numberOfViews;
  final DateTime uploadDate;
  final String description;
  final String streamingUrl;

  MediaModel.fromFireBaseDocument(Map<String, dynamic> fireBaseDoc)
      : id = fireBaseDoc['id'],
        name = fireBaseDoc['name'],
        author = fireBaseDoc['author'],
        imageUrl = fireBaseDoc['imageUrl'],
        description = fireBaseDoc['description'],
        duration = fireBaseDoc['duration'],
        numberOfLikes = fireBaseDoc['numberOfLikes'],
        numberOfViews = fireBaseDoc['numberOfViews'],
        uploadDate = DateTime.parse(fireBaseDoc['uploadDate']),
        streamingUrl = fireBaseDoc['streamingUrl'];
}
