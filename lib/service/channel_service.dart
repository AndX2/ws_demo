import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/channel.dart';
import 'package:ws_demo/repository/channel_repository.dart';

/// Сервис для операция с данными о каналах
@singleton
class ChannelService {
  ChannelService(this._channelRepository);

  final ChannelRepository _channelRepository;

  // ignore: close_sinks
  final channelListObservable = BehaviorSubject<List<Channel>>.seeded([]);

  /// Получить список каналов
  Future<void> getChannelList() async {
    final channelList = await _channelRepository.fetchRoomList();
    if (channelList != null && channelList.isNotEmpty) channelListObservable.add(channelList);
  }

  /// Получить историю сообщений в канале
  Future<void> getChannelHistory(Channel channel) async {
    final channelHistory = await _channelRepository.fetchMessageList(channel);
    if (channelHistory != null) _setChannelHistory(channel, channelHistory);
  }

  void _setChannelHistory(Channel channel, List<Message> list) {
    final currentChannel =
        channelListObservable.value.firstWhere((item) => item == channel, orElse: () => null);
    if (currentChannel != null) {
      currentChannel.messageList.clear();
      currentChannel.messageList.addAll(list);
    } else {
      channelListObservable.value.add(channel);
    }
    channelListObservable.add(channelListObservable.value);
  }
}
