import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class Profile {
  final String userName;

  Profile(this.userName);

  Profile.fromJson(dynamic json) : userName = jsonDecode(json ?? '{}')["userName"];

  Map get toJson => {"userName": userName};
}
