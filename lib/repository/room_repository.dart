import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/repository/response/message_response.dart';
import 'package:ws_demo/repository/response/room_response.dart';
import 'package:ws_demo/util/const.dart' as consts;

/// Репозиторий для комнат (каналов)
@injectable
class RoomRepository {
  final Dio _httpClient;

  RoomRepository(this._httpClient);

  /// Получить список каналов
  Future<List<Room>> fetchRoomList() {
    return _httpClient
        .get(consts.Url.roomList)
        .then((response) => RoomListResponse.fromJson(response.data).transform());
  }

  /// Получить историю сообщений в канале
  Future<List<Message>> fetchMessageList(Room room) async {
    return _httpClient.get(consts.Url.roomHistory(room)).then((response) {
      return MessageListResponse.fromJson(response.data).transform();
    });
  }
}
