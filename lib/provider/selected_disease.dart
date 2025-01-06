import 'package:flutter/material.dart';

class SelectedDiseaseProvider with ChangeNotifier {
  String? _selectedDisease;

  String? get selectedDisease => _selectedDisease;

  void setSelectedDisease(String? disease) {
    _selectedDisease = disease;
    notifyListeners();
  }
}

class CenterProvider with ChangeNotifier {
  String? _selectedCenter;

  String? get selectedCenter => _selectedCenter;

  void setSelectedCenter(String? center) {
    _selectedCenter = center;
    notifyListeners();
  }
}
