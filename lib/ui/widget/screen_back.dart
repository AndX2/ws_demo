import 'package:flutter/material.dart';
import 'package:ws_demo/util/style.dart';

class ScreenBackWidget extends StatelessWidget {
  final Widget child;
  const ScreenBackWidget({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, .5, 1.0],
          colors: [
            ColorRes.backGradientBegin,
            ColorRes.backGradientCenter,
            ColorRes.backGradientEnd,
          ],
        ),
      ),
      child: child ?? Container(),
    );
  }
}
