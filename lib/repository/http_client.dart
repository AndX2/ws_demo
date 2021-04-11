import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ws_demo/repository/auth_interceptor.dart';
import 'package:ws_demo/util/const.dart' as consts;

/// DI фабрики различных HTTP клиентов
@module
abstract class RegisterDioClient {
  /// Клиент доступа к информации о комнатах (каналах)
  Dio createRoomClient() {
    final options = BaseOptions(
      baseUrl: consts.Url.httpBaseUrl,
      connectTimeout: 10000,
      sendTimeout: 10000,
    );
    return Dio(options)
      ..interceptors.addAll([
        AuthInterceptor(),
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
  }
}
