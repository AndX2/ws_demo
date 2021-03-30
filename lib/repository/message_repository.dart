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

  MessageRepository(
    @factoryParam this._userName,
  ) : _channel = getIt.get<WebSocketChannel>(param1: _userName);

  /// Поток сообщений сервера
  Stream<SocketMessage> get stream {
    return _channel.stream.where((row) {
      if (row is String && row.length == 1) {
        print(row.codeUnits);
        if (row.codeUnits.first == 0xA) _onPong();
        if (row.codeUnits.first == 0x9) _onPing();
        return false;
      }
      return true;
    }).map<SocketMessage>((row) => SocketMessageResponse.fromJson(row).transform());
  }

  void _onPing() {
    print('ping');
  }

  void _onPong() {
    print('pong');
  }

  // if (ping is String) {
  //     print(ping.length);
  //     print(ping.codeUnits);
  //   }

  /// Отправить сообщение
  void send(Channel room, String text, String id) {
    final messageRequest = MessageRequest(room, text, id);
    final msg = messageRequest.toJson;
    _channel.sink.add(msg);
  }

  void ping() {}
  // void ping() => _channel.sink.add({"ping": true});

  /// Закрыть канал
  void close() {
    _channel.sink.close();
  }
}
