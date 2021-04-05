import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Action;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mwwm/mwwm.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/router.dart';
import 'package:ws_demo/service/auth_service.dart';

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
  SplashScreenModel(
    WidgetModelDependencies baseDependencies,
    this._rootNavigator,
  )   : _authService = getIt<AuthService>(),
        super(baseDependencies);

  final AuthService _authService;
  final NavigatorState _rootNavigator;

  @override
  void onLoad() {
    super.onLoad();
    Future.wait([_authService.tryReauth(), Future.delayed(_splashDelay)])
        .timeout(_splashDelay)
        .whenComplete(() => _rootNavigator.pushReplacementNamed(Routes.main));
  }

  @override
  void onBind() {
    super.onBind();
  }
}
