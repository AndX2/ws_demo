import 'package:flutter/foundation.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/sender.dart';

/// Сообщение в комнате
@immutable
class Message extends Comparable {
  final DateTime created;
  final Owner owner;
  final String body;
  final String id;

  Message(
    this.created,
    this.owner,
    this.body, {
    this.id,
  });

  Map toJson() => {
        'id': id,
        'created': created.toIso8601String(),
        'owner': owner.ownerId,
        'text': body,
      };

  @override
  int compareTo(dynamic other) {
    if (!(other is Message))
      throw FormatException('Message.compareTo(other) => other is\'nt Message');
    return this.created.compareTo(other.created);
  }
}

extension MessageUiExt on Message {
  ChatMessageOwner isOwner(Profile profile) =>
      profile.id == owner.ownerId ? ChatMessageOwner.mine : ChatMessageOwner.other;

  Key get key => ValueKey(id ?? '$body#$created');
}

enum ChatMessageOwner {
  mine,
  other,
}
