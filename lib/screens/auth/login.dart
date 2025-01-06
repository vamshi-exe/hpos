import 'package:employee_app/provider/auth_provider.dart';
import 'package:employee_app/provider/selected_disease.dart';
import 'package:employee_app/screens/auth/reset_password.dart';
import 'package:employee_app/screens/home/employee/employee_screen.dart';
import 'package:employee_app/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // String? _selectedDisease;
  bool isObscure = true;

  // final Map<String, String> diseaseMapping = {
  //   'Sickle Cell': 'sickleCell',
  //   'Breast Cancer': 'breastCancer',
  //   'Cervical Cancer': 'cervicalCancer',
  //   'All': 'all',
  // };

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginStateProvider);
    ref.listen<AsyncValue<Map<String, dynamic>>>(loginStateProvider,
            (previous, next) {
          if (next is AsyncError) {
            final error = next.error;

            String errorMessage = 'An unexpected error occurred';
            if (error is InvalidCredentialsException) {
              errorMessage = error.message;
            } else if (error is ValidationException) {
              errorMessage = error.message;
            }

            // Show the error message in a SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(errorMessage,
                      style: const TextStyle(color: Colors.white))),
            );
          }

          // Navigate to UserDetailsScreen on successful login
          if (next is AsyncData && next.value!.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const EmployeeScreen(),
                // builder: (context) => const UserDetailsScreen(),
              ),
            );
          }
        });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.jpeg'),
                const SizedBox(height: 30),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Container(
                //     width: 160,
                //     child: DropdownButtonFormField<String>(
                //       decoration: InputDecoration(
                //         contentPadding:
                //             const EdgeInsets.symmetric(horizontal: 4),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //       ),
                //       hint: const Text('Pick an option'),
                //       items: diseaseMapping.keys
                //           .map((e) => DropdownMenuItem(
                //                 child: Text(e),
                //                 value: e,
                //               ))
                //           .toList(),
                //       onChanged: (value) {
                //         setState(() {
                //           _selectedDisease = diseaseMapping[value!];
                //           context
                //               .read<SelectedDiseaseProvider>()
                //               .setSelectedDisease(value);
                //         });
                //       },
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10),
                TextField(
                  controller: _useridController,
                  decoration: const InputDecoration(
                    labelText: 'Login ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: isObscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        },
                        icon: Icon(isObscure
                            ? Icons.visibility
                            : Icons.visibility_off)),
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loginState is AsyncLoading
                      ? null
                      : () async {
                    final userid = _useridController.text;
                    final password = _passwordController.text;

                    if (
                    // _selectedDisease != null &&
                    userid.isNotEmpty &&
                        password.isNotEmpty) {
                      await ref.read(loginStateProvider.notifier).login(
                          userid, password,
                          // _selectedDisease!,
                          context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'All fields are required',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(130, 50),
                      backgroundColor: Colors.blue),
                  child: loginState is AsyncLoading
                      ? const CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.blue),
                  )
                      : const Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ResetPasswordScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Reset Password',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
        ),
        // bottomNavigationBar: Container(
        //   color: Colors.red,
        //   height: 50,
        //   width: 200,
        // ),
      ),
    );
  }
}


