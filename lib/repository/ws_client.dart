import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:ws_demo/util/const.dart' as consts;

/// DI фабрики различных Ws клиентов
@module
abstract class RegisterWsClient {
  /// Клиент доступа к сообщениям
  WebSocketChannel createWsClient(@factoryParam String userName) {
    final url = consts.Url.messageChannel;
    // if (kIsWeb) return HtmlWebSocketChannel.connect(url);
    return IOWebSocketChannel.connect(url);
  }
}
