import 'package:flutter/foundation.dart';

class NewsModel {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final DateTime publishedAt;
  final String content;

  NewsModel({
    @required this.author,
    @required this.title,
    @required this.description,
    @required this.url,
    @required this.urlToImage,
    @required this.publishedAt,
    @required this.content,
  });

  NewsModel.fromJson(Map<String, dynamic> parsedJson)
      : author = parsedJson['author'] ?? 'Missing author',
        title = parsedJson['title'] ?? 'Missing title',
        description = parsedJson['description'] ?? 'Missing description',
        url = parsedJson['url'],
        urlToImage = parsedJson['urlToImage'] ?? 'http://via.placeholder.com/300x300',
        publishedAt = DateTime.tryParse(
          parsedJson['publishedAt'],
        ),
        content = parsedJson['content'] ?? 'Missing content';
}
