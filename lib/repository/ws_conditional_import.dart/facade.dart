import 'package:web_socket_channel/web_socket_channel.dart';

/// Фасад, предоставляющий интерфейс сигнатуры метода для WebSocketChannel
/// текущей платформы (IO или Web)
WebSocketChannel getPlatformSocketChannel(String url) =>
    throw UnsupportedError('Haven\'t implementation');
