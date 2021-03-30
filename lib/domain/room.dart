import 'package:flutter/foundation.dart';

import 'package:ws_demo/domain/message.dart';

/// Комната (канал) для отправки сообщений
/// Room.name используется в качестве сегмента Url path
/// необходима проверка валидности
@immutable
class Channel extends Comparable {
  final String name;
  final List<Message> messageList = [];

  Channel(this.name);

  @override
  operator ==(other) {
    return (other is Channel) && other.name == this.name;
  }

  @override
  int get hashCode => super.hashCode;

  @override
  int compareTo(dynamic other) {
    if (!(other is Channel)) throw FormatException('Room.compareTo(other) => other is\'nt Room');
    return this.lastMessage.compareTo(other.lastMessage);
  }

  Message get lastMessage => messageList.length == 1
      ? messageList.first
      : messageList.reduce(
          (a, b) => a.compareTo(b) > 0 ? a : b,
        );
}
