import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/domain/socket_message.dart';
import 'package:ws_demo/repository/auth_interceptor.dart';
import 'package:ws_demo/repository/request/message_request.dart';
import 'package:ws_demo/repository/response/message_response.dart';

/// Количество пропущенных heartbeat означающее разрыв соединения
const _tolerance = 2;

/// Периодичности heartbeat сообщений
const _pingTimeout = Duration(seconds: 10);

/// Репозиторий сообщений
/// открытие ws канала происходит при создании инстанса репозитория
/// [close()] закрывает канал
@injectable
class MessageRepository {
  MessageRepository(this._authInterceptor) : _channel = getIt.get<WebSocketChannel>();

  final WebSocketChannel _channel;
  final AuthInterceptor _authInterceptor;

  /// Поток сообщений сервера
  Stream<SocketMessage> get stream {
    return _channel.stream.where((row) {
      //"{"type":"closed","payload":"FormatException: Тип фрейма не распознан"}"
      if (row is String && row.length == 1) {
        print(row.codeUnits);
        if (row.codeUnits.first == 0xA) _onPong();
        if (row.codeUnits.first == 0x9) _onPing();
        return false;
      }
      return true;
    }).map<SocketMessage>((row) {
      return SocketMessageResponse.fromJson(row).transform();
    });
  }

  void _onPing() {
    print('ping');
  }

  void _onPong() {
    // _channel.sink.add([0xA]);
  }

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
    _channel.sink.close();
  }
}
