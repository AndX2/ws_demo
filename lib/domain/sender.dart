import 'package:flutter/foundation.dart';

/// Отправитель сообщений
@immutable
class Sender {
  final String username;

  Sender(this.username);

  @override
  operator ==(other) {
    return (other is Sender) && other.username == this.username;
  }

  @override
  int get hashCode => super.hashCode;

  Map toJson() => {
        'username': username,
      };
}
