import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/token_pair.dart';
import 'package:ws_demo/repository/response/profile_response.dart';
import 'package:ws_demo/util/const.dart';

/// Репозиторий аутентификации
@injectable
class AuthRepository {
  AuthRepository(this._client);

  final Dio _client;

  /// Залогиниться
  Future<Profile> signIn(String name) {
    return _client.post(
      Url.signIn,
      data: {"name": name},
    ).then(_fromResponse);
  }

  /// Зарегистрироваться
  Future<Profile> signUp(String name) {
    return _client.post(
      Url.signUp,
      data: {"name": name},
    ).then(_fromResponse);
  }

  /// Обновить токен
  Future<TokenPair> refresh(String refreshToken) {
    return _client
        .post(
      Url.refresh,
      options: Options(headers: {'authorization': refreshToken}),
    )
        .then((response) {
      final access = response.headers['authorization'].first;
      final refresh = response.headers['refresh'].first;
      return TokenPair(access, refresh);
    });
  }

  Profile _fromResponse(Response response) {
    final profile = ProfileResponse.fromJson(response.data).transform();
    final access = response.headers['authorization'].first;
    final refresh = response.headers['refresh'].first;
    return profile.copyWith(tokenPair: TokenPair(access, refresh));
  }
}
