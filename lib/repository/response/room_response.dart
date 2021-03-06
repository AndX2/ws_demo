import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/repository/response/message_response.dart';
import 'package:ws_demo/util/transformable.dart';

/// Ответ сервера [List<Room>]
///   ```json
///      {
///       "result": [
///           {
///               "name": "Тупичок",
///               "last_message": {
///                   "room": "Тупичок",
///                   "created": "2021-01-28T17:50:52.656831273Z",
///                   "sender": {
///                       "username": "ЙОЖ"
///                   },
///                   "text": "Ай, нане-нане! 111"
///               }
///           }
///        ]
///      }
///   ```
class RoomListResponse extends Transformable<List<Room>> {
  var _roomList = List<Room>();

  RoomListResponse.fromJson(dynamic json) {
    final List<dynamic> data = json['result'];
    _roomList.addAll(data.map<Room>((item) => RoomResponse.fromJson(item).transform()));
  }

  @override
  List<Room> transform() => _roomList;
}

/// Ответ сервера [Room]
///   ```json
///        {
///            "name": "Тупичок",
///            "last_message": {
///                "room": "Тупичок",
///                "created": "2021-01-28T17:50:52.656831273Z",
///                "sender": {
///                    "username": "ЙОЖ"
///                },
///                "text": "Ай, нане-нане! 111"
///            }
///        }
///   ```
class RoomResponse extends Transformable<Room> {
  String _name;
  Message _lastMessage;

  @override
  RoomResponse.fromJson(dynamic json) {
    _name = json['name'];
    _lastMessage = MessageResponse.fromJson(json['last_message']).transform();
  }

  @override
  Room transform() {
    return Room(_name)..messageList.add(_lastMessage);
  }
}
