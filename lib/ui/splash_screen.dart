import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';

import 'package:ws_demo/ui/widget/screen_back.dart';
import 'package:ws_demo/util/const.dart';

/// Время до закрытия Splash экрана
const _splashDelay = Duration(seconds: 3);

/// Экран Splash
class SplashScreenWidget extends CoreMwwmWidget {
  SplashScreenWidget({
    Key key,
  }) : super(
          widgetModelBuilder: (context) => SplashScreenModel(
            WidgetModelDependencies(),
            Navigator.of(context),
          ),
        );

  @override
  State<StatefulWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends WidgetState<SplashScreenModel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future<bool>.value(false),
      child: ScreenBackWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: kIsWeb
                ? Image.network(ImageRes.logo)
                : SvgPicture.asset(ImageRes.logo, width: 200.0),
          ),
        ),
      ),
    );
  }
}

/// [SplashScreenModel] для [SplashScreen]
class SplashScreenModel extends WidgetModel {
  final NavigatorState _rootNavigator;

  SplashScreenModel(
    WidgetModelDependencies baseDependencies,
    this._rootNavigator,
  ) : super(baseDependencies);

  @override
  void onLoad() {
    super.onLoad();
    Timer(
      _splashDelay,
      () {
        _rootNavigator.pop();
      },
    );
  }

  @override
  void onBind() {
    super.onBind();
  }
}
