import 'package:flutter/material.dart';
import 'package:check_object/model/house_object.dart';

class HouseObjects extends ChangeNotifier {
  List<HouseObject> _houseObjects = [];

  List<HouseObject> get houseObjects => _houseObjects;

  set houseObjects(List<HouseObject> value) {
    _houseObjects = value;
    notifyListeners();
  }

  void addAll(List<HouseObject> value) {
    _houseObjects
      ..clear()
      ..addAll(value);
    notifyListeners();
  }
}
