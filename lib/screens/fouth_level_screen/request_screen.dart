import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/helpers/payment_pop_up.dart';
// import 'package:bubble/bubble.dart';

//model
import '../../models/request_model.dart';

//widgets
import '../../widgets/no_content_widget.dart';
import '../../widgets/waiting_widget.dart';

//providers
import '../../providers/request_provider.dart';
import '../../providers/user_provider.dart';

class RequestScreen extends StatefulWidget {
  static const routeName = "requestScreen";

  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  TextEditingController _controller;
  bool _isEmpty = true;
  String customerName;
  @override
  void initState() {
    _controller = TextEditingController();
    Provider.of<UserProvider>(context, listen: false).fetchAndSetUser().then(
        (value) => {
              customerName =
                  Provider.of<UserProvider>(context, listen: false).user.name
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final requestProvider =
        Provider.of<RequestProvider>(context, listen: false);
    return Scaffold(
      appBar: buildAppBar(
        context,
        'Requests',
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: requestProvider.fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.none ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return WaitingWidget();
                } else if (snapshot.data == null) {
                  return NoContentWidget(
                    'No request yet.Submit one and get answered in 24hrs business day',
                  );
                }
                final requestData = snapshot.data.documents.map((doc) => RequestModel.fromFirebaseDocument(doc.data,),).toList().reversed.toList() ;
                return Center(child :Text('Requests will show up'),);
                // return ListView.builder(
                //   itemBuilder: (context, index) => Column(
                //     children: [
                //       Bubble(
                //         margin: BubbleEdges.only(top: 10),
                //         alignment: requestData[]Alignment.topRight,
                //         nip: BubbleNip.rightTop,
                //         color: Color.fromRGBO(225, 255, 199, 1.0),
                //         child:
                //             Text(requestData[index].body, textAlign: TextAlign.right),
                //       ),
                //     ],
                //   ),
                //);
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Enter your request',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  color: _isEmpty ? Colors.grey : theme.accentColor,
                  onPressed: _isEmpty
                      ? null
                      : () async {
                          await requestProvider.createRequest({
                            'customerId': requestProvider.userId,
                            'customerName': customerName,
                            'creationDate': DateTime.now(),
                            'body': _controller.text
                          });
                          _controller.text = '';
                        },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
