import 'package:flutter/foundation.dart';

@immutable
class TokenPair {
  TokenPair(this.access, this.refresh);

  final String access;
  final String refresh;
}
