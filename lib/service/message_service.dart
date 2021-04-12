import 'dart:async';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/channel.dart';
import 'package:ws_demo/domain/socket_message.dart';
import 'package:ws_demo/repository/lifecycle_repository.dart';
import 'package:ws_demo/repository/message_repository.dart';
import 'package:ws_demo/repository/preference_repository.dart';
import 'package:ws_demo/service/channel_service.dart';

/// Предельное время ожидания подтверждения доставки сообщения
const _shippingTimeoute = Duration(seconds: 10);

/// Типичное время 500...2000 мс
/// Время подавления "дребезга"
const _debounceTimeout = Duration(milliseconds: 1000);

/// Сервис для получения / отправки сообщений
@singleton
class MessageService {
  MessageRepository _messageRepository;
  final PreferenceRepository _preferenceRepository;
  final ChannelService _channelService;
  final LifeCycleRepository _lifeCycleRepository;

  // ignore: close_sinks
  final _shippingStreamController = StreamController<SocketMessage>.broadcast();
  final _uuid = Uuid();
  final _debouncedMessagesCache = <SocketMessage>[];
  Timer _debounceTimer;

  MessageService(
    this._preferenceRepository,
    this._channelService,
    this._lifeCycleRepository,
  ) : _messageRepository = getIt.get<MessageRepository>() {
    _lifeCycleRepository.subscribe();
    _lifeCycleRepository.addListener(() => _lifeStateChanged(_lifeCycleRepository.state));
  }

  /// Подписаться на поток сообщений
  void subscribe() {
    _messageRepository.stream.forEach(
      (SocketMessage message) {
        print(message);
        _onReceiveMessage(message);
      },
    );
  }

  /// Отправить сообщение
  Future<void> sendMessage(Channel channel, String body) async {
    final id = _uuid.v4();
    final timeout = Timer(_shippingTimeoute, () => throw Exception());
    _messageRepository.send(channel, body, id);
    await _shippingStreamController.stream.firstWhere((message) => message.id == id);
    timeout.cancel();
  }

  void _onReceiveMessage(SocketMessage message) {
    _shippingStreamController.sink.add(message);
    final channelList = _channelService.channelListObservable.value;
    final targetChannel = channelList.firstWhere(
      (room) => room.name == message.channel,
      orElse: () => _addChannel(message),
    );
    if (!targetChannel.messageList.contains(message)) {
      if (_debounceTimer == null || !_debounceTimer.isActive) {
        targetChannel.messageList.add(message);
        _channelService.channelListObservable.add(channelList);
        _debounceTimer = Timer(_debounceTimeout, _applyDebouncedMessages);
      } else {
        _debouncedMessagesCache.add(message);
      }
    }
  }

  Channel _addChannel(SocketMessage message) {
    final roomList = _channelService.channelListObservable.value;
    final room = Channel(message.channel)..messageList.add(message);
    roomList.add(room);
    _channelService.channelListObservable.add(roomList);
    return room;
  }

  void _applyDebouncedMessages() {
    if (_debouncedMessagesCache.isEmpty) return;

    final channelList = _channelService.channelListObservable.value;
    _debouncedMessagesCache.forEach((message) {
      final targetRoom = channelList.firstWhere((room) => room.name == message.channel);
      targetRoom.messageList.add(message);
    });
    _channelService.channelListObservable.add(channelList);
    _debouncedMessagesCache.clear();
    _debounceTimer = Timer(_debounceTimeout, _applyDebouncedMessages);
  }

  void _lifeStateChanged(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) _messageRepository.close();
    if (state == AppLifecycleState.resumed) {
      _messageRepository = getIt.get<MessageRepository>();
      subscribe();
      _messageRepository.ping();
    }
  }
}
