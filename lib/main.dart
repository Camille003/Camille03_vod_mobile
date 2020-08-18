import 'package:flutter/material.dart';

//third party
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:vidzone/screens/fifth_level_screen/account_screen.dart';

//providers
import './providers/auth_provider.dart';
import './providers/user_provider.dart';
import './providers/music_provider.dart';
import './providers/collection_provider.dart';
import './providers/history_provider.dart';
import './providers/movie_provider.dart';
import './providers/comment_provider.dart';
import './providers/download_provider.dart';
import './providers/trailer_provider.dart';
import './providers/payment_provider.dart';
//screens
import './screens/landing_screen.dart';
import './screens/login_screen.dart';
import 'screens/sign_up.dart';
import './screens/welcome_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/third_level_screen/collection_screen.dart';
import './screens/third_level_screen/history_screen.dart';
import './screens/third_level_screen/video_screen.dart';
import './screens/third_level_screen/downloads_screen.dart';
import './screens/third_level_screen/setting_screen.dart';
import './screens/fouth_level_screen/request_screen.dart';
import './screens/fouth_level_screen/privacy_screen.dart';
import './screens/fouth_level_screen/policy_screen.dart';
import './screens/fouth_level_screen/payments_screen.dart';
import './screens/fouth_level_screen/downloads_video_screen.dart';

const debug = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
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
            return AuthProvider();
          },
        ),
        ChangeNotifierProvider<MovieProvider>(
          create: (ctx) {
            return MovieProvider();
          },
        ),
        ChangeNotifierProvider<CommentsProvider>(
          create: (ctx) {
            return CommentsProvider();
          },
        ),
        ChangeNotifierProvider<TrailerProvider>(
          create: (ctx) {
            return TrailerProvider();
          },
        ),
        ChangeNotifierProvider<MusicProvider>(
          create: (ctx) {
            return MusicProvider();
          },
        ),
        ChangeNotifierProvider<DownloadProvider>(
          create: (ctx) {
            return DownloadProvider();
          },
          lazy: false,
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
            print('${authData.id} fuck');
            return userData
              ..update(
                authData.id,
              );
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, HistoryProvider>(
          create: (ctx) => HistoryProvider(''),
          update: (ctx, authData, histData) => histData
            ..update(
              authData.id,
            ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, CollectionProvider>(
          create: (ctx) => CollectionProvider(''),
          update: (ctx, authData, collectionData) => collectionData
            ..update(
              authData.id,
            ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, PaymentProvider>(
          create: (ctx) {
            print("PaymentProvider provider create");
            return PaymentProvider(
              '',
            );
          },
          update: (ctx, authData, paymentData) {
            print("paymentData provider updated");
            print('${authData.id} fuck');
            return paymentData
              ..update(
                authData.id,
              );
          },
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
                iconTheme: ThemeData.light().iconTheme.copyWith(
                      color: Colors.redAccent[700],
                    ),
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
              HistoryScreen.routeName: (ctx) => HistoryScreen(),
              CollectionScreen.routeName: (ctx) => CollectionScreen(),
              DownloadScreen.routeName: (ctx) => DownloadScreen(),
              SettingScreen.routeName: (ctx) => SettingScreen(),
              AccountScreen.routeName: (ctx) => AccountScreen(),
              DownloadVideoScreen.routeName: (ctx) => DownloadVideoScreen(),
              PaymentScreen.routeName: (ctx) => PaymentScreen(),
              PolicyScreen.routeName: (ctx) => PolicyScreen(),
              PrivacyScreen.routeName: (ctx) => PrivacyScreen(),
              RequestScreen.routeName: (ctx) => RequestScreen(),
            },
          );
        },
      ),
    );
  }
}
