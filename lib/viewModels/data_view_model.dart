import 'package:flutter/material.dart';

class DataViewModel extends ChangeNotifier {
  String _message = '';

  String get message => _message;

  void updateMessage(String newMessage) {
    _message = newMessage;
    notifyListeners();
  }
}
