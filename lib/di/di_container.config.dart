// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/auth_interceptor.dart';
import '../repository/auth_repository.dart';
import '../service/auth_service.dart';
import '../repository/preference_repository.dart';
import '../repository/preference_storage.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<GetIt> $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) async {
  final gh = GetItHelper(get, environment, environmentFilter);
  final sharedPreferenceRegister = _$SharedPreferenceRegister();
  gh.factory<AuthInterceptor>(() => AuthInterceptor());
  gh.factory<AuthRepository>(() => AuthRepository(get<Dio>()));
  final resolvedSharedPreferences =
      await sharedPreferenceRegister.createSharedPref();
  gh.factory<SharedPreferences>(() => resolvedSharedPreferences);
  gh.factory<PreferenceRepository>(
      () => PreferenceRepository(get<SharedPreferences>()));

  // Eager singletons must be registered in the right order
  gh.singleton<AuthService>(
      AuthService(get<AuthRepository>(), get<PreferenceRepository>()));
  return get;
}

class _$SharedPreferenceRegister extends SharedPreferenceRegister {}
