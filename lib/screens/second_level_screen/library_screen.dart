import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';

//providers
import '../../providers/history_provider.dart';

//widgets
import '../../widgets/recent_video_widget.dart';
import '../../widgets/waiting_widget.dart';

//screens
import '../../screens/third_level_screen/collection_screen.dart';
import '../../screens/third_level_screen/downloads_screen.dart';
import '../../screens/third_level_screen/history_screen.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent',
            ),
            FutureBuilder(
              future: historyProvider.fetchAndSetHistoryItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: WaitingWidget(),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  final listItems = historyProvider.getRecentItems();
                  if (listItems.isEmpty) {
                    return Container(
                      height: 80,
                      width: double.infinity,
                      child: Text(
                        'No history yet.',
                      ),
                      alignment: Alignment.centerLeft,
                    );
                  } else {
                    return ListView.builder(
                      itemCount: listItems.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, i) => RecentItemWidget(
                        author: listItems[i].author,
                        name: listItems[i].name,
                        imageUrl: listItems[i].imageUrl,
                      ),
                    );
                  }
                }
              },
            ),
            Divider(
              height: 2,
              color: Colors.black,
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 0),
              onTap: () {
                Navigator.of(context).pushNamed(HistoryScreen.routeName);
              },
              leading: Icon(
                Icons.history,
              ),
              title: Text(
                'History',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 0),
              onTap: () {
                Navigator.of(context).pushNamed(CollectionScreen.routeName);
              },
              leading: Icon(
                Icons.library_add,
              ),
              title: Text(
                'Collection',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 0),
              onTap: () {
                Navigator.of(context).pushNamed(DownloadScreen.routeName);
              },
              leading: Icon(
                Icons.file_download,
              ),
              title: Text(
                'Downloads',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
