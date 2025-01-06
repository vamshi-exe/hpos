import 'package:employee_app/screens/home/personDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/selected_disease.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController abhaController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController centerController = TextEditingController();

  Future<void> saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('personName', nameController.text);
    await prefs.setString('abhaNumber', abhaController.text);
    await prefs.setString('aadharNumber', aadharController.text);
    await prefs.setString('centerName', centerController.text);
    await prefs.setStringList('diseaseList', diseaseArray);
    final selectedDiseaseProvider =
        Provider.of<SelectedDiseaseProvider>(context, listen: false);
    if (diseaseArray.isNotEmpty) {
      selectedDiseaseProvider.setSelectedDisease(diseaseArray[0]);
    }
    print("Disease list saved: $diseaseArray");
  }

  void _showAlertDialog(BuildContext context, String missingFields) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Incomplete Information"),
          content: Text("Please fill in the following fields: $missingFields"),
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

  bool _isAbhaNumberValid() {
    return abhaController.text.length == 14;
  }

  bool _isAadharNumberValid() {
    return aadharController.text.length == 12;
  }

  void _validateAndProceed(BuildContext context) {
    String errorMessage = "";

    if (diseaseArray.isEmpty) {
      errorMessage += "Select Disease.\n";
    }
    if (nameController.text.isEmpty) {
      errorMessage += "Person's Name is required.\n";
    }
    if (abhaController.text.isEmpty) {
      errorMessage += "ABHA Number is required.\n";
    } else if (!_isAbhaNumberValid()) {
      errorMessage += "ABHA Number must be exactly 14 digits.\n";
    }
    if (aadharController.text.isEmpty) {
      errorMessage += "Aadhar Number is required.\n";
    } else if (!_isAadharNumberValid()) {
      errorMessage += "Aadhar Number must be exactly 12 digits.\n";
    }
    if (centerController.text.isEmpty) {
      errorMessage += "Center Name is required.\n";
    }

    if (errorMessage.isNotEmpty) {
      _showAlertDialog(context, errorMessage.trim());
    } else {
      saveFormData();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonDetailsScreen(diseaseArray: diseaseArray),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    String? selectedcenter = context.read<CenterProvider>().selectedCenter;
    centerController.text = selectedcenter!;
  }

  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;

  List<String> diseaseArray = [];

  void updateSelectedDisease(bool isChecked, String option) {
    final selectedDiseaseProvider =
        Provider.of<SelectedDiseaseProvider>(context, listen: false);
    setState(() {
      if (isChecked) {
        if (!diseaseArray.contains(option)) {
          diseaseArray.add(option);
          selectedDiseaseProvider.setSelectedDisease(option);
        }
      } else {
        diseaseArray.remove(option);
        if (diseaseArray.isEmpty) {
          selectedDiseaseProvider.setSelectedDisease(null);
        } else {
          selectedDiseaseProvider.setSelectedDisease(diseaseArray[0]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? selectedDisease =
        context.watch<SelectedDiseaseProvider>().selectedDisease;

    // setState(() {});

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // title: Row(
        //   children: [
        //     Container(
        //       padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        //       decoration: BoxDecoration(
        //         color: Colors.blue[100],
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       child: Text(
        //         "$selectedDisease",
        //         style: const TextStyle(
        //           color: Colors.black,
        //           fontSize: 12,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Scan Person ABHA ID/Aadhar ID Card',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 10),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     // Handle scan button press
              //   },
              //   icon: const Icon(Icons.qr_code_scanner),
              //   label: const Text('SCAN NOW'),
              //   style: ElevatedButton.styleFrom(
              //     foregroundColor: Colors.black,
              //     backgroundColor: Colors.blue[100],
              //     minimumSize: const Size(30, 30),
              //     textStyle: const TextStyle(fontWeight: FontWeight.bold),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 20),

              // OR Divider
              // const Row(
              //   children: [
              //     Expanded(
              //       child: Divider(thickness: 1),
              //     ),
              //     Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 8.0),
              //       child: Text(
              //         'OR',
              //         style: TextStyle(color: Colors.grey),
              //       ),
              //     ),
              //     Expanded(
              //       child: Divider(thickness: 1),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked1,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked1 = value ?? false;
                              updateSelectedDisease(isChecked1, "sickleCell");
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                isChecked1 = !isChecked1;
                                updateSelectedDisease(isChecked1, "sickleCell");
                              });
                            },
                            child: Text(
                              "Sickle Cell",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked2,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked2 = value ?? false;
                              updateSelectedDisease(isChecked2, "breastCancer");
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                isChecked2 = !isChecked2;
                                updateSelectedDisease(
                                    isChecked2, "breastCancer");
                              });
                            },
                            child: Text(
                              "Breast cancer",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked3,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked3 = value ?? false;
                              updateSelectedDisease(
                                  isChecked3, "cervicalCancer");
                            });
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                isChecked3 = !isChecked3;
                                updateSelectedDisease(
                                    isChecked3, "cervicalCancer");
                              });
                            },
                            child: Text(
                              "Cervical cancer",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                'Enter ABHA and Aadhar Number',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Person’s Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: abhaController,
                inputFormatters: [LengthLimitingTextInputFormatter(14)],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ABHA Number *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: aadharController,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(12),
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Aadhar Number *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Text("$selectedcenter"),
              TextField(
                enabled: false,
                controller: centerController,
                decoration: const InputDecoration(
                  labelText: 'Center Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _validateAndProceed(context);
                  },
                  child: const Text('PROCEED'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue[300],
                    minimumSize: const Size(130, 50),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan Person ABHA ID/Aadhar ID Card',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () {
                  // Handle scan button press
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('SCAN NOW'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.blue[100],
                  minimumSize: const Size(30, 30),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Create ABHA ID card',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle create ABHA ID card button
                },
                child: const Text('CLICK HERE'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[300],
                  minimumSize: const Size(30, 30),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
