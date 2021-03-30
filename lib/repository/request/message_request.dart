import 'package:flutter/foundation.dart';

import 'package:ws_demo/domain/room.dart';

/// Объект сообщения пользователя для ws канала
/// ```json
///   {
///      "room": "string", // название комнаты. Если такой комнаты нет, она будет создана
///      "text": "string", // текст сообщения
///      "id": "string" // необязательный идентификатор, можно назначить на клиенте, чтобы получить подтверждение получения сообщения сервером
///   }
/// ```
@immutable
class MessageRequest {
  final Channel room;
  final String text;
  final String id;

  MessageRequest(this.room, this.text, this.id);

  String get toJson => '''{
  "room": "${room.name}", 
  "text": "$text", 
  "id": "$id" 
}''';
}
