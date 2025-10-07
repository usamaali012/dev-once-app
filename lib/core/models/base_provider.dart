import 'package:flutter/material.dart';

abstract class BaseProvider extends ChangeNotifier {
  bool _isBusy = false;

  void setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  bool get isBusy => _isBusy;
}