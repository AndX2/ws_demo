import 'package:flutter/foundation.dart';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/sender.dart';

/// Сообщение включая сведения о целевом канале
/// предназначенное для сериализации во фрейм
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
