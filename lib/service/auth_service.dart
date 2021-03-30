import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/token_pair.dart';
import 'package:ws_demo/repository/auth_repository.dart';
import 'package:ws_demo/repository/preference_repository.dart';

const _accessLifeTime = Duration(minutes: 20);

/// Сервис авторизации
@singleton
class AuthService extends ChangeNotifier {
  AuthService(
    this._authRepository,
    this._preferenceRepository,
  );

  final AuthRepository _authRepository;
  final PreferenceRepository _preferenceRepository;

  TokenPair tokenPair;
  Profile profile;
  DateTime expiresAt;

  Future<void> login(String name) async {
    Profile profile = await _authRepository.signIn(name).catchError((_) {});
    if (profile == null) profile = await _authRepository.signUp(name);

    tokenPair = profile.tokenPair;
    profile = profile;
    expiresAt = DateTime.now().add(_accessLifeTime);
  }

  Future<void> refreshToken() async {
    final newTokenPair = await _authRepository.refresh(tokenPair.refresh);

    tokenPair = newTokenPair;
    profile = profile.copyWith(tokenPair: tokenPair);
    expiresAt = DateTime.now().add(_accessLifeTime);
  }

  Profile getProfile() {
    return getIt.get<PreferenceRepository>().profile;
  }

  Future<void> setProfile(Profile profile) async {
    await _preferenceRepository.saveProfile(profile);
  }
}
