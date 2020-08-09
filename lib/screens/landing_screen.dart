import 'package:flutter/material.dart';

//third party
import 'package:introduction_screen/introduction_screen.dart';

//screens
import '../screens/welcome_screen.dart';

//widgets
import '../widgets/svg_widget.dart';

class LandinScreen extends StatefulWidget {
  static const routeName = "landingScreen";
  @override
  _LandinScreenState createState() => _LandinScreenState();
}

class _LandinScreenState extends State<LandinScreen> {
  @override
  Widget build(BuildContext context) {
    var _pageIndex = 0;

    final _screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = _screenHeight * 0.9;
    final List<Map<String, String>> _imageList = const [
      {
        'caption': 'Watch at your convinience',
        'image': 'assets/images/streaming.svg',
      },
      {
        'caption': 'Download to local Storage',
        'image': 'assets/images/download.svg',
      },
      {
        'caption': 'Never miss a program',
        'image': 'assets/images/notifications.svg',
      },
    ];
    final listPagesViewModel = _imageList
        .map(
          (e) => PageViewModel(
            title: '',
            body: e['caption'],
            image: Center(
              child: SvgWidget(
                e['image'],
                height: imageHeight,
              ),
            ),
            decoration: const PageDecoration(
              imageFlex: 3,
              imagePadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              descriptionPadding: const EdgeInsets.all(0),
              footerPadding: const EdgeInsets.all(0),
              titleTextStyle: TextStyle(color: Colors.orange),
              bodyTextStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
              ),
            ),
          ),
        )
        .toList();
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: IntroductionScreen(
          initialPage: _pageIndex,
          pages: listPagesViewModel,
          onDone: () {
            Navigator.of(context).pushNamed(
              WelcomeScreen.routeName,
            );
          },
          showSkipButton: true,
          skip: const Text("Skip"),
          next: const Text("Next"),
          done: const Text(
            "Done",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(10.0, 10.0),
            activeColor: theme.accentColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(
              horizontal: 3.0,
            ),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
