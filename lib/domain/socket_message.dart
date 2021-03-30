import 'package:flutter/foundation.dart';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/sender.dart';

@immutable
class SocketMessage extends Message {
  final String channel;
  final String id;

  SocketMessage(
    this.channel,
    this.id,
    DateTime created,
    Owner owner,
    String body,
  ) : super(created, owner, body);

  Map toJson() => {
        'channel': channel,
        'message': {
          "publicId": id,
          "ownerId": owner.ownerId,
          "ownerName": owner.ownerName,
          "created": created.toIso8601String(),
          "assets": [],
          "body": body,
        }
      };
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
