import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/emums/account_type_enum.dart';

//providers
import '../../providers/payment_provider.dart';
import '../../providers/user_provider.dart';

//models
import '../../models/payment_model.dart';

//widgets
import '../../widgets/main_button_widget.dart';
import '../../widgets/no_content_widget.dart';
import '../../widgets/payment_widget.dart';
import '../../widgets/waiting_widget.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = "paymentScreen";

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<PaymentModel> payments;
  PaymentProvider _provider;
  UserProvider _userProd;
  bool _isInit;
  String _userName;

  //payments
  bool _basic = false;
  bool _premium = false;

  final double _basicPrice = 3500;
  final double _premiumPrcie = 7000;

  @override
  void initState() {
    setState(() {
      _isInit = true;
    });
    _provider = Provider.of<PaymentProvider>(context, listen: false);
    _provider.fetchandSetPayment().then((value) {
      setState(() {
        _isInit = false;
        payments = _provider.payments;
      });
    });
    _userProd = Provider.of<UserProvider>(context, listen: false);
    _userProd.fetchAndSetUser().then((value) {
      _userName = _userProd.user.name;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _isInit
          ? Center(
              child: WaitingWidget(),
            )
          : Column(
              children: [
                payments.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(
                          10,
                        ),
                        child: Center(
                          child: NoContentWidget(
                            'No payments made',
                          ),
                        ),
                      )
                    : Expanded(
                        child: Consumer<PaymentProvider>(
                          builder: (ctx, payData, child) {
                            return ListView.builder(
                              itemBuilder: (ctx, index) {
                                return PaymentWidget(
                                  id: payData.payments[index].id,
                                  price: payData.payments[index].price,
                                  accountType:
                                      payData.payments[index].accountType,
                                  dateTime:
                                      payData.payments[index].creationDate,
                                );
                              },
                            );
                          },
                        ),
                      ),
                SizedBox(
                  width: double.infinity,
                  child: MainButtonWidget(
                    label: 'Pay off',
                    color: theme.accentColor,
                    onTap: () {
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: MaterialLocalizations.of(context)
                              .modalBarrierDismissLabel,
                          barrierColor: Colors.black45,
                          transitionDuration: const Duration(milliseconds: 200),
                          pageBuilder: (BuildContext buildContext,
                              Animation animation,
                              Animation secondaryAnimation) {
                            return Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width - 10,
                                height: MediaQuery.of(context).size.height - 80,
                                padding: EdgeInsets.all(20),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    CheckboxListTile(
                                      activeColor: theme.accentColor,
                                      controlAffinity:
                                          ListTileControlAffinity.trailing,
                                      secondary: Icon(Icons.money_off),
                                      value: _basic,
                                      onChanged: (bool option) {
                                        setState(() {
                                          _basic = option;
                                          _premium = option;
                                        });
                                      },
                                      title: Text(
                                        'Basic',
                                      ),
                                    ),
                                    CheckboxListTile(
                                      secondary: Icon(Icons.money_off),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: _premium,
                                      onChanged: (bool option) {
                                        setState(() {
                                          _premium = option;
                                          _basic = !option;
                                        });
                                      },
                                      activeColor: theme.accentColor,
                                      title: Text(
                                        'Premium',
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: (_basic || _premium)
                                          ? () async {
                                              final accountType = _basic
                                                  ? AccountType.Basic
                                                  : AccountType.Premium;
                                              final paymentDate =
                                                  DateTime.now();
                                                  
                                              await _provider.makePayment({
                                                'customerName': _userName,
                                                'creationDate': DateTime.now(),
                                                'price': _basic
                                                    ? _basicPrice
                                                    : _premiumPrcie,
                                                'accountType': _basic
                                                    ? AccountType.Basic
                                                    : AccountType.Premium
                                              });
                                              await _userProd.user.makePayment(
                                                accountType,
                                                paymentDate,
                                              );
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      child: Text(
                                        "Save",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: const Color(0xFF1BC0C5),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    textStyle: theme.textTheme.bodyText2,
                  ),
                ),
              ],
            ),
    );
  }
}
