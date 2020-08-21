import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:loadmore/loadmore.dart';

//model
import 'package:vidzone/models/news_model.dart';

//provider
import '../../providers/news_provider.dart';

//widgets
import '../../widgets/svg_widget.dart';
import '../../widgets/news_item_widget.dart';
import '../../widgets/waiting_widget.dart';

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  TextEditingController _search = TextEditingController();
  NewsProvider _newsProvider;
  List<NewsModel> _newsItems = [];
  bool _isEmpty = true;
  bool _isSearching = false;
  
  int _maxItems;

  void clearSearch() {
    _search.text = '';
    _newsProvider.clearData();
    setState(() {
      _isEmpty = true;
      _newsItems = [];
    });
  }

  Future<void> searchNews() async {
    setState(() {
      _isSearching = true;
    });
    _newsProvider.query = _search.text;
    _newsProvider.setPage = _newsProvider.page + 1;
    await _newsProvider.fetchAndSetNewsItem();

    _maxItems = _newsProvider.numberOfResults;
    setState(() {
      _newsProvider.newsItems.forEach((element) {
        _newsItems.add(
          element,
        );
      });
      _isSearching = true;
    });
  }

  Future<bool> load() async {
    try {
      _newsProvider.setPage = _newsProvider.page + 1;
      _newsProvider.query = _search.text;
      await _newsProvider.fetchAndSetNewsItem();

      setState(() {
        _newsProvider.newsItems.forEach((element) {
          _newsItems.add(
            element,
          );
        });
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _newsProvider = Provider.of<NewsProvider>(context, listen: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      scrollPadding: EdgeInsets.all(0),
                      controller: _search,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                        labelText: 'Search news item',
                      ),
                      onChanged: _isEmpty
                          ? (string) {
                              setState(() {
                                _isEmpty = false;
                              });
                            }
                          : (string) {
                              if (_search.text.isEmpty) {
                                setState(() {
                                  _isEmpty = true;
                                });
                              }
                            },
                      onSubmitted: (value) {
                        searchNews();
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: _isEmpty
                        ? null
                        : () {
                            clearSearch();
                            setState(() {
                              _isEmpty = true;
                            });
                          },
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        _isEmpty ? Icons.search : Icons.clear,
                        size: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _newsItems.isEmpty
                  ? SvgWidget(
                      'assets/images/search.svg',
                    )
                  : _isSearching
                      ? WaitingWidget()
                      : LoadMore(
                          whenEmptyLoad: false,
                          isFinish: _newsItems.length > _maxItems,
                          onLoadMore: load,
                          child: ListView.builder(
                            itemCount: _newsItems.length,
                            itemBuilder: (context, index) {
                              // return ListTile(
                              //   title: Text(
                              //     '${_newsItems[index]}',
                              //   ),
                              // );
                              final newsItem = _newsItems[index];

                              return NewsItemWidget(
                                newsItem,
                              );
                            },
                          ),
                          textBuilder: DefaultLoadMoreTextBuilder.english,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
