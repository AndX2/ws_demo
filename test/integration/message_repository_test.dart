import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import 'package:ws_demo/di/di_container.dart';
import 'package:ws_demo/domain/channel.dart';
import 'package:ws_demo/domain/socket_message.dart';
import 'package:ws_demo/repository/message_repository.dart';

const _userName = 'AndX2_unit_test';
const _responseTimeout = Duration(seconds: 10);

main() async {
  initDi();

  final _repository = getIt.get<MessageRepository>(param1: _userName);

  await sendReceiveMessage(_repository);

  tearDownAll(() {
    _repository.close();
  });
}

Future sendReceiveMessage(MessageRepository repository) async {
  test(
    'Отправка и получение ws сообщения',
    () async {
      final uuid = Uuid();

      final room = Channel('AndX2_unit_test_room');
      final text = 'Random string';
      final id = uuid.v4();

      final timeout = Timer(_responseTimeout, () {
        throw Exception('timeout!');
      });

      repository.stream.forEach(
        (SocketMessage message) {
          print(message.toJson());
          if (message.id == id) {
            timeout.cancel();
            expect(true, true);
            return;
          }
        },
      );

      repository.send(room, text, id);

      await Future.delayed(_responseTimeout);
    },
  );
}
