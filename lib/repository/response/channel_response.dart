import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/channel.dart';
import 'package:ws_demo/repository/response/message_response.dart';
import 'package:ws_demo/util/transformable.dart';

/// Ответ сервера [List<Channel>]
///   ```json
///      {
///            "quotes": {
///                "publicId": "30d959c4-b89b-4632-a282-9bdb92fbed65",
///                "ownerId": "2d41c742-8436-4eb7-a458-4a2ab80fb7e6",
///                "ownerName": "Spamer",
///                "created": "2021-04-04T00:26:33.360504",
///                "assets": [],
///                "body": "Проблема С++ в том, что необходимо узнать всё о нём перед тем, как начать писать           на нём все что угодно. Larry Wall"
///            },
///            "channel1": {
///                ...
///            }
///        }
///   ```
class ChannelListResponse extends Transformable<List<Channel>> {
  var _roomList = List<Channel>();

  ChannelListResponse.fromJson(dynamic json) {
    _roomList.addAll(
        (json as Map).entries.map<Channel>((item) => ChannelResponse.fromJson(item).transform()));
  }

  @override
  List<Channel> transform() => _roomList;
}

/// Ответ сервера [Channel]
class ChannelResponse extends Transformable<Channel> {
  String _name;
  Message _lastMessage;

  @override
  ChannelResponse.fromJson(MapEntry<String, dynamic> entry) {
    _name = entry.key;
    _lastMessage = MessageResponse.fromJson(entry.value).transform();
  }

  @override
  Channel transform() {
    return Channel(_name)..messageList.add(_lastMessage);
  }
}
