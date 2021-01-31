import 'package:injectable/injectable.dart';

import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class SharedPreferenceRegister {
  @preResolve
  Future<SharedPreferences> createSharedPref() {
    return SharedPreferences.getInstance();
  }
}
