import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/helpers/payment_pop_up.dart';

//providers
import '../../providers/download_provider.dart';

//widgets
import '../../widgets/archived_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/no_content_widget.dart';
import '../../widgets/waiting_widget.dart';

class DownloadScreen extends StatelessWidget {
  static const routeName = "downloadScreen";
  @override
  Widget build(BuildContext context) {
    final downloadProvider = Provider.of<DownloadProvider>(
      context,
      listen: false,
    );
    return Scaffold(
     appBar: buildAppBar(
        context,
        'Donwloads',
      ),
      body: FutureBuilder(
        future: downloadProvider.fectchAndSetDownloads(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: WaitingWidget(),
            );
          } else if (snapshot.hasError) {
            //showPopUpError(context);
            print(snapshot.error);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: CustomErrorWidget(),
              ),
            );
          }
          final downloadData = downloadProvider.downloads;
          if (downloadData.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: NoContentWidget(
                  'No saved media',
                ),
              ),
            );
          } else {
            return Consumer<DownloadProvider>(
                builder: (ctx, downloadData, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(
                      downloadData.downloads[index].id,
                    ),
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: Icon(
                        Icons.delete_forever,
                      ),
                    ),
                    confirmDismiss: (dimissDirection) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Are you sure you want to delete from collection',
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text('Yes'),
                              ),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'),
                              )
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (direction) {
                      downloadData.delete(downloadData.downloads[index].id);
                    },
                    child: ArchivedWidget(
                      // id: downloadData.downloads[index].id,
                      // author: downloadData.downloads[index].author,
                      // name: downloadData.downloads[index].name,
                      // imageUrl: downloadData.downloads[index].imageUrl,
                    ),
                  );
                },
                itemCount: downloadData.downloads.length,
              );
            });
          }
        },
      ),
    );
  }
}
