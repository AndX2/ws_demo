import 'dart:convert';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/sender.dart';
import 'package:ws_demo/domain/socket_message.dart';
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
  Owner _owner;
  String _body;

  @override
  MessageResponse.fromJson(dynamic json) {
    final msg = json['message'];
    _created = DateTime.parse(msg['created']);
    _owner = Owner(
      msg['ownerId'],
      msg['ownerName'],
    );
    _body = msg['text'];
  }

  @override
  Message transform() {
    final message = Message(_created, _owner, _body);
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
  Owner _owner;
  String _body;
  String _channel;
  String _id;

  @override
  SocketMessageResponse.fromJson(dynamic json) {
    json = jsonDecode(json);
    final msg = json['message'];
    _created = DateTime.parse(msg['created']);
    _owner = Owner(
      msg['ownerName'],
      msg['ownerName'],
    );
    _body = msg['body'];
    _channel = json['channel'];
    _id = msg['id'];
  }

  @override
  SocketMessage transform() {
    return SocketMessage(
      _channel,
      _id,
      _created,
      _owner,
      _body,
    );
  }
}

final rowMsg = {
  "channel": "quotes",
  "message": {
    "publicId": "7111b46f-6f0b-402c-b190-786f2917b89c",
    "ownerId": "2d41c742-8436-4eb7-a458-4a2ab80fb7e6",
    "ownerName": "Spamer",
    "created": "2021-03-29T23:25:53.360511",
    "assets": [],
    "body":
        "Всегда пишите код так, будто сопровождать его будет склонный к насилию психопат, который знает, где вы живете. Martin Golding"
  }
};
