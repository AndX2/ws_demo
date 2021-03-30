import 'package:flutter_test/flutter_test.dart';
import 'package:ws_demo/di/di_container.dart';

import 'package:ws_demo/domain/room.dart';
import 'package:ws_demo/repository/channel_repository.dart';

main() {
  initDi();

  final _roomRepository = getIt.get<ChannelRepository>();

  fetchRoomList(_roomRepository);
  fetchMessageList(_roomRepository, 'Тупичок');
  fetchMessageList(_roomRepository, '&=?');
}

void fetchRoomList(ChannelRepository _repository) {
  test(
    'Получить список всех комнат',
    () async {
      final result = await _repository.fetchRoomList();
      print(result);
      expect(
        result != null && result.isNotEmpty,
        true,
        reason: 'Не удалось получить список комнат',
      );
    },
  );
}

void fetchMessageList(ChannelRepository _repository, String roomName) {
  test(
    'Получить список cooбщений в комнате $roomName',
    () async {
      final result = await _repository.fetchMessageList(Channel(roomName));
      print(result);
      expect(
        result != null && result.isNotEmpty,
        true,
        reason: 'Не удалось получить список cooбщений в комнате $roomName',
      );
    },
  );
}
