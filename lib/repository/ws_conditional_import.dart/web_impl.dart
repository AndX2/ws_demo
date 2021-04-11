import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Web реализация WebSocketChannel
WebSocketChannel getPlatformSocketChannel(String url) => HtmlWebSocketChannel.connect(url);
