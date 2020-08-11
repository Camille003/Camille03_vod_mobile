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
    final collectionProvider = Provider.of<CollectionProvider>(
      context,
      listen: false
    );
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await collectionProvider.fetchAndSetCollectionItems();
        },
        child: FutureBuilder(
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
              return ListView.builder(
                itemBuilder: (context, index) {
                  return ArchivedWidget(
                    id: collectionData[index].id,
                    author: collectionData[index].author,
                    name: collectionData[index].name,
                    imageUrl: collectionData[index].imageUrl,
                  );
                },
                itemCount: collectionProvider.collectionItems.length,
              );
            }
          },
        ),
      ),
    );
  }
}
