import 'package:employee_app/provider/selected_disease.dart';
import 'package:employee_app/provider/user_provider.dart';
import 'package:employee_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CenterDetailsScreen extends StatefulWidget {
  final List employeeName;
  const CenterDetailsScreen({super.key, required this.employeeName});

  @override
  State<CenterDetailsScreen> createState() => _CenterDetailsScreenState();
}

class _CenterDetailsScreenState extends State<CenterDetailsScreen> {
  // TextEditingController centerNameController = TextEditingController();
  TextEditingController centerIdController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController serialController = TextEditingController();
  String? selectedCenter;

  bool _isCenterIdVisible = false;

  bool _isPinCodeValid() {
    return pinCodeController.text.length == 6;
  }

  bool _areFieldsFilled() {
    return selectedCenter!.isNotEmpty &&
        centerIdController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        pinCodeController.text.isNotEmpty &&
        serialController.text.isNotEmpty &&
        _isPinCodeValid();
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Incomplete Information"),
          content: const Text("Please fill in all fields before continuing."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCenterId(BuildContext context) async {
    // final centerName = centerNameController.text;
    if (selectedCenter!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the center name first'),
        ),
      );
      return;
    }

    try {
      final url = Uri.parse(
          'https://hpos-mobile-flutter.onrender.com/api/centerCode/getCenterCode');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'centerName': selectedCenter,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        setState(() {
          centerIdController.text = responseData['centerCode'] ?? '';
          _isCenterIdVisible = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Center ID fetched successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch center ID'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while fetching center ID'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final centername = Provider.of<UserProvider>(context, listen: false)
        .user!
        .userDetails
        .centerName;
    Provider.of<ApiService>(context, listen: false).fetchCenterNames();

    // centerNameController.text = centername;
  }

  @override
  Widget build(BuildContext context) {
    final centerProvider = Provider.of<CenterProvider>(context);

    var centerNameProvider = Provider.of<ApiService>(context);
    var token = Provider.of<UserProvider>(context, listen: false).token;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: const Text(
                    'Center Details',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.07,
              ),
              centerNameProvider.centerNames.isEmpty
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Container(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: "Select Center",
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedCenter,
                                items: centerNameProvider.centerNames
                                    .where((center) =>
                                        center.centerName.isNotEmpty)
                                    .map((center) {
                                  return DropdownMenuItem<String>(
                                    value: center.centerName,
                                    child: Text(center.centerName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedCenter = value;
                                    _getCenterId(context);
                                    centerProvider.setSelectedCenter(value);
                                  });
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isCenterIdVisible,
                            child: CustomTextfield(
                              textEditingController: centerIdController,
                              labelText: 'Center ID',
                              isEnabled: false,
                            ),
                          ),
                          CustomTextfield(
                            textEditingController: locationController,
                            labelText: 'Enter Location',
                          ),
                          CustomTextfield(
                            textEditingController: pinCodeController,
                            labelText: 'Enter Pin Code',
                            textInputType: TextInputType.number,
                          ),
                          CustomTextfield(
                            textEditingController: serialController,
                            labelText: 'Enter Device Serial Number',
                          ),
                        ],
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(130, 50),
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  if (_areFieldsFilled()) {
                    ApiService().centerDetail(
                      selectedCenter!,
                      centerIdController.text,
                      locationController.text,
                      pinCodeController.text,
                      serialController.text,
                      context,
                      token!,
                      onFailure: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Something went wrong'),
                          ),
                        );
                      },
                    );
                  } else {
                    if (!_isPinCodeValid()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pin code must be exactly 6 digits.'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please fill in all fields before continuing.'),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextfield extends StatelessWidget {
  final String labelText;
  final TextEditingController textEditingController;
  final TextInputType? textInputType;
  final bool? isEnabled;
  final Widget? suffixIcon;
  const CustomTextfield({
    super.key,
    required this.textEditingController,
    required this.labelText,
    this.textInputType,
    this.isEnabled = true,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: TextField(
        enabled: isEnabled,
        keyboardType: textInputType,
        inputFormatters: textInputType == TextInputType.number
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6)
              ]
            : null,
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
