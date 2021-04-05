import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/repository/response/channel_response.dart';
import 'package:ws_demo/repository/response/message_response.dart';
import 'package:ws_demo/util/const.dart' as consts;

/// Репозиторий для каналов
@injectable
class ChannelRepository {
  final Dio _httpClient;

  ChannelRepository(this._httpClient);

  /// Получить список каналов
  Future<List<Channel>> fetchRoomList() {
    return _httpClient
        .get(consts.Url.roomList)
        .then((response) => ChannelListResponse.fromJson(response.data).transform());
  }

  /// Получить историю сообщений в канале
  Future<List<Message>> fetchMessageList(Channel channel) async {
    return _httpClient.get(consts.Url.channelHistory(channel)).then((response) {
      return MessageListResponse.fromJson(response.data).transform();
    });
  }
}
