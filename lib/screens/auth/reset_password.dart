import 'package:employee_app/screens/auth/login.dart';
import 'package:employee_app/screens/home/user_details.dart';
import 'package:employee_app/services/api_service.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpeg'),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Image.asset(
              //       'assets/logo1.png',
              //       height: 80,
              //       width: 80,
              //     ),
              //     SizedBox(width: 20),
              //     Image.asset(
              //       'assets/logo2.png',
              //       height: 80,
              //       width: 80,
              //     ),
              //   ],
              // ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Container(
              //     width: 160,
              //     child: DropdownButtonFormField<String>(
              //       decoration: InputDecoration(
              //         contentPadding: EdgeInsets.symmetric(horizontal: 6),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //       hint: Text('Pick an option'),
              //       items: ['Option 1', 'Option 2']
              //           .map((e) => DropdownMenuItem(
              //                 child: Text(e),
              //                 value: e,
              //               ))
              //           .toList(),
              //       onChanged: (value) {},
              //     ),
              //   ),
              // ),

              SizedBox(height: 10),
              TextField(
                controller: _useridController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ApiService().isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          ApiService().resetPassword(
                            _useridController.text,
                            _passwordController.text,
                            context,
                            onSuccess: () {},
                            onFailure: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Something went wrong'),
                                ),
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Password doesn't macth"),
                            ),
                          );
                        }
                      },
                      child: Text('RESET PASSWORD'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
