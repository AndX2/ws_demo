import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

/// Репозиторий состояния жижненного цикла приложения
@injectable
class LifeCycleRepository with WidgetsBindingObserver, ChangeNotifier {
  AppLifecycleState _appState;

  AppLifecycleState get state => _appState;

  void subscribe() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appState = state;
    notifyListeners();
  }
}
