import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class LifeCycleRepository with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  AppLifecycleState _notification;

  void subscribe() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('______________________________$state');
    // setState(() { _notification = state; });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return new Text('Last notification: $_notification');
  // }
}
