import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:vidzone/providers/movie_provider.dart';
import 'package:vidzone/screens/third_level_screen/video_screen.dart';

//providers
import './providers/auth_provider.dart';
import './providers/user_provider.dart';
import './providers/music_provider.dart';
import './providers/trailer_provider.dart';

//screens
import './screens/landing_screen.dart';
import './screens/login_screen.dart';
import './screens/sign_up.dart';
import './screens/welcome_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';

void main() {
  runApp(Vidzone());
}

class Vidzone extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (ctx) {
            print("creating auth provider");
            return AuthProvider();
          },
        ),
         ChangeNotifierProvider<MovieProvider>(
          create: (ctx) {
            print("Movie provider");
            return MovieProvider();
          },
        ),
        ChangeNotifierProvider<TrailerProvider>(
          create: (ctx) {
            print("trailer provider");
            return TrailerProvider();
          },
        ),
        ChangeNotifierProvider<MusicProvider>(
          create: (ctx) {
            print("music provider");
            return MusicProvider();
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (ctx) {
            print("User provider create");
            return UserProvider(
              '',
            );
          },
          update: (ctx, authData, userData) {
            print("User provider updated");
            print('${userData.id} fuck');
            return userData
              ..update(
                authData.id,
              );
          },
          lazy: true,
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, child) {
          print(auth.isLoggedIn);
          return MaterialApp(
            title: 'Vidzone',
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.white,
              appBarTheme: AppBarTheme(
                textTheme: TextTheme(
                  headline1: TextStyle(
                    //fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.redAccent[700],
                  ),
                ),
              ),
              textTheme: ThemeData.light().textTheme.copyWith(
                    bodyText1: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    bodyText2: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                    headline1: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                    ),
                  ),
              accentColor: Colors.redAccent[700],
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: auth.isLoggedIn == true
                ? HomeScreen()
                : FutureBuilder(
                    future: Future.delayed(Duration(seconds: 3), () {
                      return auth.autoLogin();
                    }),
                    builder: (ctx, snapShot) =>
                        snapShot.connectionState == ConnectionState.waiting
                            ? WelcomeScreen()
                            : snapShot.data == "login"
                                ? HomeScreen()
                                : SigUpScreen(),
                  ),
            routes: {
              LandinScreen.routeName: (ctx) => LandinScreen(),
              WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
              LoginScreen.routeName: (ctx) => LoginScreen(),
              SigUpScreen.routeName: (ctx) => SigUpScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              SplashScreen.routeName: (ctx) => SplashScreen(),
              VideoScreen.routeName: (ctx) => VideoScreen(),
            },
          );
        },
      ),
    );
  }
}
