import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/domain/socket_message.dart';
import 'package:ws_demo/repository/request/message_request.dart';
import 'package:ws_demo/repository/response/message_response.dart';

/// Репозиторий сообщений
/// открытие ws канала происходит при создании инстанса репозитория
/// [close()] закрывает канал
@injectable
class MessageRepository {
  // ignore: unused_field
  final String _userName;
  final WebSocketChannel _channel;

  MessageRepository(@factoryParam this._userName) : _channel = getIt.get<WebSocketChannel>(param1: _userName);

  /// Поток сообщений сервера
  Stream<SocketMessage> get stream {
    return _channel.stream.map<SocketMessage>(
      (row) => SocketMessageResponse.fromJson(row).transform(),
    );
  }

  /// Отправить сообщение
  void send(Room room, String text, String id) {
    final messageRequest = MessageRequest(room, text, id);
    final msg = messageRequest.toJson;
    _channel.sink.add(msg);
  }

  /// Закрыть канал
  void close() {
    _channel.sink.close();
  }
}
