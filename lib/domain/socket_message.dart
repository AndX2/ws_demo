import 'package:flutter/foundation.dart';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/sender.dart';

@immutable
class SocketMessage extends Message {
  final String roomName;
  final String id;

  SocketMessage(
    this.roomName,
    this.id,
    DateTime created,
    Sender sender,
    String text,
  ) : super(created, sender, text);

  Map toJson() => {
        'room': roomName,
        'id': id,
        'created': created.toIso8601String(),
        'sender': sender.toJson(),
        'text': text,
      };
}
