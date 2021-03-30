// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../repository/auth_repository.dart';
import '../service/auth_service.dart';
import '../repository/channel_repository.dart';
import '../service/channel_service.dart';
import '../repository/lifecycle_repository.dart';
import '../repository/message_repository.dart';
import '../service/message_service.dart';
import '../repository/preference_repository.dart';
import '../repository/http_client.dart';
import '../repository/ws_client.dart';
import '../repository/preference_storage.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<GetIt> $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) async {
  final gh = GetItHelper(get, environment, environmentFilter);
  final registerDioClient = _$RegisterDioClient();
  final sharedPreferenceRegister = _$SharedPreferenceRegister();
  final registerWsClient = _$RegisterWsClient();
  gh.factory<Dio>(() => registerDioClient.createRoomClient());
  gh.factory<LifeCycleRepository>(() => LifeCycleRepository());
  gh.factoryParam<MessageRepository, String, dynamic>(
      (_userName, _) => MessageRepository(_userName));
  final resolvedSharedPreferences =
      await sharedPreferenceRegister.createSharedPref();
  gh.factory<SharedPreferences>(() => resolvedSharedPreferences);
  gh.factoryParam<WebSocketChannel, String, dynamic>(
      (userName, _) => registerWsClient.createWsClient(userName));
  gh.factory<AuthRepository>(() => AuthRepository(get<Dio>()));
  gh.factory<ChannelRepository>(() => ChannelRepository(get<Dio>()));
  gh.factory<PreferenceRepository>(
      () => PreferenceRepository(get<SharedPreferences>()));

  // Eager singletons must be registered in the right order
  gh.singleton<ChannelService>(ChannelService(get<ChannelRepository>()));
  gh.singleton<AuthService>(
      AuthService(get<AuthRepository>(), get<PreferenceRepository>()));
  gh.singleton<MessageService>(MessageService(
    get<PreferenceRepository>(),
    get<ChannelService>(),
    get<LifeCycleRepository>(),
  ));
  return get;
}

class _$RegisterDioClient extends RegisterDioClient {}

class _$SharedPreferenceRegister extends SharedPreferenceRegister {}

class _$RegisterWsClient extends RegisterWsClient {}
