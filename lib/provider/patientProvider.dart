import 'dart:convert';
import 'package:employee_app/provider/selected_disease.dart';
import 'package:employee_app/screens/home/user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class PatientProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> submitPatientDetails(BuildContext context, List diseaseList) async {
    _setLoading(true);

    try {
      String? medication;
      String? bloodTransfusion;
      String? familyHistory;
      String? breastCancerMedication;
      String? breastFamilyHistory;
      String? ageAtMarriage;
      String? perCapitaIncome;
      String? literacyRate;
      String? parity;
      String? lmp;
      String? menopauseYears;
      String? ageOfFirstChild;
      String? vaccinationStatus;
      String? cervicalMedication;
      String? cervicalFamilyHistory;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? personName = prefs.getString('personName');
      String? abhaNumber = prefs.getString('abhaNumber');
      String? aadharNumber = prefs.getString('aadharNumber');
      String? birthYear = prefs.getString('birthYear');
      String? gender = prefs.getString('gender');
      String? mobileNumber = prefs.getString('mobileNumber');
      String? maritalStatus = prefs.getString('maritalStatus');
      String? category = prefs.getString('category');
      String? caste = prefs.getString('caste');
      String? subCaste = prefs.getString('subCaste');
      String? fatherName = prefs.getString('fatherName');
      String? motherName = prefs.getString('motherName');
      String? house = prefs.getString('house');
      String? city = prefs.getString('city');
      String? district = prefs.getString('district');
      String? state = prefs.getString('state');
      String? pincode = prefs.getString('pincode');
      String? centerName = prefs.getString('centerName');
      if (diseaseList.contains("sickleCell")) {
        medication = prefs.getString('medication');
        bloodTransfusion = prefs.getString('bloodTransfusion');
        familyHistory = prefs.getString('sickleFamilyHistory');
      }
      if (diseaseList.contains("breastCancer")) {
        breastCancerMedication = prefs.getString('breastMedication');
        breastFamilyHistory = prefs.getString('breastFamilyHistory');
      }
      if (diseaseList.contains("cervicalCancer")) {
        cervicalMedication = prefs.getString('cervicalMedication');
        cervicalFamilyHistory = prefs.getString('cervicalFamilyHistory');

        ageAtMarriage = prefs.getString('ageAtMarriage');
        perCapitaIncome = prefs.getString('perCapitaIncome');
        literacyRate = prefs.getString('literacyRate');
        parity = prefs.getString('parity');
        lmp = prefs.getString('lmp');
        menopauseYears = prefs.getString('menopauseYears');
        ageOfFirstChild = prefs.getString('ageFirstChild');
        vaccinationStatus = prefs.getString('vaccinationStatus');
      }

      // Commented out unused variables
      // String? familyHistoryDetails = prefs.getString('familyHistoryDetails');
      // List<String>? symptoms;
      // try {
      //   symptoms = List<String>.from(jsonDecode(prefs.getString('symptoms') ?? '[]'));
      // } catch (e) {
      //   symptoms = [];
      //   print('Error decoding symptoms: $e');
      // }

      String? imagePath = prefs.getString('userImagePath');
      File? userImage = imagePath != null ? File(imagePath) : null;

      final url = Uri.parse('https://hpos-mobile-flutter.onrender.com/api/patient');
      var request = http.MultipartRequest('POST', url);

      request.fields['personalName'] = personName ?? '';
      request.fields['aadhaarNumber'] = aadharNumber ?? '';
      request.fields['number'] = abhaNumber ?? '';
      request.fields['birthYear'] = birthYear ?? '';
      request.fields['gender'] = gender ?? '';
      request.fields['mobileNumber'] = mobileNumber ?? '';
      request.fields['maritalStatus'] = maritalStatus ?? '';
      request.fields['category'] = category ?? '';
      request.fields['caste'] = caste ?? '';
      request.fields['subCaste'] = subCaste ?? '';
      request.fields['fathersName'] = fatherName ?? '';
      request.fields['motherName'] = motherName ?? '';
      request.fields['address[house]'] = house ?? '';
      request.fields['address[pincode]'] = pincode ?? '';
      request.fields['address[state]'] = state ?? '';
      request.fields['address[district]'] = district ?? '';
      request.fields['address[city]'] = city ?? '';
      request.fields['centerName'] = centerName ?? '';
      request.fields['isUnderMedicationForSickle'] = medication == 'No' ? 'false' : 'true';
      request.fields['isUnderBloodTransfusionForSickle'] = bloodTransfusion == 'No' ? 'false' : 'true';
      request.fields['familyHistoryForSickle'] = familyHistory == 'No' ? 'false' : 'true';
      final selectedDiseaseProvider = Provider.of<SelectedDiseaseProvider>(context, listen: false);
      String? selectedDisease = selectedDiseaseProvider.selectedDisease;
      request.fields['disease'] = '["$selectedDisease"]';

      // Commented out unused fields
      // if (familyHistoryDetails != null) {
      //   request.fields['familyHistoryDetails'] = familyHistoryDetails;
      // }
      // if (symptoms != null) {
      //   request.fields['symptoms'] = jsonEncode(symptoms);
      // }
      // request.fields['ageAtMarriage'] = ageAtMarriage ?? '';
      // request.fields['perCapitaIncome'] = perCapitaIncome ?? '';
      // request.fields['literacyRate'] = literacyRate ?? '';
      // request.fields['parity'] = parity ?? '';
      // request.fields['ageOfFirstChild'] = ageOfFirstChild ?? '';
      // request.fields['vaccinationStatus'] = vaccinationStatus ?? '';

      if (userImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'userImage',
          userImage.path,
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserDetailsScreen()),
        );
        print('Patient details submitted successfully: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')),
        );
      } else {
        print('Failed to submit patient details: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form.')),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while submitting the form.')),
      );
    } finally {
      _setLoading(false);
    }
  }
}
