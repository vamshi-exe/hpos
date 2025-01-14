import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:employee_app/model/caste_model.dart';
import 'package:employee_app/model/category_model.dart';
import 'package:employee_app/model/center_name_model.dart';
import 'package:employee_app/model/patient_detail.dart';
import 'package:employee_app/model/subject_model.dart';
import 'package:employee_app/model/user_model.dart';
import 'package:employee_app/provider/user_provider.dart';
import 'package:employee_app/screens/auth/login.dart';
import 'package:employee_app/screens/home/user_details.dart';
import 'package:employee_app/utils/exceptions.dart';
import 'package:employee_app/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends ChangeNotifier {
  List<CenterName> _centerNames = [];
  List<CenterName> get centerNames => _centerNames;

  List<String> _casteNames = [];
  List<String> get casteNames => _casteNames;

  List<String> _categoryNames = [];
  List<String> get categoryNames => _categoryNames;

  bool isLoading = false;
  // final String baseUrl = 'https://hposapi.talentrisetechnokrate.com';
  final String baseUrl = 'https://hposapi.talentrisetechnokrate.com';

  Future<Map<String, dynamic>> login(
      String userid,
      String password,
      // String disease,
      BuildContext context) async {
    final url = Uri.parse('$baseUrl/api/auth/login');
    var body = {
      'userid': userid,
      'password': password,
      // 'disease': disease,
    };
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (kDebugMode) {
      print(jsonEncode(body));
      print(response.body);
    }
    final json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      UserModel userModel = UserModel.fromJson(json);
      Provider.of<UserProvider>(context, listen: false).setUser(userModel);

      print(
          'User token: ${Provider.of<UserProvider>(context, listen: false).token}');
      print(response.body);
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw InvalidCredentialsException('Invalid username or password.');
    } else {
      throw InvalidCredentialsException(response.body[0]);
    }
  }

  Future<void> resetPassword(
      String userId, String password, BuildContext context,
      {required Function() onSuccess, required Function() onFailure}) async {
    final url = Uri.parse('$baseUrl/api/auth/reset-password');
    var body = {
      'employeName': userId,
      'newPassword': password,
      'confirmPassword': password,
    };
    isLoading = true;
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      onSuccess;
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
      isLoading = false;
      notifyListeners();
    } else {
      onFailure;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> centerDetail(String centerName, String centerId, String location,
      String pinCode, String serialNumber, BuildContext context, String token,
      {Function()? onSuccess, Function()? onFailure}) async {
    final url = Uri.parse('$baseUrl/api/sight-details');
    var body = {
      "centerName": centerName.toString(),
      "centerID": centerId.toString(),
      "location": location.toString(),
      "pinCode": pinCode.toString(),
      "deviceSerialNumber": serialNumber.toString(),
    };
    isLoading = true;
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    print(jsonEncode(body));
    print(token);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      onSuccess;
      Utility.pushToNext(
        context,
        const UserDetailsScreen(),
      );

      isLoading = false;
      notifyListeners();
    } else {
      onFailure;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitPatientDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve saved form data from SharedPreferences
    String? personName = prefs.getString('personName');
    String? abhaNumber = prefs.getString('abhaNumber');
    String? aadharNumber = prefs.getString('aadharNumber');
    String? centerName = prefs.getString('centerName');

    String? birthYear = prefs.getString('birthYear');
    String? mobileNumber = prefs.getString('mobileNumber');
    String? fatherName = prefs.getString('fatherName');
    String? maritalStatus = prefs.getString('maritalStatus');
    String? category = prefs.getString('category');
    String? caste = prefs.getString('caste');
    String? subCaste = prefs.getString('subCaste');
    String? house = prefs.getString('house');
    String? city = prefs.getString('city');
    String? district = prefs.getString('district');
    String? state = prefs.getString('state');
    String? pincode = prefs.getString('pincode');
    String? gender = prefs.getString('gender');
    String? medication = prefs.getString('medication');
    String? bloodTransfusion = prefs.getString('bloodTransfusion');
    String? familyHistory = prefs.getString('familyHistory');
    List<String>? diseaseList = prefs.getStringList('diseaseList');
    String? familyHistoryDetails = prefs.getString('familyHistoryDetails');

    String? imagePath = prefs.getString('userImagePath');
    File? userImage = imagePath != null ? File(imagePath) : null;

    final url = Uri.parse('$baseUrl/api/patient');

    // Prepare the request body using MultipartRequest
    final request = await http.MultipartRequest('POST', url);

    // Adding text fields to the request body
    request.fields['personalName'] = personName ?? '';
    request.fields['number'] = abhaNumber ?? '';
    request.fields['aadhaarNumber'] = aadharNumber ?? '';
    request.fields['centerName'] = centerName ?? '';
    request.fields['birthYear'] = birthYear ?? '';
    request.fields['mobileNumber'] = mobileNumber ?? '';
    request.fields['fathersName'] = fatherName ?? '';
    request.fields['maritalStatus'] = maritalStatus ?? '';
    request.fields['category'] = category ?? '';
    request.fields['caste'] = caste ?? '';
    request.fields['subCaste'] = subCaste ?? '';
    request.fields['address[house]'] = house ?? '';
    request.fields['address[city]'] = city ?? '';
    request.fields['address[district]'] = district ?? '';
    request.fields['address[state]'] = state ?? '';
    request.fields['address[pincode]'] = pincode ?? '';
    request.fields['gender'] = gender ?? '';
    request.fields['isUnderMedication'] = medication ?? '';
    request.fields['isUnderBloodTransfusion'] = bloodTransfusion ?? '';
    request.fields['familyHistory'] = familyHistory ?? '';
    request.fields['disease'] = jsonEncode(diseaseList);
    if (familyHistoryDetails != null) {
      request.fields['familyHistoryDetails'] = familyHistoryDetails;
    }

    // Adding image to the request if it's available
    if (userImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'userImage',
        userImage.path,
      ));
    }
  }

  Future<http.StreamedResponse> submitPatientDataForCervicalCancer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve saved form data from SharedPreferences
    String? personName = prefs.getString('personName');
    String? abhaNumber = prefs.getString('abhaNumber');
    String? aadharNumber = prefs.getString('aadharNumber');
    String? centerName = prefs.getString('centerName');

    String? birthYear = prefs.getString('birthYear');
    String? mobileNumber = prefs.getString('mobileNumber');
    String? fatherName = prefs.getString('fatherName');
    String? motherName = prefs.getString('motherName');
    String? maritalStatus = prefs.getString('maritalStatus');
    String? category = prefs.getString('category');
    String? caste = prefs.getString('caste');
    String? subCaste = prefs.getString('subCaste');
    String? house = prefs.getString('house');
    String? city = prefs.getString('city');
    String? district = prefs.getString('district');
    String? state = prefs.getString('state');
    String? pincode = prefs.getString('pincode');
    String? gender = prefs.getString('gender');
    String? medication = prefs.getString('medication');
    String? bloodTransfusion = prefs.getString('bloodTransfusion');
    String? familyHistory = prefs.getString('familyHistory');
    List<String>? diseaseList = prefs.getStringList('diseaseList');
    String? familyHistoryDetails = prefs.getString('familyHistoryDetails');
    String? ageAtMarriage = prefs.getString('ageAtMarriage');
    String? perCapitaIncome = prefs.getString('perCapitaIncome');
    String? literacyRate = prefs.getString('literacyRate');
    String? parity = prefs.getString('parity');
    String? menopauseYears = prefs.getString('menopauseYears');
    String? ageFirstChild = prefs.getString('ageFirstChild');
    String? vaccinationStatus = prefs.getString('vaccinationStatus');
    String? lmp = prefs.getString('lmp');

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://hpos-mobile-flutter-nodejs-node.onrender.com/api/patient'));
    request.fields.addAll({
      'personalName': personName ?? '',
      'aadhaarNumber': aadharNumber ?? '',
      'number': abhaNumber ?? '',
      'birthYear': birthYear ?? '',
      'gender': gender ?? '',
      'mobileNumber': mobileNumber ?? '',
      'maritalStatus': maritalStatus ?? '',
      'category': category ?? '',
      'caste': caste ?? '',
      'subCaste': subCaste ?? '',
      'fathersName': fatherName ?? '',
      'motherName': motherName ?? '',
      'address[house]': house ?? '',
      'address[pincode]': pincode ?? '',
      'address[state]': state ?? '',
      'address[district]': city ?? '',
      'address[city]': district ?? '',
      'centerName': centerName ?? '',
      'isUnderMedicationForCervical': medication == "Yes" ? 'true' : 'false',
      'isUnderBloodTransfusionForCervical':
          bloodTransfusion == "Yes" ? 'true' : 'false',
      'familyHistoryForCervical': familyHistory == "Yes" ? 'true' : 'false',
      'disease': jsonEncode(diseaseList),
      'ageAtMarried': ageAtMarriage ?? '',
      'perCapitaIncome': perCapitaIncome ?? '',
      'literacyRate': literacyRate ?? '',
      'parity': parity ?? '',
      'menoPauseStatus': '{"LMP":"$lmp", "havingMenopause":"$menopauseYears"}',
      'ageOfFirstChild': ageFirstChild ?? '',
      'vaccinationStatus': vaccinationStatus ?? ''
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(
          "response===============> ${await response.stream.bytesToString()}");
      print("success");
      return response;
    } else {
      print("errorrrrrrrrrr ${await response.stream.bytesToString()}");
      return response;
    }
  }

  Future<http.StreamedResponse> submitPatientDataForSickleCell() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve saved form data from SharedPreferences
    String? personName = prefs.getString('personName');
    String? abhaNumber = prefs.getString('abhaNumber');
    String? aadharNumber = prefs.getString('aadharNumber');
    String? centerName = prefs.getString('centerName');

    String? birthYear = prefs.getString('birthYear');
    String? mobileNumber = prefs.getString('mobileNumber');
    String? fatherName = prefs.getString('fatherName');
    String? motherName = prefs.getString('motherName');
    String? maritalStatus = prefs.getString('maritalStatus');
    String? category = prefs.getString('category');
    String? caste = prefs.getString('caste');
    String? subCaste = prefs.getString('subCaste');
    String? house = prefs.getString('house');
    String? city = prefs.getString('city');
    String? district = prefs.getString('district');
    String? state = prefs.getString('state');
    String? pincode = prefs.getString('pincode');
    String? gender = prefs.getString('gender');
    String? medication = prefs.getString('medication');
    String? bloodTransfusion = prefs.getString('bloodTransfusion');
    String? familyHistory = prefs.getString('familyHistory');
    List<String>? diseaseList = prefs.getStringList('diseaseList');
    // String? familyHistoryDetails = prefs.getString('familyHistoryDetails');
    // String? ageAtMarriage = prefs.getString('ageAtMarriage');
    // String? perCapitaIncome = prefs.getString('perCapitaIncome');
    // String? literacyRate = prefs.getString('literacyRate');
    // String? parity = prefs.getString('parity');
    // String? menopauseYears = prefs.getString('menopauseYears');
    // String? ageFirstChild = prefs.getString('ageFirstChild');
    // String? vaccinationStatus = prefs.getString('vaccinationStatus');
    // String? lmp = prefs.getString('lmp');

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://hpos-mobile-flutter-nodejs-node.onrender.com/api/patient'));
    request.fields.addAll({
      'personalName': personName ?? '',
      'aadhaarNumber': aadharNumber ?? '',
      'number': abhaNumber ?? '',
      'birthYear': birthYear ?? '',
      'gender': gender ?? '',
      'mobileNumber': mobileNumber ?? '',
      'maritalStatus': maritalStatus ?? '',
      'category': category ?? '',
      'caste': caste ?? '',
      'subCaste': subCaste ?? '',
      'fathersName': fatherName ?? '',
      'motherName': motherName ?? '',
      'address[house]': house ?? '',
      'address[pincode]': pincode ?? '',
      'address[state]': state ?? '',
      'address[district]': city ?? '',
      'address[city]': district ?? '',
      'centerName': centerName ?? '',
      'isUnderMedicationForSickle': medication == "Yes" ? 'true' : 'false',
      'isUnderBloodTransfusionForSickle':
          bloodTransfusion == "Yes" ? 'true' : 'false',
      'familyHistoryForSickle': familyHistory == "Yes" ? 'true' : 'false',
      'disease': jsonEncode(diseaseList),
    });
    print("sickle cell request ${request.fields}");
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(
          "sickle cell response===============> ${await response.stream.bytesToString()}");
      print("success");
      return response;
    } else {
      print(
          "sickle cell errorrrrrrrrrr ${await response.stream.bytesToString()}");
      return response;
    }
  }

  Future<http.StreamedResponse> submitPatientDataNew() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve saved form data from SharedPreferences
    String? personName = prefs.getString('personName');
    String? abhaNumber = prefs.getString('abhaNumber');
    String? aadharNumber = prefs.getString('aadharNumber');
    String? centerName = prefs.getString('centerName');

    String? birthYear = prefs.getString('birthYear');
    String? mobileNumber = prefs.getString('mobileNumber');
    String? fatherName = prefs.getString('fatherName');
    String? motherName = prefs.getString('motherName');
    String? maritalStatus = prefs.getString('maritalStatus');
    String? category = prefs.getString('category');
    String? caste = prefs.getString('caste');
    String? subCaste = prefs.getString('subCaste');
    String? house = prefs.getString('house');
    String? city = prefs.getString('city');
    String? district = prefs.getString('district');
    String? state = prefs.getString('state');
    String? pincode = prefs.getString('pincode');
    String? gender = prefs.getString('gender');
    String? medication = prefs.getString('medication');
    String? cervicalMedication = prefs.getString('cervicalMedication');
    String? sickleMedication = prefs.getString('sickleMedication');
    String? breastMedication = prefs.getString('breastMedication');
    // String? bloodTransfusion = prefs.getString('bloodTransfusion');
    String? familyHistory = prefs.getString('familyHistory');
    String? sickleFamilyHistory = prefs.getString('sickleFamilyHistory');
    String? cervicalFamilyHistory = prefs.getString('cervicalFamilyHistory');
    String? breastFamilyHistory = prefs.getString('breastFamilyHistory');
    String? bloodTransfusionForCervical =
        prefs.getString('bloodTransfusionForCervical');
    String? bloodTransfusionForSickle =
        prefs.getString('bloodTransfusionForSickle');
    String? bloodTransfusionForBreast =
        prefs.getString('bloodTransfusionForBreast');
    List<String>? diseaseList = prefs.getStringList('diseaseList');
    // String? familyHistoryDetails = prefs.getString('familyHistoryDetails');
    String? ageAtMarriage = prefs.getString('ageAtMarriage');
    String? perCapitaIncome = prefs.getString('perCapitaIncome');
    String? literacyRate = prefs.getString('literacyRate');
    String? parity = prefs.getString('parity');
    String? menopauseYears = prefs.getString('menopauseYears');
    String? ageFirstChild = prefs.getString('ageFirstChild');
    String? vaccinationStatus = prefs.getString('vaccinationStatus');
    String? lmp = prefs.getString('lmp');

    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/patient'));
    request.fields.addAll({
      'personalName': personName ?? '',
      'aadhaarNumber': aadharNumber ?? '',
      'number': abhaNumber ?? '',
      'birthYear': birthYear ?? '',
      'gender': gender ?? '',
      'mobileNumber': mobileNumber ?? '',
      'maritalStatus': maritalStatus ?? '',
      'category': category ?? '',
      'caste': caste ?? '',
      'subCaste': subCaste ?? '',
      'fathersName': fatherName ?? '',
      'motherName': motherName ?? '',
      'address[house]': house ?? '',
      'address[pincode]': pincode ?? '',
      'address[state]': state ?? '',
      'address[district]': city ?? '',
      'address[city]': district ?? '',
      'centerName': centerName ?? '',
      'isUnderMedicationForSickle':
          sickleMedication == "Yes" ? 'true' : 'false',
      'isUnderMedicationForBreast':
          breastMedication == "Yes" ? 'true' : 'false',
      'isUnderMedicationForCervical':
          cervicalMedication == "Yes" ? 'true' : 'false',
      'familyHistoryForSickle': sickleFamilyHistory == "Yes" ? 'true' : 'false',
      'familyHistoryForCervical':
          cervicalFamilyHistory == "Yes" ? 'true' : 'false',
      'familyHistoryForBreast': breastFamilyHistory == "Yes" ? 'true' : 'false',
      // 'isUnderBloodTransfusionForBreast': bloodTransfusionForBreast == "Yes" ? 'true' : 'false',
      // 'isUnderBloodTransfusionForCervical': bloodTransfusionForCervical == "Yes" ? 'true' : 'false',
      'isUnderBloodTransfusionForSickle':
          bloodTransfusionForSickle == "Yes" ? 'true' : 'false',
      'disease': jsonEncode(diseaseList),
      'ageAtMarried': ageAtMarriage ?? '',
      'perCapitaIncome': perCapitaIncome ?? '',
      'literacyRate': literacyRate ?? '',
      'parity': parity ?? '',
      'menoPauseStatus': '{"LMP":"$lmp", "havingMenopause":"$menopauseYears"}',
      'ageOfFirstChild': ageFirstChild ?? '',
      'vaccinationStatus': vaccinationStatus ?? ''
    });

    http.StreamedResponse response = await request.send();
    print("dfdfdf =====>>>>> ${response}");

    // Collect response body
    // final responseBody = await response.stream.bytesToString();
    // print("Full response object: =====>>>>> $responseBody");

    if (response.statusCode == 201) {
      print(
          "response===============> ${await response.stream.bytesToString()}");
      print("success");
      return response;
    } else {
      print("errorrrrrrrrrr ${await response.stream.bytesToString()}");
      return response;
    }
  }

  Future<void> fetchCenterNames() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/centerCode/getCenterName'));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      log(response.body);
      CenterNameListResponse centerListResponse =
          CenterNameListResponse.fromJson(jsonResponse);
      _centerNames = centerListResponse.centerNameList;

      notifyListeners();
    } else {
      throw Exception('Failed to load center names');
    }
  }

  Future<void> fetchCasteNames() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/casteAndCategory/getCaste'));

    if (response.statusCode == 200) {
      log(response.body);
      var jsonResponse = json.decode(response.body);
      CasteListResponse casteListResponse =
          CasteListResponse.fromJson(jsonResponse);
      _casteNames = casteListResponse.casteList.first.names;
      notifyListeners();
    } else {
      throw Exception('Failed to load caste names');
    }
  }

  Future<void> fetchCategory() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/casteAndCategory/getCategory'));

    if (response.statusCode == 200) {
      log(response.body);
      var jsonResponse = json.decode(response.body);
      CategoryListResponse categoryListResponse =
          CategoryListResponse.fromJson(jsonResponse);
      _categoryNames = categoryListResponse.categoryList.first.names;
      notifyListeners();
    } else {
      throw Exception('Failed to load caste names');
    }
  }

  Future<void> addCaste(String caste) async {
    final url = Uri.parse(
        'https://hposapi.talentrisetechnokrate.com/api/casteAndCategory/addCaste');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': caste}),
      );

      if (response.statusCode == 200) {
        print('Caste added successfully');
      } else {
        print('Failed to add caste: ${response.body}');
        throw Exception('Failed to add caste: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error while adding caste: $e');
      throw Exception('Error while adding caste: $e');
    }
  }

  // Method to add a new category
  Future<void> addCategory(String category) async {
    final url = Uri.parse(
        'https://hposapi.talentrisetechnokrate.com/api/casteAndCategory/addCategory');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'name': category}),
      );

      if (response.statusCode == 200) {
        print('Category added successfully');
      } else {
        print('Failed to add category: ${response.body}');
        throw Exception('Failed to add category: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error while adding category: $e');
      throw Exception('Error while adding category: $e');
    }
  }

  Future<List<SubjectDetail>> fetchPatients() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      return subjectDetailFromMap(response.body);
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<List<PatientDetail>> fetchPatientsByCenter(String centerName) async {
    final url = Uri.parse('$baseUrl/api/patient?centerName=$centerName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return patientDetailFromJson(response.body);
      } else {
        throw Exception('Failed to load patient details');
      }
    } catch (e) {
      print('Error fetching patient details: $e');
      throw Exception('Error fetching patient details: $e');
    }
  }
}
