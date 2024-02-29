import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;

  void initializeSocket() {
    socket = io.io('https://your-socket-server-url.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  void sendMessage(String message) {
    socket.emit('message', message);
  }
}
