import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';

//helpers
import '../../helpers/error_pop_up_helper.dart';

//provider
import '../../providers/history_provider.dart';

//widgets
import '../../widgets/archived_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/no_content_widget.dart';
import '../../widgets/waiting_widget.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = "historyScreen";
  @override
  Widget build(BuildContext context) {
    final historyProvider = Provider.of<HistoryProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      body: FutureBuilder(
        future: historyProvider.fetchAndSetHistoryItems(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: WaitingWidget());
          } else if (snapshot.hasError) {
            //showPopUpError(context);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CustomErrorWidget(),
              ),
            );
          }
          final historyData = historyProvider.historyItems;
          if (historyData.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: NoContentWidget(
                  'No recent activities',
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ArchivedWidget(
                  id: historyData[index].id,
                  author: historyData[index].author,
                  name: historyData[index].name,
                  imageUrl: historyData[index].imageUrl,
                );
              },
              itemCount: historyProvider.historyItems.length,
            );
          }
        },
      ),
    );
  }
}
