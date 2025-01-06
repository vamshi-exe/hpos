import 'package:employee_app/services/api_service.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository(this.apiService);

  Future<Map<String, dynamic>> login(
      String userid, String password,
      // String disease,
      BuildContext context) {
    return apiService.login(userid, password,
        // disease,
        context);
  }
}
