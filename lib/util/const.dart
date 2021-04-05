import 'package:ws_demo/domain/room.dart';

/// Паттерны экранирования символов в URL (для имени пользователя)
const Map<String, String> _pathSegmentReplacement = {
  " ": "%20",
  "!": "%21",
  "\\": "%5C",
  '"': "%22",
  "&": "%26",
  "'": "%27",
  "*": "%2A",
  "+": "%2B",
  "-": "%2D",
  ".": "%2E",
  "/": "%2F",
  "_": "%5F",
  ",": "%2C",
  ":": "%3A",
  ";": "%3B",
  "=": "%3D",
  "<": "%3C",
  ">": "%3E",
  "?": "%3F",
  "(": "%28",
  ")": "%29",
  "`": "%29",
};

/// Статические URL используемые приложением (динамические в [RemoteConfigFactory])
class Url {
  static const String httpBaseUrl = 'https://dartservice.ru';
  static const String wsBaseUrl = 'wss://dartservice.ru/messenger/ws';

  /// История последних сообщений в канале
  static String channelHistory(Channel channel) => '/messenger/channel/${channel.name}';

  /// Список всех каналов
  static const String roomList = '/messenger/channel';

  /// WS канал сообщений
  static const String messageChannel = wsBaseUrl;

  /// Эндпойнт авторизации
  static const String signIn = '/auth/signin';

  /// Эндпойнт регистрации
  static const String signUp = '/auth/signup';

  /// Эндпойнт обновления токенов
  static const String refresh = '/auth/refresh';

  /// Экранирование недопустимых символов в полях, используемых в Url
  static String cleanUrlPathSegment(String pathSegment) {
    _pathSegmentReplacement.entries.forEach(
      (pattern) => pathSegment = pathSegment.replaceAll(pattern.key, pattern.value),
    );
    return pathSegment;
  }
}

//TODO: заменить на LocalizationDelegate
/// Строковые константы
class StringRes {
  static const appTitle = 'КиберЧАТ';
}

/// Image assets
class ImageRes {
  static const logo = 'asset/image/logo.svg';
}
