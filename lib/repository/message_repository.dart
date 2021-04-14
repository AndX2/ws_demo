import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/channel.dart';
import 'package:ws_demo/domain/socket_message.dart';
import 'package:ws_demo/repository/auth_interceptor.dart';
import 'package:ws_demo/repository/request/message_request.dart';
import 'package:ws_demo/repository/response/message_response.dart';

/// Репозиторий сообщений
/// открытие ws канала происходит при создании инстанса репозитория
/// [close()] закрывает канал
@injectable
class MessageRepository {
  MessageRepository(this._authInterceptor) : _channel = getIt.get<WebSocketChannel>();

  final WebSocketChannel _channel;
  final AuthInterceptor _authInterceptor;
  final heartbeatStream = StreamController<void>.broadcast();

  /// Поток сообщений сервера
  Stream<SocketMessage> get stream {
    return _channel.stream.where((row) {
      print(row);
      heartbeatStream.add(null);
      if (row is List<int> && row.length == 1) {
        if (row.first == 0xA) _onPong();
        if (row.first == 0x9) _onPing();
        return false;
      }
      return true;
    }).map<SocketMessage>((row) {
      return SocketMessageResponse.fromJson(row).transform();
    });
  }

  void _onPing() {
    _channel.sink.add([0xA]);
  }

  void _onPong() {}

  /// Отправить сообщение
  Future<void> send(
    Channel channel,
    String body,
    String id,
  ) async {
    final messageRequest = MessageRequest(channel, body, id);
    final msg = await _authInterceptor.onSendMessage(messageRequest.toJson);
    _channel.sink.add(jsonEncode(msg));
  }

  void ping() => _channel.sink.add([0x9]);

  /// Закрыть канал
  void close() {
    heartbeatStream.close();
    _channel.sink.close();
  }
}
