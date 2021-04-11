import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';

import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/channel.dart';
import 'package:ws_demo/repository/channel_repository.dart';

/// Сервис для операция с данными о каналах
@singleton
class ChannelService {
  final ChannelRepository _roomRepository;

  // ignore: close_sinks
  final roomListObservable = BehaviorSubject<List<Channel>>.seeded([]);

  ChannelService(this._roomRepository);

  Future<void> getChannelList() async {
    final roomList = await _roomRepository.fetchRoomList();
    if (roomList != null && roomList.isNotEmpty) roomListObservable.add(roomList);
  }

  Future<void> getRoomHistory(Channel room) async {
    final roomHistory = await _roomRepository.fetchMessageList(room);
    if (roomHistory != null) _setRoomHistory(room, roomHistory);
  }

  void _setRoomHistory(Channel room, List<Message> list) {
    final currentRoom =
        roomListObservable.value.firstWhere((item) => item == room, orElse: () => null);
    if (currentRoom != null) {
      currentRoom.messageList.clear();
      currentRoom.messageList.addAll(list);
    } else {
      roomListObservable.value.add(room);
    }
    roomListObservable.add(roomListObservable.value);
  }
}
