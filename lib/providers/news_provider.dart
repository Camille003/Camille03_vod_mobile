//dart
import 'dart:convert' as json;

//flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

//third party
import 'package:http/http.dart' show Client;

//model
import '../models/news_model.dart';

class NewsProvider with ChangeNotifier {
  String _query;
  int _numberOfResults = 0;
  int _page = 0;

  final Client _client = Client();
  final String _apiKey = '6b7c94be15044911b64c578c8861d579';

  List<NewsModel> _newsItems = [];

  List<NewsModel> get newsItems {
    return [..._newsItems];
  }

  int get page {
    return _page;
  }

  set setPage(int pageNumber) {
    _page = pageNumber;
  }

  int get numberOfResults {
    return _numberOfResults;
  }

  set query(String searchString) {
    _query = searchString;
  }

  void clearData() {
    _query = '';
    _page = 0;
    _numberOfResults = 0;
  }

  //for testing purposes
  // List<int> _finalArray = [];

  Future<void> fetchAndSetNewsItem() async {
    // final maximum = 9;
    // if (_newsItems.isEmpty) {
    //   _numberOfResults = 100;
    //   final List<int> myList = List.generate(
    //     100,
    //     (index) => index,
    //   );
    //   _finalArray = myList;
    //   print(_finalArray);
    // }

    // var start = (_page - 1) * 10;
    // var end = start + maximum;
    // _newsItems = _finalArray.sublist(
    //   start,
    //   end + 1,
    // );
    // print(
    //   _newsItems.length,
    // );

    final newQuery = '+' + _query;
    print(newQuery);

    try {
      final url =
          'https://newsapi.org/v2/everything?q=$newQuery&apiKey=$_apiKey&page=$_page&language=en&sortBy=publishedAt';

      final response = await _client.get(
        url,
      );

    print(json.jsonDecode(response.body));
     print(response.statusCode);

    if (response.statusCode < 400) {
      final responseBody = json.jsonDecode(
        response.body,
      ) as Map<String, dynamic>;

    _numberOfResults = responseBody['totalResults'];
    final articlesData = responseBody['articles'] as List<dynamic>;
    print(responseBody);
    final newsItems = articlesData
        .map(
          (article) => NewsModel.fromJson(
            article,
          ),
        )
        .toList();

    newsItems.forEach((element) {
      print(element.runtimeType);
      print(element.author);
    });
   // check for articles in articles property

    // print(numberOfResults);
    // print(
    //   (responseBody['articles'] as List).length,
    // );
   // print(responseBody['articles'][0]);
        _newsItems = newsItems;
      }
    } catch (e) {
      throw e;
    }
  }
}
