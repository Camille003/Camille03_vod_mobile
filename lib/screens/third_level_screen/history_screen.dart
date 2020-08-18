import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/helpers/payment_pop_up.dart';

//models
import '../../models/history_model.dart';

//helpers
import '../../helpers/error_pop_up_helper.dart';

//provider
import '../../providers/history_provider.dart';
import '../../providers/media_provider.dart';

//widgets
import '../../widgets/archived_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/no_content_widget.dart';
import '../../widgets/waiting_widget.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = "historyScreen";

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool isLoading = true;
  List<MediaProvider> mediaProviders = [];
  List<HistoryModel> historyModels = [];

  HistoryProvider _historyProvider;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _historyProvider = Provider.of<HistoryProvider>(context ,listen: false);
      //get all items
      await _historyProvider.fetchAndSetHistoryItems();

      //store them in array
      historyModels = _historyProvider.historyItems;

      //loop and get media
      for (var history in historyModels) {
        var med = await MediaProvider.fetchMediaDataForCollection(history.id);
        mediaProviders.add(med);
      }

      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        'Privacy',
      ),
      body: isLoading
          ? Center(
              child: WaitingWidget(),
            )
          : historyModels.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: NoContentWidget(
                      'No history yet',
                    ),
                  ),
                )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                   separatorBuilder: (context , index) => SizedBox(height: 10,),
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider<MediaProvider>.value(
                        value: mediaProviders[index],
                        child: ArchivedWidget(),
                      );
                    },
                    itemCount: historyModels.length,
                  ),
              ),
    );
  }
}
