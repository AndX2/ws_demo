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

  bool get isAuthorized => tokenPair != null;
  bool get accessIsExpired => expiresAt == null || expiresAt.isBefore(DateTime.now());

  Future<void> login(String name) async {
    Profile newProfile = await _authRepository.signIn(name).catchError((_) {});
    newProfile ??= await _authRepository.signUp(name);

    tokenPair = newProfile.tokenPair;
    profile = newProfile;
    expiresAt = DateTime.now().add(_accessLifeTime);
    setProfile(profile);
    notifyListeners();
  }

  Future<void> refreshToken({String refresh}) async {
    final token = await _authRepository.refresh(refresh ?? tokenPair.refresh);

    profile = getProfile();
    setProfile(profile.copyWith(tokenPair: token));
    tokenPair = token;
    expiresAt = DateTime.now().add(_accessLifeTime);
  }

  Future<void> tryReauth() async {
    final profile = getProfile();
    if (profile != null) {
      await refreshToken(refresh: profile.tokenPair.refresh).catchError((_) => login(profile.name));
    }
  }

  Profile getProfile() {
    return getIt.get<PreferenceRepository>().profile;
  }

  Future<void> setProfile(Profile profile) async {
    await _preferenceRepository.saveProfile(profile);
  }
}
