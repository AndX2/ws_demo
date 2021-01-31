import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/subjects.dart';
import 'package:ws_demo/domain/message.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/repository/room_repository.dart';

@singleton
class RoomService {
  final RoomRepository _roomRepository;

  // ignore: close_sinks
  final roomListObservable = BehaviorSubject<List<Room>>();

  RoomService(this._roomRepository);

  Future<void> getRoomList() async {
    final roomList = await _roomRepository.fetchRoomList();
    if (roomList != null && roomList.isNotEmpty) roomListObservable.add(roomList);
  }

  Future<void> getRoomHistory(Room room) async {
    final roomHistory = await _roomRepository.fetchMessageList(room);
    if (roomHistory != null) _setRoomHistory(room, roomHistory);
  }

  void _setRoomHistory(Room room, List<Message> list) {
    final currentRoom = roomListObservable.value.firstWhere((item) => item == room, orElse: () => null);
    if (currentRoom != null) {
      currentRoom.messageList.clear();
      currentRoom.messageList.addAll(list);
    } else {
      roomListObservable.value.add(room);
    }
    roomListObservable.add(roomListObservable.value);
  }
}
