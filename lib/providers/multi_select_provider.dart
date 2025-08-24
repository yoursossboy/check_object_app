import 'package:flutter/cupertino.dart';

class MultiSelectProvider extends ChangeNotifier {
  List<String> _data = [];

  List<String> get data => _data;

  set data(List<String> value) {
    _data = value;
    notifyListeners();
  }

  void add(String value) {
    _data.add(value);
    notifyListeners();
  }

  void addAll(List<String> value) {
    _data.addAll(value);
    notifyListeners();
  }

  List<String> removeLast() {
    _data.removeLast();
    notifyListeners();
    return _data;
  }
  void clear() {
    _data.clear();
    notifyListeners();
  }
}

