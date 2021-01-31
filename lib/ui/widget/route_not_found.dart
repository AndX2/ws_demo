import 'package:flutter/material.dart';

/// Экран ошибки маршрутизации
class RouteNotFoundWidget extends StatelessWidget {
  final RouteSettings settings;
  const RouteNotFoundWidget({Key key, this.settings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Ошибка маршрутизации для ${settings.name}'),
      ),
    );
  }
}
