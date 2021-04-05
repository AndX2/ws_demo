import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ws_demo/domain/token_pair.dart';

/// Объект авторизации пользователя в сервисе
@immutable
class Profile {
  final String name;
  final String id;
  final TokenPair tokenPair;

  Profile(
    this.id,
    this.name, {
    this.tokenPair,
  });

  bool get isEmpty => id == null || id.isEmpty;

  factory Profile.fromJson(dynamic json) {
    if (json == null) return null;
    return Profile(
      jsonDecode(json ?? '{}')["id"],
      jsonDecode(json ?? '{}')["name"],
      tokenPair: TokenPair(null, jsonDecode(json ?? '{}')["refresh"]),
    );
  }

  Map get toJson => {
        "name": name,
        "id": id,
        "refresh": tokenPair.refresh,
      };

  Profile copyWith({
    String name,
    String id,
    TokenPair tokenPair,
  }) =>
      Profile(
        id ?? this.id,
        name ?? this.name,
        tokenPair: tokenPair ?? this.tokenPair,
      );
}
