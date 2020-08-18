import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/helpers/payment_pop_up.dart';

//models
import '../../models/collection_model.dart';

//helper
import '../../helpers/error_pop_up_helper.dart';

//provider
import '../../providers/collection_provider.dart';
import '../../providers/media_provider.dart';

//widgets
import '../../widgets/archived_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/no_content_widget.dart';
import '../../widgets/waiting_widget.dart';

class CollectionScreen extends StatefulWidget {
  static const routeName = "collectionScreen";

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  bool isLoading = true;
  bool isInit = true;
  List<MediaProvider> mediaProviders = [];
  List<CollectionModel> collectionModels = [];

  CollectionProvider _colProd;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(Duration.zero, () async {
      print("Here");
      //get the collection provider
      _colProd = Provider.of<CollectionProvider>(context, listen: false);

      //fetch and set items
      await _colProd.fetchAndSetCollectionItems();
      print("tHere");
      //get results and store in local variable
      collectionModels = _colProd.collectionItems;

      //loop through each and get media provider for later
      for (var col in collectionModels) {
        var med = await MediaProvider.fetchMediaDataForCollection(
          col.id,
        );
        mediaProviders.add(med);
      }

      print("Hello");
    }).then(
      (value) => setState(
        () {
          isLoading = false;
        },
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        'Collection',
      ),
      body: isLoading
          ? Center(
              child: WaitingWidget(),
            )
          : collectionModels.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: NoContentWidget(
                      'No saved media',
                    ),
                  ),
                )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<CollectionProvider>(
                    builder: (context, colProd2, child) {
                      return ListView.separated(
                        separatorBuilder: (context , index) => SizedBox(height: 10,),
                        itemBuilder: (context, index) {
                          print(mediaProviders.length);
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              alignment: Alignment.centerRight,
                              color: Colors.grey,
                              child: Icon(
                                Icons.delete_forever,
                                size: 32,
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
                                          child: Text(
                                            'Yes',
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text(
                                            'No',
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            },
                            onDismissed: (direction) async {
                              await _colProd.removeFromWatchLater(
                                collectionModels[index].id,
                              );
                            },
                            child: ChangeNotifierProvider<MediaProvider>.value(
                              value: mediaProviders[index],
                              child: ArchivedWidget(),
                            ),
                          );
                        },
                        itemCount: colProd2.collectionItems.length,
                      );
                    },
                  ),
              ),
    );
  }
}
