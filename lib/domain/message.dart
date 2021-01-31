import 'package:flutter/foundation.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/sender.dart';

/// Сообщение в комнате
@immutable
class Message extends Comparable {
  final DateTime created;
  final Sender sender;
  final String text;
  final String id;

  Message(
    this.created,
    this.sender,
    this.text, {
    this.id,
  });

  Map toJson() => {
        'id': id,
        'created': created.toIso8601String(),
        'sender': sender.toJson(),
        'text': text,
      };

  @override
  int compareTo(dynamic other) {
    if (!(other is Message)) throw FormatException('Message.compareTo(other) => other is\'nt Message');
    return this.created.compareTo(other.created);
  }
}

extension MessageUiExt on Message {
  ChatMessageOwner owner(Profile profile) =>
      profile.userName == sender.username ? ChatMessageOwner.mine : ChatMessageOwner.other;

  Key get key => ValueKey(id ?? '$text#$created');
}

enum ChatMessageOwner {
  mine,
  other,
}
