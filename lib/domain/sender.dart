import 'package:flutter/foundation.dart';

/// Отправитель сообщений
@immutable
class Owner {
  final String ownerName;
  final String ownerId;

  Owner(
    this.ownerName,
    this.ownerId,
  );

  @override
  operator ==(other) {
    return (other is Owner) && other.ownerId == this.ownerId;
  }

  @override
  int get hashCode => super.hashCode;
}
