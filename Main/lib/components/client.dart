import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;

typedef void ConnectionCallback(bool isConnected);
typedef void ServerDataCallback(String data);

class SocketConnection {
  Socket? _socket;
  final String _serverAddress;
  final int _serverPort;

  ConnectionCallback? _connectionCallback;
  ServerDataCallback? _serverDataCallback;

  Completer<String>? _responseCompleter;

  SocketConnection(this._serverAddress, this._serverPort);

  void setConnectionCallback(ConnectionCallback callback) {
    _connectionCallback = callback;
  }

  void setServerDataCallback(ServerDataCallback callback) {
    _serverDataCallback = callback;
  }

  Future<void> connect() async {
    print("Trying to connect to server");
    try {
      _socket = await Socket.connect(_serverAddress, _serverPort,
          timeout: const Duration(seconds: 5));
      print('Connected to server: $_serverAddress:$_serverPort');
      _socket?.listen(
        _handleServerData,
        onError: _handleError,
        onDone: _handleDone,
      );
      _connectionCallback?.call(true);
    } catch (e) {
      print('Failed to connect to server, Trying to reconnect');
      _connectionCallback?.call(false);
      connect();
    }
  }

  void _handleServerData(data) {
    final serverResponse = String.fromCharCodes(data);
    print('Server response: $serverResponse');
    _serverDataCallback?.call(serverResponse);

    // Complete the response completer if it exists
    _responseCompleter?.complete(serverResponse);
    _responseCompleter = null;
  }

  void _handleError(error) {
    print('Socket error: $error');
  }

  void _handleDone() {
    print('Socket closed');
    _socket?.destroy();
    _connectionCallback?.call(false);
    connect();
  }

  Future<String> sendDataToServer(String data) async {
    if (_socket != null) {
      String encodeMessageLength(String message) {
        final messageBytes = utf8.encode(message);
        final messageLength = messageBytes.length;
        final headerLength = 64;
        final lengthString = messageLength.toString();
        final paddingLength = headerLength - lengthString.length;
        final nonNegativePadding = math.max(paddingLength, 0);
        final paddedLengthString =
            lengthString.padRight(nonNegativePadding, ' ');
        return paddedLengthString;
      }

      _responseCompleter = Completer<String>();
      _socket?.write(encodeMessageLength(data));
      _socket?.write(data);

      return _responseCompleter!.future;
    } else {
      print('Socket is not connected');
      throw Exception('Socket is not connected');
    }
  }

  void closeConnection() {
    _socket?.close();
  }
}
