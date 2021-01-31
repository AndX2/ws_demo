import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/domain/socket_message.dart';

import 'package:ws_demo/repository/message_repository.dart';
import 'package:ws_demo/repository/preference_repository.dart';
import 'package:ws_demo/service/room_service.dart';

const _shippingTimeoute = Duration(seconds: 10);

@singleton
class MessageService {
  MessageRepository _messageRepository;
  final PreferenceRepository _preferenceRepository;
  final RoomService _roomService;

  // ignore: close_sinks
  final _shippingStreamController = StreamController<SocketMessage>.broadcast();
  final _uuid = Uuid();

  MessageService(
    this._preferenceRepository,
    this._roomService,
  ) : _messageRepository = getIt.get<MessageRepository>(param1: _preferenceRepository.profile.userName);

  void subscribe() {
    _messageRepository.stream.forEach(
      (SocketMessage message) {
        // print(message.toJson());
        _onReceiveMessage(message);
      },
    );
  }

  Future<void> sendMessage(Room room, String text) async {
    final id = _uuid.v4();
    await Future.delayed(Duration(seconds: 3));
    final timeout = Timer(_shippingTimeoute, () => throw Exception());
    _messageRepository.send(room, text, id);
    await _shippingStreamController.stream.firstWhere((message) {
      timeout.cancel();
      return message.id == id;
    });
  }

  Profile getProfile() {
    return getIt.get<PreferenceRepository>().profile;
  }

  Future<void> setProfile(Profile profile) async {
    _messageRepository.close();
    await _preferenceRepository.saveProfile(profile);
    _messageRepository = getIt.get<MessageRepository>(param1: _preferenceRepository.profile.userName);
    subscribe();
  }

  void _onReceiveMessage(SocketMessage message) {
    _shippingStreamController.sink.add(message);
    final roomList = _roomService.roomListObservable.value;
    final targetRoom = roomList.firstWhere(
      (room) => room.name == message.roomName,
      orElse: () => _addRoom(message),
    );
    if (!targetRoom.messageList.contains(message)) {
      targetRoom.messageList.add(message);
      _roomService.roomListObservable.add(roomList);
    }
  }

  Room _addRoom(SocketMessage message) {
    final roomList = _roomService.roomListObservable.value;
    final room = Room(message.roomName)..messageList.add(message);
    roomList.add(room);
    _roomService.roomListObservable.add(roomList);
    return room;
  }
}
