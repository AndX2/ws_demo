import 'package:ws_demo/domain/sender.dart';
import 'package:ws_demo/util/transformable.dart';

/// Объект ответа сервера [Sender]
///   ```json
///     "sender": {
///           "username": "ЙОЖ"
///               }
///   ```
class SenderResponse extends Transformable<Sender> {
  String _userName;

  SenderResponse.fromJson(dynamic json) {
    _userName = json['username'];
  }

  @override
  Sender transform() {
    return Sender(_userName);
  }
}
