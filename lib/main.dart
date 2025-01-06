import 'package:employee_app/provider/patientProvider.dart';
import 'package:employee_app/provider/selected_disease.dart';
import 'package:employee_app/provider/user_provider.dart';
import 'package:employee_app/screens/auth/login.dart';
import 'package:employee_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as changeNotifierProvider;

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return changeNotifierProvider.MultiProvider(
      providers: [
        changeNotifierProvider.ChangeNotifierProvider<ApiService>(
          create: (_) => ApiService(),
        ),
        changeNotifierProvider.ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        changeNotifierProvider.ChangeNotifierProvider(
          create: (_) => SelectedDiseaseProvider(),
        ),
        changeNotifierProvider.ChangeNotifierProvider(
          create: (_) => PatientProvider(),
        ),
        changeNotifierProvider.ChangeNotifierProvider(
          create: (_) => CenterProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
