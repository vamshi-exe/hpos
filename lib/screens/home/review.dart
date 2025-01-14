import 'dart:convert';
import 'dart:developer';
import 'package:employee_app/provider/patientProvider.dart';
import 'package:employee_app/provider/selected_disease.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class FinalReviewScreen extends StatefulWidget {
  const FinalReviewScreen({super.key});

  @override
  _FinalReviewScreenState createState() => _FinalReviewScreenState();
}

class _FinalReviewScreenState extends State<FinalReviewScreen> {
  String? personName;
  String? abhaNumber;
  String? aadharNumber;
  String? centerName;
  String? birthYear;
  String? mobileNumber;
  String? fatherName;
  String? motherName;
  String? maritalStatus;
  String? category;
  String? caste;
  String? subCaste;
  String? house;
  String? city;
  String? district;
  String? state;
  String? pincode;
  String? gender;
  String? medication;
  String? breastCancerMedication;
  String? breastFamilyHistory;
  String? cervicalMedication;
  String? cervicalFamilyHistory;
  String? bloodTransfusion;
  String? familyHistory;
  // Commented out unused variables
  String? familyHistoryDetails;
  String? lmp;
  String? ageAtMarriage;
  String? perCapitaIncome;
  String? literacyRate;
  String? parity;
  String? menopauseYears;
  String? ageOfFirstChild;
  String? vaccinationStatus;
  List<dynamic>? symptoms;
  List<String>? diseaseList;

  File? userImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataFromPrefs();
    });
  }

  Future<void> _loadDataFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      personName = prefs.getString('personName');
      aadharNumber = prefs.getString('aadharNumber');
      abhaNumber = prefs.getString('abhaNumber');
      birthYear = prefs.getString('birthYear');
      gender = prefs.getString('gender');
      mobileNumber = prefs.getString('mobileNumber');
      maritalStatus = prefs.getString('maritalStatus');
      category = prefs.getString('category');
      caste = prefs.getString('caste');
      subCaste = prefs.getString('subCaste');
      fatherName = prefs.getString('fatherName');
      motherName = prefs.getString('motherName');
      house = prefs.getString('house');
      pincode = prefs.getString('pincode');
      state = prefs.getString('state');
      district = prefs.getString('district');
      city = prefs.getString('city');
      centerName = prefs.getString('centerName');
      medication = prefs.getString('sickleMedication');
      breastCancerMedication = prefs.getString('breastMedication');
      cervicalMedication = prefs.getString('cervicalMedication');

      bloodTransfusion = prefs.getString('bloodTransfusion');
      familyHistory = prefs.getString('sickleFamilyHistory');
      breastFamilyHistory = prefs.getString('breastFamilyHistory');
      cervicalFamilyHistory = prefs.getString('cervicalFamilyHistory');

      ageAtMarriage = prefs.getString('ageAtMarriage');
      perCapitaIncome = prefs.getString('perCapitaIncome');
      literacyRate = prefs.getString('literacyRate');
      parity = prefs.getString('parity');
      menopauseYears = prefs.getString('menopauseYears');
      ageOfFirstChild = prefs.getString('ageFirstChild');
      vaccinationStatus = prefs.getString('vaccinationStatus');
      lmp = prefs.getString('lmp');
      diseaseList = prefs.getStringList('diseaseList');
      symptoms =
          List<String>.from(jsonDecode(prefs.getString('symptoms') ?? '[]'));
      log(lmp.toString());

      String? imagePath = prefs.getString('userImagePath');
      if (imagePath != null) {
        userImage = File(imagePath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);
    final selectedDiseaseProvider =
        Provider.of<SelectedDiseaseProvider>(context);
    String? selectedDisease = selectedDiseaseProvider.selectedDisease;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (userImage != null)
                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: FileImage(userImage!),
                  ),
                )
              else
                const CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.person, size: 80),
                ),
              const SizedBox(height: 20),
              const Text(
                'User Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              if (selectedDisease != null)
                _buildDataRow('Selected Disease:', diseaseList?.join(', ')),
              _buildDataRow('Person Name:', personName),
              _buildDataRow('Aadhar Number:', aadharNumber),
              _buildDataRow('Abha Number:', abhaNumber),
              _buildDataRow('Birth Year:', birthYear),
              _buildDataRow('Gender:', gender),
              _buildDataRow('Mobile Number:', mobileNumber),
              _buildDataRow('Marital Status:', maritalStatus),
              _buildDataRow('Category:', category),
              _buildDataRow('Caste:', caste),
              _buildDataRow('Sub Caste:', subCaste),
              _buildDataRow('Father Name:', fatherName),
              _buildDataRow('Mother Name:', motherName),
              _buildDataRow('House:', house),
              _buildDataRow('Pincode:', pincode),
              _buildDataRow('State:', state),
              _buildDataRow('District:', district),
              _buildDataRow('City/Town:', city),
              _buildDataRow('Center Name:', centerName),
              Visibility(
                visible: diseaseList?.contains('sickleCell') ?? false,
                // medication?.isNotEmpty ?? false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDataRow(
                        'Is Under Medication for Sickle Cell:', medication),
                    _buildDataRow('Is Under Blood Transfusion for Sickel Cell:',
                        bloodTransfusion),
                    _buildDataRow('Sickle Cell Family History:', familyHistory),
                  ],
                ),
              ),

              Visibility(
                visible: diseaseList?.contains('breastCancer') ?? false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDataRow('Is Under Medication for Breast Cancer:',
                        breastCancerMedication),
                    _buildDataRow(
                        'Breast Cancer Family History:', breastFamilyHistory),
                  ],
                ),
              ),

              // Commented out unused fields
              Visibility(
                visible: lmp?.isNotEmpty ?? false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildDataRow('Is Under Medication for Cervical Cancer:',
                        cervicalMedication),
                    _buildDataRow('Cervical Cancer Family History:',
                        cervicalFamilyHistory),
                    _buildDataRow('Last Menstrual Period (LMP):', lmp),
                    _buildDataRow('Age at Marriage:', ageAtMarriage),
                    _buildDataRow('Per Capita Income:', perCapitaIncome),
                    _buildDataRow('Literacy Rate:', literacyRate),
                    _buildDataRow('Parity:', parity),
                    if (menopauseYears != null && menopauseYears!.isNotEmpty)
                      _buildDataRow(
                          'Menopause Status:', 'Yes, $menopauseYears years'),
                    _buildDataRow('Age of First Child:', ageOfFirstChild),
                    _buildDataRow('Vaccination Status:', vaccinationStatus),
                    _buildDataRow('Symptoms:', symptoms?.join(', ')),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              if (patientProvider.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(120, 40),
                    ),
                    child: const Text(
                      'EDIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: patientProvider.isLoading
                        ? null
                        : () {
                            patientProvider.submitPatientDetails(
                                context, diseaseList!);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          patientProvider.isLoading ? Colors.grey : Colors.blue,
                      minimumSize: const Size(120, 40),
                    ),
                    child: Text(
                      patientProvider.isLoading ? 'Submitting...' : 'PROCEED',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
