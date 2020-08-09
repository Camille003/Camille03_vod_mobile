import 'package:flutter/material.dart';

//third party package
import 'package:flutter_svg/flutter_svg.dart';

//widgets
import './waiting_widget.dart';

class SvgWidget extends StatelessWidget {
  final String assetName;
  final double height;
  final BoxFit  fit ;

  const SvgWidget(
    this.assetName, {
    this.height = 300,
    this.fit=  BoxFit.contain
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: SvgPicture.asset(
        assetName,
        fit: BoxFit.contain,
        width: double.infinity,
        height: height,
        placeholderBuilder: (context) => Center(
          child: WaitingWidget(),
        ),
      ),
    );
  }
}
