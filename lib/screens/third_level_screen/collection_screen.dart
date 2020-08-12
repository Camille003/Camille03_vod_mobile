import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';

//helper
import '../../helpers/error_pop_up_helper.dart';
//provider
import '../../providers/collection_provider.dart';

//widgets
import '../../widgets/archived_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/no_content_widget.dart';
import '../../widgets/waiting_widget.dart';

class CollectionScreen extends StatelessWidget {
  static const routeName = "collectionScreen";
  @override
  Widget build(BuildContext context) {
    final collectionProvider =
        Provider.of<CollectionProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Collection',
          style: Theme.of(context).appBarTheme.textTheme.headline1,
        ),
      ),
      body: FutureBuilder(
        future: collectionProvider.fetchAndSetCollectionItems(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: WaitingWidget());
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
          final collectionData = collectionProvider.collectionItems;
          if (collectionData.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: NoContentWidget(
                  'No saved media',
                ),
              ),
            );
          } else {
            return Consumer<CollectionProvider>(
                builder: (ctx, collectionData, child) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: ValueKey(
                      collectionData.collectionItems[index].id,
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
                          });
                    },
                    onDismissed: (direction) {
                      collectionData.removeFromWatchLater(
                          collectionData.collectionItems[index].id);
                    },
                    child: ArchivedWidget(
                      id: collectionData.collectionItems[index].id,
                      author: collectionData.collectionItems[index].author,
                      name: collectionData.collectionItems[index].name,
                      imageUrl: collectionData.collectionItems[index].imageUrl,
                    ),
                  );
                },
                itemCount: collectionData.collectionItems.length,
              );
            });
          }
        },
      ),
    );
  }
}
