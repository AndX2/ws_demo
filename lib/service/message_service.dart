import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/profile.dart';
import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/domain/socket_message.dart';
import 'package:ws_demo/repository/lifecycle_repository.dart';

import 'package:ws_demo/repository/message_repository.dart';
import 'package:ws_demo/repository/preference_repository.dart';
import 'package:ws_demo/service/channel_service.dart';

const _shippingTimeoute = Duration(seconds: 10);

/// Сервис для получения / отправки сообщений
@singleton
class MessageService {
  MessageRepository _messageRepository;
  final PreferenceRepository _preferenceRepository;
  final ChannelService _roomService;
  final LifeCycleRepository _lifeCycleRepository;

  // ignore: close_sinks
  final _shippingStreamController = StreamController<SocketMessage>.broadcast();
  final _uuid = Uuid();

  MessageService(
    this._preferenceRepository,
    this._roomService,
    this._lifeCycleRepository,
  ) : _messageRepository =
            getIt.get<MessageRepository>(param1: _preferenceRepository.profile.name) {
    _lifeCycleRepository.subscribe();
    _lifeCycleRepository.addListener(() => _lifeStateChanged(_lifeCycleRepository.state));
  }

  void subscribe() {
    _messageRepository.stream.forEach(
      (SocketMessage message) {
        print(message);
        _onReceiveMessage(message);
      },
    );
  }

  Future<void> sendMessage(Channel room, String text) async {
    final id = _uuid.v4();
    final timeout = Timer(_shippingTimeoute, () => throw Exception());
    _messageRepository.send(room, text, id);
    await _shippingStreamController.stream.firstWhere((message) {
      timeout.cancel();
      return message.id == id;
    });
  }

  void _onReceiveMessage(SocketMessage message) {
    _shippingStreamController.sink.add(message);
    final roomList = _roomService.roomListObservable.value;
    final targetRoom = roomList.firstWhere(
      (room) => room.name == message.channel,
      orElse: () => _addRoom(message),
    );
    if (!targetRoom.messageList.contains(message)) {
      targetRoom.messageList.add(message);
      _roomService.roomListObservable.add(roomList);
    }
  }

  Channel _addRoom(SocketMessage message) {
    final roomList = _roomService.roomListObservable.value;
    final room = Channel(message.channel)..messageList.add(message);
    roomList.add(room);
    _roomService.roomListObservable.add(roomList);
    return room;
  }

  void _lifeStateChanged(AppLifecycleState state) {
    // print(state);
    if (state == AppLifecycleState.paused) _messageRepository.close();
    if (state == AppLifecycleState.resumed) {
      _messageRepository = getIt.get<MessageRepository>(param1: _preferenceRepository.profile.name);
      subscribe();
      _messageRepository.ping();
    }
  }
}
