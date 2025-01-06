import 'package:flutter/material.dart';
import 'package:employee_app/services/api_service.dart';
import 'package:employee_app/model/center_name_model.dart';

class CenterProvider extends ChangeNotifier {
  List<CenterName> _centers = [];
  List<CenterName> get centers => _centers;

  final ApiService _apiService;

  CenterProvider(this._apiService);

  Future<void> loadCenters() async {
    try {
      await _apiService.fetchCenterNames();  
      _centers = _apiService.centerNames;     
      notifyListeners();                
    } catch (e) {
      print('Error loading centers: $e');
    }
  }

  void setSelectedCenter(String? centerName) {
    _centers.firstWhere((center) => center.centerName == centerName);
    notifyListeners();
  }
}
