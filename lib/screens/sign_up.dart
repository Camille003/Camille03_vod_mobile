import 'package:flutter/material.dart';

//third parties
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart'
    show isLength, isAlphanumeric;
import 'package:vidzone/providers/auth_provider.dart';


//widgets
import '../widgets/main_button_widget.dart';
import '../widgets/svg_widget.dart';

class SigUpScreen extends StatefulWidget {
  static const routeName = "signUp";
  @override
  _SigUpScreenState createState() => _SigUpScreenState();
}

class _SigUpScreenState extends State<SigUpScreen> {
  //GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _passwordConroller = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  AuthProvider authProvider;
  Map<String, String> _userData = {
    'password': '',
  };
  _cleanData() {
    _passwordConroller.text = '';
  }

  bool _isStrongPassword() {
    var password = _passwordConroller.text;
    password = password.trim();
  

    if (!isLength(password, 8) || !isAlphanumeric(password)) {
      setState(() {
        _errorMessage = 'Password not strong enough';
      });

      return false;
    }

    _userData['password'] = password;
    return true;
  }

  Future<void> _signUp() async {
    try {
      if (!_isStrongPassword()) {
        return null;
      }
      setState(() {
        _isLoading = true;
      });
      await authProvider.signUp(_userData['password']);

      setState(() {
        _isLoading = false;
      });
      _cleanData();
    
      // Navigator.pushReplacementNamed(
      //   context,
      //   HomeScreen.routeName,
      // );
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(
            _errorMessage,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
    });
  }

  void dispose() {
    // Clean controller.
    _passwordConroller.dispose();
    super.dispose();
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
                            'assets/images/signup.svg',
                            height: screenHeight * 0.45,
                          ),
                        ),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          errorText: _errorMessage.isEmpty ? '' : _errorMessage,
                          labelText: 'Password',
                          hintMaxLines: 2,
                          hintText:
                              'At least 8 characrters and alphanumneric keys only.\nNo special Characters',
                          labelStyle: TextStyle(
                            color: theme.accentColor,
                          ),
                          suffixIcon: Icon(
                            Icons.vpn_key,
                            color: Colors.black45,
                          ),
                        ),
                        controller: _passwordConroller,
                        onSubmitted: (string) {
                          //submit();
                        },
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      MainButtonWidget(
                        icon: Icons.person_add,
                        color: theme.accentColor,
                        textStyle: textTheme.headline1,
                        onTap: _signUp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
