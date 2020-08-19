import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/emums/account_type_enum.dart';
import 'package:vidzone/helpers/app_bar_helper.dart';

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
  bool _isLoading = true;
  String _userName;

  //payments
  bool _basic = false;
  bool _premium = false;

  final double _basicPrice = 3500;
  final double _premiumPrcie = 7000;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    _provider = Provider.of<PaymentProvider>(context, listen: false);
    _provider.fetchandSetPayment().then((value) {
      setState(() {
        _isLoading = false;
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
      appBar: buildAppBar(context, 'Payments'),
      body: _isLoading
          ? Center(
              child: WaitingWidget(),
            )
          : Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Column(
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
                                itemCount: payData.payments.length,
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ), //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: StatefulBuilder(
                                    builder: (context, _setState) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CheckboxListTile(
                                          activeColor: theme.accentColor,
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          secondary: Icon(Icons.money_off),
                                          value: _basic,
                                          onChanged: (bool option) {
                                          
                                            _setState(() {
                                              _basic = option;
                                              _premium = !option;
                                            });
                                          },
                                          title: Text(
                                            'Basic',
                                          ),
                                        ),
                                        CheckboxListTile(
                                          activeColor: theme.accentColor,
                                          secondary: Icon(Icons.money_off),
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          value: _premium,
                                          onChanged: (bool option) {
                                            _setState(() {
                                              _premium = option;
                                              _basic = !option;
                                            });
                                          },
                                          title: Text(
                                            'Premium',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: MainButtonWidget(
                                            label: 'Pay off',
                                            textStyle:
                                                theme.textTheme.bodyText1,
                                            onTap: (_basic || _premium)
                                                ? () async {
                                                    final accountType = _basic
                                                        ? AccountType.Basic
                                                        : AccountType.Premium;
                                                    final paymentDate =
                                                        DateTime.now();

                                                    await _provider
                                                        .makePayment({
                                                      'customerName': _userName,
                                                      'creationDate':
                                                          paymentDate,
                                                      'price': _basic
                                                          ? _basicPrice
                                                          : _premiumPrcie,
                                                      'accountType': accountType
                                                    });
                                                    await _userProd.user
                                                        .makePayment(
                                                      accountType,
                                                      paymentDate,
                                                    );
                                                    Navigator.of(context).pop();
                                                  }
                                                : null,
                                            color: theme.accentColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );

                        //
                      },
                      textStyle: theme.textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
