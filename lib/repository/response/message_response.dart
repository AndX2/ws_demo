import 'dart:convert';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/sender.dart';
import 'package:ws_demo/domain/socket_message.dart';
import 'package:ws_demo/repository/response/sender_response.dart';
import 'package:ws_demo/util/transformable.dart';

/// Ответ сервера [List<Message>]
///   ```json
///   {
///    "result": [
///         {
///             "room": "Тупичок",
///             "created": "2021-01-28T17:50:52.656831273Z",
///             "sender": {
///                 "username": "ЙОЖ"
///             },
///             "text": "Ай, нане-нане! 111"
///         }
///     ]
///   }
///   ```
///
class MessageListResponse extends Transformable<List<Message>> {
  List<Message> _list;

  MessageListResponse.fromJson(dynamic json) {
    final List<dynamic> data = json['result'];

    _list = data.map<Message>(
      (item) {
        return MessageResponse.fromJson(item).transform();
      },
    ).toList();
  }
  @override
  List<Message> transform() {
    return _list;
  }
}

/// Ответ сервера с объектом сообщения в канале
///   ```json
///   {
///       "room": "Тупичок",
///       "created": "2021-01-28T17:50:52.656831273Z",
///       "sender": {
///           "username": "ЙОЖ"
///       },
///       "text": "Ай, нане-нане! 111"
///   }
///   ```
///
class MessageResponse extends Transformable<Message> {
  DateTime _created;
  Sender _sender;
  String _text;

  @override
  MessageResponse.fromJson(dynamic json) {
    _created = DateTime.parse(json['created']);
    _sender = SenderResponse.fromJson(json['sender']).transform();
    _text = json['text'];
  }

  @override
  Message transform() {
    final message = Message(_created, _sender, _text);
    // print(message.toJson());
    return message;
  }
}

/// Ответ сервера с объектом сообщения в канале
///   ```json
///   {
///       "room": "Тупичок",
///       "created": "2021-01-28T17:50:52.656831273Z",
///       "sender": {
///           "username": "ЙОЖ"
///       },
///       "text": "Ай, нане-нане! 111",
///       "id": "123456789"
///   }
///   ```
///
class SocketMessageResponse extends Transformable<SocketMessage> {
  DateTime _created;
  Sender _sender;
  String _text;
  String _roomName;
  String _id;

  @override
  SocketMessageResponse.fromJson(dynamic json) {
    json = jsonDecode(json);
    _created = DateTime.parse(json['created']);
    _sender = SenderResponse.fromJson(json['sender']).transform();
    _text = json['text'];
    _roomName = json['room'];
    _id = json['id'];
  }

  @override
  SocketMessage transform() {
    return SocketMessage(
      _roomName,
      _id,
      _created,
      _sender,
      _text,
    );
  }
}
