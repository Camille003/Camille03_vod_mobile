import 'package:flutter/material.dart';

//third party
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//model
import '../models/news_model.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsModel newsModel;
  NewsItemWidget(
    this.newsModel,
  );
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        launch(
          newsModel.urlToImage,
        );
      },
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Container(
          padding: EdgeInsets.all(
            10,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Image.network(
                  newsModel.urlToImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Text(
                'By: ${newsModel.author}',
                style: theme.textTheme.bodyText2,
              ),
              Text(
                newsModel.title,
                style: theme.textTheme.bodyText2,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                newsModel.description,
                style: theme.textTheme.bodyText2,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                newsModel.content,
                style: theme.textTheme.bodyText2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Published at: ${DateFormat.yMMMEd().format(
                  newsModel.publishedAt,
                )}',
                style: theme.textTheme.bodyText2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
