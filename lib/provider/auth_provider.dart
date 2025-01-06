import 'package:employee_app/model/user_model.dart';
import 'package:employee_app/provider/user_provider.dart';
import 'package:employee_app/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:employee_app/repo/auth_repository.dart';
import 'package:employee_app/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRepository(apiService);
});

final loginStateProvider =
    StateNotifierProvider<LoginStateNotifier, AsyncValue<Map<String, dynamic>>>(
        (ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginStateNotifier(authRepository);
});

class LoginStateNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final AuthRepository authRepository;

  LoginStateNotifier(this.authRepository) : super(const AsyncData({}));

  Future<void> login(String userid, String password,
      // String disease,
      BuildContext context) async {
    if (userid.isEmpty || password.isEmpty
        // || disease.isEmpty
    ) {
      state = AsyncError(
          ValidationException("All fields are required"), StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    try {
      final result =
          await authRepository.login(userid, password,
              // disease,
              context);
      state = AsyncData(result);
    } catch (e) {
      if (e is InvalidCredentialsException) {
        state = AsyncError(e, StackTrace.current);
      } else if (e is ValidationException) {
        state = AsyncError(e, StackTrace.current);
      } else {
        state = AsyncError(e, StackTrace.current);
      }
    }
  }
}
