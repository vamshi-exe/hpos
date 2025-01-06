import 'dart:developer';

import 'package:employee_app/screens/center_details/center_details.dart';
import 'package:employee_app/services/api_service.dart';
import 'package:employee_app/utils/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<String> selectedNames = [];
  String selectedName = '';
  // void onNameSelected(String name) {
  //   setState(() {
  //     selectedName = name;
  //   });
  // }

  void onNameSelected(String name) {
    setState(() {
      if (selectedNames.contains(name)) {
        selectedNames.remove(name);
      } else {
        selectedNames.add(name);
      }
    });
  }

  final List<String> employeeNames = [
    'Aachal L. Varma',
    'Ashwini K. Saratkar',
    'Ashwini J. Shendre',
    'Shraddha M. Bhalme',
    'Nazmeen W. Khan',
    'Samiksha H. Badwaik',
    'Nisha D. Bawankar',
    'Megha S. Godghate',
    'Dipali K. Shinde',
    'Juhi S. Khobragade',
    'Ishika N. Fadtare',
    'Monali D. Ghodmare',
    'Saylee D. Ghatole',
    'Megha Y. Bansod',
    'Prachi S. Kuthe',
    'Astha R. Mendhe',
    'Pratiksha A. Kathane',
    'Neha C. Yelekar',
    'Damini U. Dhumankhede',
    'Snehal Talmale',
    'Bhagyashri Bhutekar',
    'Manisha Raut',
    'Pallavi Suryawanshi',
    'Payal Hatwar',
    'Pooja Choudhari',
    'Sakshi Babhare',
    'Shradha Zanzal',
    'Shruti Shendre',
    'Vaishnavi Sointakke',
    'Riya Singh Thakur',
    'Khushi Talmale',
    'Saloni Chlvane',
    'Ashwini Kathane',
    'Gayatri Yerekar',
    'Nida Sheikh',
    'Pranali Lohare',
    'Neha Ganorkar',
    'Srusti Agnihotri',
    'Anuksha Shende',
    'Urvashi Umale',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                child: const Text(
                  'Employee Name',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select Employee Name',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Employee List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView.builder(
                  itemCount: employeeNames.length,
                  itemBuilder: (context, index) {
                    return NameContainer(
                      name: employeeNames[index],
                      isSelected: selectedNames.contains(employeeNames[index]),
                      onTap: () => onNameSelected(employeeNames[index]),
                    );
                  },
                ),
              ),
            ),
            // "Continue" Button fixed at the bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(130, 50),
                    backgroundColor: Colors.blue),
                onPressed: selectedNames.isNotEmpty
                    ? () {
                        log(selectedNames.toString());
                        Utility.pushToNext(
                          context,
                          CenterDetailsScreen(employeeName: selectedNames),
                        );
                      }
                    : null, // Disable button if no name is selected
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NameContainer extends StatelessWidget {
  final String name;
  final bool isSelected;
  final VoidCallback onTap;
  const NameContainer({
    super.key,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(width: 0.5),
              color: isSelected ? Colors.blue[50] : null),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 20),
            ),
          )),
        ),
      ),
    );
  }
}
