import 'dart:io';
import 'dart:convert';
import 'dart:math' as math;

class SocketConnection {
  Socket? _socket;
  final String _serverAddress;
  final int _serverPort;

  SocketConnection(this._serverAddress, this._serverPort);

  Future<bool> connect() async {
    try {
      _socket = await Socket.connect(_serverAddress, _serverPort,
          timeout: Duration(seconds: 5));
      print('Connected to server: $_serverAddress:$_serverPort');
      _socket?.listen(
        _handleServerData,
        onError: _handleError,
        onDone: _handleDone,
      );
      print("Ayoo");
      return true;
    } catch (e) {
      print('Failed to connect to server: $e');
      return false;
    }
  }

  void _handleServerData(data) {
    final serverResponse = String.fromCharCodes(data);
    print('Server response: $serverResponse');
    // Handle the server response as needed
  }

  void _handleError(error) {
    print('Socket error: $error');
  }

  void _handleDone() {
    print('Socket closed');
    _socket?.destroy();
  }

  void sendDataToServer(String data) {
    if (_socket != null) {
      String encodeMessageLength(String message) {
        // Encode the message as UTF-8 bytes
        final messageBytes = utf8.encode(message);

        // Get the length of the message in bytes
        final messageLength = messageBytes.length;

        // Define the desired header length (64 characters)
        final headerLength = 64;

        // Convert the message length to a string
        final lengthString = messageLength.toString();

        // Calculate the padding length
        final paddingLength = headerLength - lengthString.length;

        // Ensure non-negative padding (avoid negative padding)
        final nonNegativePadding = math.max(paddingLength, 0);

        // Pad the length string with spaces to reach the header length
        final paddedLengthString =
            lengthString.padRight(nonNegativePadding, ' ');

        // Combine the padded length string and the original message
        return paddedLengthString;
      }

      _socket?.write(encodeMessageLength(data));
      _socket?.write(data);
    } else {
      print('Socket is not connected');
    }
  }

  void closeConnection() {
    _socket?.close();
  }
}
