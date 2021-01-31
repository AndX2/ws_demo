import 'package:flutter/material.dart' hide RouterDelegate;
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/router.dart';
import 'package:ws_demo/util/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routerDelegate = RouterDelegate();
    return MaterialApp(
      title: StringRes.appTitle,
      initialRoute: Routes.splash,
      onGenerateRoute: routerDelegate.generateRootRoute,
    );
  }
}
