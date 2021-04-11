import 'package:flutter/foundation.dart';

/// Объект, содержащий токен достура и токен обновления
@immutable
class TokenPair {
  TokenPair(this.access, this.refresh);

  final String access;
  final String refresh;
}
