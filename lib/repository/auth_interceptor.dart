import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/service/auth_service.dart';
import 'package:ws_demo/util/const.dart';

/// Перехватчик HTTP запросов для добавления заголовка авторизации
@injectable
class AuthInterceptor extends Interceptor {
  /// Подстановка в HTTP запросы токена доступа
  @override
  Future onRequest(RequestOptions options) async {
    /// В запросе обновления токена заголовок авторизации добавляется в сервисе
    if (options.path != Url.refresh) options.headers['Authorization'] = await _accessHeader;
    return super.onRequest(options);
  }

  /// Подстановка в фрейм отправки сообщения сведений о пользователе и его токена доступа
  /// ```json
  ///   {
  ///      "type": "message",
  ///      "headers": {
  ///        "channel": "some channel",
  ///        "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9"
  ///      },
  ///      "payload": {
  ///        "publicId": "ad56026f-f383-4d52-b9c3-0d1b75a32c0d",
  ///        "ownerId": "2d41c742-8436-4eb7-a458-4a2ab80fb7e6",
  ///        "ownerName": "some user",
  ///        "created": "2021-03-22T03:44:34.318707",
  ///        "assets": [],
  ///        "body":
  ///            "При помощи C вы легко можете выстрелить себе в ногу. При помощи C++ это сделать сложнее,       но если это произойдёт, вам оторвёт всю ногу целиком. Bjarne Stroustrup"
  ///      }
  ///    }
  /// ```
  ///
  Future<Map<String, dynamic>> onSendMessage(Map<String, dynamic> messageData) async {
    final profile = getIt<AuthService>().profile;
    messageData['headers']['access'] = await _accessHeader;

    messageData['payload']['ownerId'] = profile.id;
    messageData['payload']['ownerName'] = profile.name;
    return messageData;
  }

  Future<String> get _accessHeader async {
    final authService = getIt<AuthService>();
    if (authService.isAuthorized) {
      if (authService.accessIsExpired) await authService.refreshToken();
      return authService.tokenPair.access;
    }
    return null;
  }
}
