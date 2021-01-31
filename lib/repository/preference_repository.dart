import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ws_demo/domain/profile.dart';

const _profileKey = 'profileKey';

/// Локальное хранилище данных
@injectable
class PreferenceRepository {
  final SharedPreferences _preferences;

  PreferenceRepository(this._preferences);

  /// Сохранить профиль пользователя
  Future<bool> saveProfile(Profile profile) => _preferences.setString(_profileKey, jsonEncode(profile.toJson));

  /// Получить профиль пользователя
  Profile get profile => Profile.fromJson(_preferences.getString(_profileKey));
}
