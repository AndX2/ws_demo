import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/channel.dart';
import 'package:ws_demo/repository/channel_repository.dart';

/// Сервис для операция с данными о каналах
@singleton
class ChannelService {
  final ChannelRepository _channelRepository;

  // ignore: close_sinks
  final channelListObservable = BehaviorSubject<List<Channel>>.seeded([]);

  ChannelService(this._channelRepository);

  /// Получить список каналов
  Future<void> getChannelList() async {
    final channelList = await _channelRepository.fetchRoomList();
    if (channelList != null && channelList.isNotEmpty) channelListObservable.add(channelList);
  }

  /// Получить историю сообщений в канале
  Future<void> getChannelHistory(Channel channel) async {
    final roomHistory = await _channelRepository.fetchMessageList(channel);
    if (roomHistory != null) _setChannelHistory(channel, roomHistory);
  }

  void _setChannelHistory(Channel room, List<Message> list) {
    final currentChannel =
        channelListObservable.value.firstWhere((item) => item == room, orElse: () => null);
    if (currentChannel != null) {
      currentChannel.messageList.clear();
      currentChannel.messageList.addAll(list);
    } else {
      channelListObservable.value.add(room);
    }
    channelListObservable.add(channelListObservable.value);
  }
}
