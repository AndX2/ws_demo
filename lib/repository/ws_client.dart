import 'package:injectable/injectable.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ws_demo/util/const.dart' as consts;
import 'package:ws_demo/repository/ws_conditional_import.dart/facade.dart'
    if (dart.library.html) 'package:ws_demo/repository/ws_conditional_import.dart/web_impl.dart'
    if (dart.library.io) 'package:ws_demo/repository/ws_conditional_import.dart/io_impl.dart';

/// DI модуль Ws клиентов
@module
abstract class RegisterWsClient {
  /// Клиент доступа к сообщениям
  WebSocketChannel createWsClient() {
    final url = consts.Url.messageChannel;
    return getPlatformSocketChannel(url);
  }
}
