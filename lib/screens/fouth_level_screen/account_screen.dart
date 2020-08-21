import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

//enums
import '../../emums/account_type_enum.dart';

//providers
import '../../providers/user_provider.dart';

//widgets
import '../../widgets/waiting_widget.dart';

//screens
import '../fifth_level_screen/account_detail_screen.dart';

//helpers
import '../../helpers/app_bar_helper.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = "accountScreen";
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserProvider _provider;
  bool _isLoading;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    _provider = Provider.of<UserProvider>(context, listen: false);
    _provider.fetchAndSetUser().then(
          (value) => setState(
            () {
              _isLoading = false;
            },
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, "Account", center: true),
      body: _isLoading
          ? Center(
              child: WaitingWidget(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      shape: CircleBorder(),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            _provider.user.imageUrl,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          _provider.user.name,
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          _provider.user.email,
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          '${_provider.user.accountType == AccountType.Premium ? "Premium" : "Basic"}',
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: Text(
                          'Next payment ${DateFormat.yMMMd().format(_provider.user.nextPaymentDate)}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
