import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ws_demo/ui/channel_screen.dart';
import 'package:ws_demo/ui/main_screen.dart';
import 'package:ws_demo/ui/splash_screen.dart';
import 'package:ws_demo/ui/widget/route_not_found.dart';

/// Маршруты приложения
class Routes {
  /// Маршруты
  static const String main = '/';
  static const String splash = '/splash';
  static const String room = 'room';

  /// Параметры
  static const String roomName = 'roomName';
}

/// Делегат [MaterialApp] для управления навигацией
class RouterDelegate {
  Route<dynamic> generateRootRoute(RouteSettings settings) {
    final pathSegments = settings.name.split('/');
    final rootPathSegment = pathSegments.first.isNotEmpty ? pathSegments.first : settings.name;

    final params = (settings.arguments ?? Map()) as Map<dynamic, dynamic>;

    switch (rootPathSegment) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => SplashScreenWidget());
        break;
      case Routes.main:
        return CupertinoPageRoute(builder: (context) => MainScreenWidget());
        break;
      case Routes.room:
        return CupertinoPageRoute(
            builder: (context) => ChannelScreenWidget(roomName: params[Routes.roomName]));
        break;
      default:
        return CupertinoPageRoute(builder: (context) => RouteNotFoundWidget(settings: settings));
    }
  }
}
