import 'package:flutter/foundation.dart';

import 'package:ws_demo/domain/channel.dart';

/// Объект сообщения пользователя для ws канала
/// ```json
///   "message": {
///        "type": "message",
///        "headers": {
///            "channel": "newChannel",
///            "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.///eyJpc3MiOiJodHRwczovL2RhcnRzZXJ2aWNlLnJ1L2F1dGgiLCJleHAiOjE2MTY0ODU3MjMsImRhdGEiOnsidXNl///ciI6bnVsbCwidXNlck5hbWUiOm51bGx9fQ.///FdnVc_Clqh4k3DwHNcg0VYUpZL6sDD44EIsf0QRnBPHtZs7JMJFEjLo8a64sqK47_sxu4hNjaEPohQJSeq9vWqPi///CZWFvMCAeCFGPHYc4pStNLztIpjGFjCZSIqscwobqq5nyRCOAxFZS87cmaB2mNkHNBVySlF0MArHC5jNOygZMPZr///Wfl-qCZVLEGdWD8Cy-_Y2p7uCuuuShsC1iEXaJdu8iuHKMaSX2KFVlXUGMci8P3YpmC3N2BveYgB93593qrGD1mN///LB3uez-Eq203oorGd3-3nxXL83th465qdQB25tjvvg__Uzbgzvp5HVKRHa4d0HMNrVr09ejVEmBJ0A"
///        },
///        "payload": {
///            "publicId": "ad56026f-f383-4d52-b9c3-0d1b75a32c0d",
///            "ownerId": "2d41c742-8436-4eb7-a458-4a2ab80fb7e6",
///            "ownerName": "some user",
///            "created": "2021-03-22T03:44:34.318707",
///            "assets": [],
///            "body": "При помощи C вы легко можете выстрелить себе в ногу. При помощи C++ это ///сделать сложнее, но если это произойдёт, вам оторвёт всю ногу целиком. Bjarne ///Stroustrup"
///        }
///    }
/// ```
@immutable
class MessageRequest {
  MessageRequest(
    this.channel,
    this.body,
    this.id,
  );

  final Channel channel;
  final String body;
  final String id;

  Map<String, dynamic> get toJson => {
        "type": "message",
        "headers": {
          "channel": channel.name,
        },
        "payload": {
          "publicId": id,
          "created": DateTime.now().toUtc().toIso8601String(),
          "assets": [],
          "body": body
        }
      };
}
