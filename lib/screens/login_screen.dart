import 'package:flutter/material.dart';

//third parties
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart'
    show isEmail, isLength, isAlphanumeric;

//provider
import '../providers/auth_provider.dart';

//constatnts
import '../constants/styles.dart';

//widgets
import '../widgets/input_widgets.dart';
import '../widgets/main_button_widget.dart';
import '../widgets/svg_widget.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "loginScreen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FocusNode _passwordFocusNode = FocusNode();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  AuthProvider authProvider;

  bool _isLoading = false;

  Map<String, String> userData = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }

  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formState.currentState.validate()) {
      return;
    }
    formState.currentState.save();

    try {
      setState(() {
        _isLoading = true;
      });
      //await authProvider.signIn(userData['email'], userData['password']);
      setState(() {
        _isLoading = false;
      });
      formState.currentState.reset();
    } catch (e) {} finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    final textTheme = theme.textTheme;
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FadeIn(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: SvgWidget(
                            'assets/images/login.svg',
                            height: screenHeight * 0.45,
                          ),
                        ),
                      ),
                      Form(
                        key: formState,
                        autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            InputWidget(
                              action: TextInputAction.next,
                              onSaved: (String string) {
                                userData['email'] = string;
                              },
                              validator: (string) {
                                string = string.trim();
                                if (!isEmail(string)) {
                                  return 'Invalid Email';
                                }

                                return null;
                              },
                              showText: false,
                              focusNode: null,
                              onSubmitted: (string) {
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                              labelText: 'Email',
                              color: theme.accentColor,
                              styles: basicInputStyle.copyWith(
                                suffixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            InputWidget(
                              action: TextInputAction.done,
                              onSaved: (String string) {
                                userData['password'] = string;
                              },
                              showText: true,
                              focusNode: _passwordFocusNode,
                              labelText: 'Password',
                              styles: basicInputStyle.copyWith(
                                suffixIcon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.black45,
                                ),
                              ),
                              validator: (String string) {
                                string = string.trim();
                                if (!isLength(string, 8) ||
                                    !isAlphanumeric(string)) {
                                  return 'At least 8 characters long';
                                }

                                return null;
                              },
                              color: theme.accentColor,
                              onSubmitted: (string) {
                                submit();
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      MainButtonWidget(
                        icon: Icons.person_add,
                        color: theme.accentColor,
                        textStyle: textTheme.headline1,
                        onTap: () {
                          submit();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
