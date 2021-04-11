import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Нативная реализация WebSocketChannel
WebSocketChannel getPlatformSocketChannel(String url) => IOWebSocketChannel.connect(url);
