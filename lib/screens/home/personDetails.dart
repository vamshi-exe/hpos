import 'dart:convert';
import 'dart:developer';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:employee_app/screens/home/capture_image.dart';
import 'package:employee_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PersonDetailsScreen extends StatefulWidget {
  final List<String>? diseaseArray;
  const PersonDetailsScreen({super.key, this.diseaseArray});

  @override
  _PersonDetailsScreenState createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  String? _gender = 'Male';
  String? _medication = 'No';
  String? _cervicalMedication = 'No';
  String? _sickleMedication = 'No';
  String? _breastMedication = 'No';
  String? _bloodTransfusion = 'No';
  String? _bloodTransfusionForCervical = 'No';
  String? _bloodTransfusionForSickle = 'No';
  String? _bloodTransfusionForBreast = 'No';
  String? _familyHistory = 'No';
  String? _cervicalFamilyHistory = 'No';
  String? _sickleFamilyHistory = 'No';
  String? _breastFamilyHistory = 'No';
  bool showFamilyHistoryField = false;
  bool showCervicalFamilyHistoryField = false;
  bool showSickleFamilyHistoryField = false;
  bool showBreastFamilyHistoryField = false;

  final TextEditingController birthYearController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController subCasteController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController incomeControlller = TextEditingController();
  final TextEditingController familyHistoryController = TextEditingController();
  final TextEditingController lmpController = TextEditingController();
  final TextEditingController menopauseYearsController =
      TextEditingController();
  final TextEditingController ageFirstChildController = TextEditingController();
  final TextEditingController othersforSymptoms = TextEditingController();

  String? maritalStatus;
  String? category;
  String? caste;

  List<String> _symptoms = [];
  String? _ageAtMarriage;
  String? _literacyRate;
  String? _parity;
  String? _menopauseStatus;
  String? _vaccinationStatus;

  void toggleSymptom(String symptom, bool isSelected) {
    setState(() {
      if (isSelected) {
        _symptoms.add(symptom);
      } else {
        _symptoms.remove(symptom);
      }
    });
  }

  Future<void> saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('birthYear', birthYearController.text);
    await prefs.setString('gender', _gender!);
    await prefs.setString('mobileNumber', mobileNumberController.text);
    await prefs.setString('fatherName', fatherNameController.text);
    await prefs.setString('motherName', motherNameController.text);
    await prefs.setString('maritalStatus', maritalStatus ?? '');
    await prefs.setString('category', category ?? '');
    await prefs.setString('caste', caste ?? '');
    await prefs.setString('subCaste', subCasteController.text);
    await prefs.setString('house', houseController.text);
    await prefs.setString('city', cityController.text);
    await prefs.setString('district', districtController.text);
    await prefs.setString('state', stateController.text);
    await prefs.setString('pincode', pincodeController.text);
    await prefs.setString('medication', _medication!);
    await prefs.setString('cervicalMedication', _cervicalMedication!);
    await prefs.setString('sickleMedication', _sickleMedication!);
    await prefs.setString('breastMedication', _breastMedication!);
    await prefs.setString('bloodTransfusion', _bloodTransfusion!);
    // await prefs.setString('bloodTransfusionForCervical', _bloodTransfusionForCervical!);
    await prefs.setString(
        'bloodTransfusionForSickle', _bloodTransfusionForSickle!);
    // await prefs.setString('bloodTransfusionForBreast', _bloodTransfusionForBreast!);
    // await prefs.setString('familyHistory', _familyHistory!);
    await prefs.setString('cervicalFamilyHistory', _cervicalFamilyHistory!);
    await prefs.setString('sickleFamilyHistory', _sickleFamilyHistory!);
    await prefs.setString('breastFamilyHistory', _breastFamilyHistory!);
    await prefs.setString('lmp', lmpController.text);
    await prefs.setString('ageAtMarriage', _ageAtMarriage ?? '');
    await prefs.setString('perCapitaIncome', incomeControlller.text);
    await prefs.setString('literacyRate', _literacyRate ?? '');
    await prefs.setString('parity', _parity ?? '');
    await prefs.setString('menopauseStatus', _menopauseStatus ?? '');
    await prefs.setString('menopauseYears', menopauseYearsController.text);
    await prefs.setString('ageFirstChild', ageFirstChildController.text);
    await prefs.setString('vaccinationStatus', _vaccinationStatus ?? '');
    String symptomsJson = jsonEncode(_symptoms);
    await prefs.setString('symptoms', symptomsJson);
    await prefs.setStringList("diseaseList", diseaseListArray!);

    if (_symptoms.contains('Others') && othersforSymptoms.text.isNotEmpty) {
      await prefs.setString('otherSymptoms', othersforSymptoms.text);
    } else {
      await prefs.remove('otherSymptoms'); // Clear if unchecked or empty
    }

    if (showFamilyHistoryField) {
      await prefs.setString(
          'familyHistoryDetails', familyHistoryController.text);
    }
  }

  bool validateFormForCervicalCancer() {
    if (birthYearController.text.isEmpty) {
      _showAlertDialog(context, "Please enter Birth Date.");
      return false;
    } else if (mobileNumberController.text.isEmpty ||
        mobileNumberController.text.length != 10) {
      _showAlertDialog(context, "Please enter a valid 10-digit Mobile Number.");
      return false;
    } else if (maritalStatus == null) {
      _showAlertDialog(context, "Please select Marital Status.");
      return false;
    } else if (category == null) {
      _showAlertDialog(context, "Please select Category.");
      return false;
    } else if (caste == null) {
      _showAlertDialog(context, "Please select Caste.");
      return false;
    } else if (houseController.text.isEmpty) {
      _showAlertDialog(context, "Please enter House Address.");
      return false;
    } else if (cityController.text.isEmpty) {
      _showAlertDialog(context, "Please enter City/Town.");
      return false;
    } else if (districtController.text.isEmpty) {
      _showAlertDialog(context, "Please enter District.");
      return false;
    } else if (stateController.text.isEmpty) {
      _showAlertDialog(context, "Please enter State.");
      return false;
    } else if (pincodeController.text.isEmpty ||
        pincodeController.text.length != 6) {
      _showAlertDialog(context, "Please enter a valid 6-digit Pincode.");
      return false;
    } else if (showFamilyHistoryField && familyHistoryController.text.isEmpty) {
      _showAlertDialog(context,
          "Please provide details for Family History of Breast Cancer.");
      return false;
    } else if (lmpController.text.isEmpty) {
      _showAlertDialog(context, "Please enter Last Menstrual Period (LMP).");
      return false;
    } else if (_menopauseStatus == null) {
      _showAlertDialog(context, "Please select Menopausal Status.");
      return false;
    } else if (_menopauseStatus == 'Yes' &&
        menopauseYearsController.text.isEmpty) {
      _showAlertDialog(
          context, "Please enter the number of years since menopause.");
      return false;
    } else if (ageFirstChildController.text.isEmpty) {
      _showAlertDialog(context, "Please enter Age of First Child.");
      return false;
    } else if (_vaccinationStatus == null) {
      _showAlertDialog(context, "Please select Vaccination Status.");
      return false;
    }
    return true;
  }

  bool validateFormForBreastCancer() {
    if (birthYearController.text.isEmpty) {
      _showAlertDialog(context, "Please enter Birth Date.");
      return false;
    } else if (mobileNumberController.text.isEmpty ||
        mobileNumberController.text.length != 10) {
      _showAlertDialog(context, "Please enter a valid 10-digit Mobile Number.");
      return false;
    } else if (maritalStatus == null) {
      _showAlertDialog(context, "Please select Marital Status.");
      return false;
    } else if (category == null) {
      _showAlertDialog(context, "Please select Category.");
      return false;
    } else if (caste == null) {
      _showAlertDialog(context, "Please select Caste.");
      return false;
    } else if (houseController.text.isEmpty) {
      _showAlertDialog(context, "Please enter House Address.");
      return false;
    } else if (cityController.text.isEmpty) {
      _showAlertDialog(context, "Please enter City/Town.");
      return false;
    } else if (districtController.text.isEmpty) {
      _showAlertDialog(context, "Please enter District.");
      return false;
    } else if (stateController.text.isEmpty) {
      _showAlertDialog(context, "Please enter State.");
      return false;
    } else if (pincodeController.text.isEmpty ||
        pincodeController.text.length != 6) {
      _showAlertDialog(context, "Please enter a valid 6-digit Pincode.");
      return false;
    } else if (showFamilyHistoryField && familyHistoryController.text.isEmpty) {
      _showAlertDialog(context,
          "Please provide details for Family History of Breast Cancer.");
      return false;
    }
    return true;
  }

  bool validateForm() {
    if (birthYearController.text.isEmpty) {
      _showAlertDialog(context, "Please enter Birth Date.");
      return false;
    } else if (mobileNumberController.text.isEmpty ||
        mobileNumberController.text.length != 10) {
      _showAlertDialog(context, "Please enter a valid 10-digit Mobile Number.");
      return false;
    } else if (maritalStatus == null) {
      _showAlertDialog(context, "Please select Marital Status.");
      return false;
    } else if (category == null) {
      _showAlertDialog(context, "Please select Category.");
      return false;
    } else if (caste == null) {
      _showAlertDialog(context, "Please select Caste.");
      return false;
    } else if (houseController.text.isEmpty) {
      _showAlertDialog(context, "Please enter House Address.");
      return false;
    } else if (cityController.text.isEmpty) {
      _showAlertDialog(context, "Please enter City/Town.");
      return false;
    } else if (districtController.text.isEmpty) {
      _showAlertDialog(context, "Please enter District.");
      return false;
    } else if (stateController.text.isEmpty) {
      _showAlertDialog(context, "Please enter State.");
      return false;
    } else if (pincodeController.text.isEmpty ||
        pincodeController.text.length != 6) {
      _showAlertDialog(context, "Please enter a valid 6-digit Pincode.");
      return false;
    }
    return true;
  }

  void _showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Incomplete Information"),
          content: Text(message),
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

  Future<void> _selectBirthDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        birthYearController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectLmpDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        lmpController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _addNewItem(
      BuildContext context, String itemType, ApiService apiService) async {
    TextEditingController itemController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add your $itemType'),
          content: TextField(
            controller: itemController,
            decoration: InputDecoration(
              labelText: 'Enter new $itemType',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                String newItem = itemController.text.trim();
                if (newItem.isNotEmpty) {
                  try {
                    if (itemType == 'caste') {
                      await apiService.addCaste(newItem);
                      setState(() {
                        caste = newItem;
                      });
                      await apiService.fetchCasteNames();
                    } else if (itemType == 'category') {
                      await apiService.addCategory(newItem);
                      setState(() {
                        category = newItem;
                      });
                      await apiService.fetchCategory();
                    }
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$itemType added successfully!')),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add $itemType: $error'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  List<String>? diseaseListArray = [];
  @override
  void initState() {
    diseaseListArray = widget.diseaseArray;
    Provider.of<ApiService>(context, listen: false).fetchCasteNames();
    Provider.of<ApiService>(context, listen: false).fetchCategory();

    super.initState();
  }

  String? _selectedDisease;
  final Map<String, String> diseaseMapping = {
    'Sickle Cell': 'sickleCell',
    'Breast Cancer': 'breastCancer',
    'Cervical Cancer': 'cervicalCancer',
    // 'All': 'all',
  };
  @override
  Widget build(BuildContext context) {
    // var casteProvider = Provider.of<ApiService>(context, listen: false);
    // var categoryProvider = Provider.of<ApiService>(context, listen: false);
    var apiService = Provider.of<ApiService>(context, listen: false);
    // String? selectedDisease =
    //     context.watch<SelectedDiseaseProvider>().selectedDisease;

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
        //         '$selectedDisease',
        //         style: const TextStyle(
        //           color: Colors.black,
        //           fontSize: 12,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Person’s Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectBirthDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: birthYearController,
                    decoration: const InputDecoration(
                      labelText: 'Birth Date (Day/Month/Year) *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Male'),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Female'),
                  Radio<String>(
                    value: 'Other',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  const Text('Other'),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: mobileNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: const InputDecoration(
                  labelText: 'Mobile Number *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fatherNameController,
                decoration: const InputDecoration(
                  labelText: 'Father’s Name ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: motherNameController,
                decoration: const InputDecoration(
                  labelText: 'Mother’s Name ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Marital status *',
                  border: OutlineInputBorder(),
                ),
                items: ['Single', 'Married', 'Divorced']
                    .map((status) => DropdownMenuItem(
                          child: Text(status),
                          value: status,
                        ))
                    .toList(),
                onChanged: (value) {
                  maritalStatus = value;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                decoration: const InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
                value: category,
                items: [
                  ...apiService.categoryNames.toSet().map((categoryItem) {
                    return DropdownMenuItem<String>(
                      value: categoryItem,
                      child: Text(categoryItem),
                    );
                  }).toList(),
                  const DropdownMenuItem<String>(
                    value: 'addCategory',
                    child: Text('Add your category'),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'addCategory') {
                    _addNewItem(context, 'category', apiService);
                  } else {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                menuMaxHeight: MediaQuery.of(context).size.height * 0.5,
                decoration: const InputDecoration(
                  labelText: "Select Caste*",
                  border: OutlineInputBorder(),
                ),
                value: caste,
                items: [
                  ...apiService.casteNames.toSet().map((casteItem) {
                    return DropdownMenuItem<String>(
                      value: casteItem,
                      child: Text(casteItem),
                    );
                  }).toList(),
                  const DropdownMenuItem<String>(
                    value: 'addCaste',
                    child: Text('Add your caste'),
                  ),
                ],
                onChanged: (value) {
                  if (value == 'addCaste') {
                    _addNewItem(context, 'caste', apiService);
                  } else {
                    setState(() {
                      caste = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              TextField(
                controller: subCasteController,
                decoration: const InputDecoration(
                  labelText: 'Sub Caste',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Person’s Address Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: houseController,
                decoration: const InputDecoration(
                  labelText: 'House *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  labelText: 'City / Town *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(
                  labelText: 'District *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: stateController,
                decoration: const InputDecoration(
                  labelText: 'State *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: pincodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                decoration: const InputDecoration(
                  labelText: 'Pincode *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Medical Records
              const Text(
                'Patient Medical Records',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Container(
              //     width: double.infinity,
              //     child: DropdownButtonFormField<String>(
              //       decoration: InputDecoration(
              //         contentPadding:
              //         const EdgeInsets.symmetric(horizontal: 4),
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //       ),
              //       hint: const Text('Pick an option'),
              //       items: diseaseMapping.keys
              //           .map((e) => DropdownMenuItem(
              //         child: Text(e),
              //         value: e,
              //       )).toList(),
              //       onChanged: (value) {
              //         setState(() {
              //           _selectedDisease = diseaseMapping[value!];
              //           print("sfsfsf--------- ${_selectedDisease}");
              //           // context
              //           //     .read<SelectedDiseaseProvider>()
              //           //     .setSelectedDisease(value);
              //         });
              //       },
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 10),

              // sickle cell fields============================================================

              Visibility(
                visible: diseaseListArray?.contains('sickleCell') ?? false,
                child: const Text(
                  'For sickle cell',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                  visible: diseaseListArray?.contains('sickleCell') ?? false,
                  child: const SizedBox(height: 10)),
              Visibility(
                  visible: diseaseListArray?.contains('sickleCell') ?? false,
                  child: Text('Have you been under medication ?')),
              Visibility(
                visible: diseaseListArray?.contains('sickleCell') ?? false,
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _sickleMedication,
                      onChanged: (value) {
                        setState(() {
                          _sickleMedication = value;
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _sickleMedication,
                      onChanged: (value) {
                        setState(() {
                          _sickleMedication = value;
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ),
              Visibility(
                  visible: diseaseListArray?.contains('sickleCell') ?? false,
                  child: const SizedBox(height: 10)),
              if (diseaseListArray?.contains('sickleCell') ?? false) ...[
                const Text(
                    'Have you undergone any blood transfusions recently?'),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _bloodTransfusionForSickle,
                      onChanged: (value) {
                        setState(() {
                          _bloodTransfusionForSickle = value;
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _bloodTransfusionForSickle,
                      onChanged: (value) {
                        setState(() {
                          _bloodTransfusionForSickle = value;
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ],
              Visibility(
                  visible: diseaseListArray?.contains('sickleCell') ?? false,
                  child: const SizedBox(height: 10)),
              Visibility(
                  visible: diseaseListArray?.contains('sickleCell') ?? false,
                  child: Text('Is there a family history ?')),
              Visibility(
                visible: diseaseListArray?.contains('sickleCell') ?? false,
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _sickleFamilyHistory,
                      onChanged: (value) {
                        setState(() {
                          _sickleFamilyHistory = value;
                          showSickleFamilyHistoryField = value == 'Yes';
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _sickleFamilyHistory,
                      onChanged: (value) {
                        setState(() {
                          _sickleFamilyHistory = value;
                          showSickleFamilyHistoryField = value == 'Yes';
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ),
              if (showSickleFamilyHistoryField)
                TextField(
                  controller: familyHistoryController,
                  decoration: const InputDecoration(
                    labelText: 'Family History *',
                    border: OutlineInputBorder(),
                  ),
                ),
              Visibility(
                  visible: diseaseListArray?.contains('sickleCell') ?? false,
                  child: const SizedBox(height: 10)),

              // breast cancer fields============================================================

              Visibility(
                visible: diseaseListArray?.contains('breastCancer') ?? false,
                child: const Text(
                  'For breast cancer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                  visible: diseaseListArray?.contains('breastCancer') ?? false,
                  child: const SizedBox(height: 10)),
              Visibility(
                  visible: diseaseListArray?.contains('breastCancer') ?? false,
                  child: Text('Have you been under medication ?')),
              Visibility(
                visible: diseaseListArray?.contains('breastCancer') ?? false,
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _breastMedication,
                      onChanged: (value) {
                        setState(() {
                          _breastMedication = value;
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _breastMedication,
                      onChanged: (value) {
                        setState(() {
                          _breastMedication = value;
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ),
              Visibility(
                  visible: diseaseListArray?.contains('breastCancer') ?? false,
                  child: const SizedBox(height: 10)),
              // Visibility(visible: diseaseListArray?.contains('breastCancer') ?? false,child: const SizedBox(height: 10)),
              // if (diseaseListArray?.contains('breastCancer') ?? false) ...[
              //   const Text(
              //       'Have you undergone any blood transfusions recently?'),
              //   Row(
              //     children: [
              //       Radio<String>(
              //         value: 'Yes',
              //         groupValue: _bloodTransfusionForBreast,
              //         onChanged: (value) {
              //           setState(() {
              //             _bloodTransfusionForBreast = value;
              //           });
              //         },
              //       ),
              //       const Text('Yes'),
              //       Radio<String>(
              //         value: 'No',
              //         groupValue: _bloodTransfusionForBreast,
              //         onChanged: (value) {
              //           setState(() {
              //             _bloodTransfusionForBreast = value;
              //           });
              //         },
              //       ),
              //       const Text('No'),
              //     ],
              //   ),
              // ],
              Visibility(
                  visible: diseaseListArray?.contains('breastCancer') ?? false,
                  child: const SizedBox(height: 10)),
              Visibility(
                  visible: diseaseListArray?.contains('breastCancer') ?? false,
                  child: Text('Is there a family history ?')),
              Visibility(
                visible: diseaseListArray?.contains('breastCancer') ?? false,
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _breastFamilyHistory,
                      onChanged: (value) {
                        setState(() {
                          _breastFamilyHistory = value;
                          showBreastFamilyHistoryField = value == 'Yes';
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _breastFamilyHistory,
                      onChanged: (value) {
                        setState(() {
                          _breastFamilyHistory = value;
                          showBreastFamilyHistoryField = value == 'Yes';
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ),
              if (showBreastFamilyHistoryField)
                TextField(
                  controller: familyHistoryController,
                  decoration: const InputDecoration(
                    labelText: 'Family History *',
                    border: OutlineInputBorder(),
                  ),
                ),
              Visibility(
                  visible: diseaseListArray?.contains('breastCancer') ?? false,
                  child: const SizedBox(height: 10)),

              // cervical cancer fields============================================================
              Visibility(
                visible: diseaseListArray?.contains('cervicalCancer') ?? false,
                child: const Text(
                  'For cervical Cancer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                  visible:
                      diseaseListArray?.contains('cervicalCancer') ?? false,
                  child: const SizedBox(height: 10)),
              Visibility(
                  visible:
                      diseaseListArray?.contains('cervicalCancer') ?? false,
                  child: Text('Have you been under medication ?')),
              Visibility(
                visible: diseaseListArray?.contains('cervicalCancer') ?? false,
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _cervicalMedication,
                      onChanged: (value) {
                        setState(() {
                          _cervicalMedication = value;
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _cervicalMedication,
                      onChanged: (value) {
                        setState(() {
                          _cervicalMedication = value;
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ),
              Visibility(
                  visible:
                      diseaseListArray?.contains('cervicalCancer') ?? false,
                  child: const SizedBox(height: 10)),
              // Visibility(visible: diseaseListArray?.contains('cervicalCancer') ?? false,child: const SizedBox(height: 10)),
              // if (diseaseListArray?.contains('cervicalCancer') ?? false) ...[
              //   const Text(
              //       'Have you undergone any blood transfusions recently?'),
              //   Row(
              //     children: [
              //       Radio<String>(
              //         value: 'Yes',
              //         groupValue: _bloodTransfusionForCervical,
              //         onChanged: (value) {
              //           setState(() {
              //             // _bloodTransfusionForCervical = value;
              //             _bloodTransfusionForCervical = "";
              //           });
              //         },
              //       ),
              //       const Text('Yes'),
              //       Radio<String>(
              //         value: 'No',
              //         groupValue: _bloodTransfusionForCervical,
              //         onChanged: (value) {
              //           setState(() {
              //             _bloodTransfusionForCervical = value;
              //           });
              //         },
              //       ),
              //       const Text('No'),
              //     ],
              //   ),
              // ],
              Visibility(
                  visible:
                      diseaseListArray?.contains('cervicalCancer') ?? false,
                  child: const SizedBox(height: 10)),
              Visibility(
                  visible:
                      diseaseListArray?.contains('cervicalCancer') ?? false,
                  child: Text('Is there a family history ?')),
              Visibility(
                visible: diseaseListArray?.contains('cervicalCancer') ?? false,
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Yes',
                      groupValue: _cervicalFamilyHistory,
                      onChanged: (value) {
                        setState(() {
                          _cervicalFamilyHistory = value;
                          showCervicalFamilyHistoryField = value == 'Yes';
                        });
                      },
                    ),
                    const Text('Yes'),
                    Radio<String>(
                      value: 'No',
                      groupValue: _cervicalFamilyHistory,
                      onChanged: (value) {
                        setState(() {
                          _cervicalFamilyHistory = value;
                          showCervicalFamilyHistoryField = value == 'Yes';
                        });
                      },
                    ),
                    const Text('No'),
                  ],
                ),
              ),
              if (showCervicalFamilyHistoryField)
                TextField(
                  controller: familyHistoryController,
                  decoration: const InputDecoration(
                    labelText: 'Family History *',
                    border: OutlineInputBorder(),
                  ),
                ),
              Visibility(
                  visible:
                      diseaseListArray?.contains('cervicalCancer') ?? false,
                  child: const SizedBox(height: 10)),

              Visibility(
                // visible: selectedDisease == 'Cervical Cancer',
                // visible: _selectedDisease == 'cervicalCancer',
                visible: diseaseListArray?.contains('cervicalCancer') ?? false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Symptoms (Select all that apply):'),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('White Discharge'),
                      value: _symptoms.contains('White Discharge'),
                      onChanged: (bool? selected) {
                        toggleSymptom('White Discharge', selected ?? false);
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Bleeding PV / AUB'),
                      value: _symptoms.contains('Bleeding PV / AUB'),
                      onChanged: (bool? selected) {
                        toggleSymptom('Bleeding PV / AUB', selected ?? false);
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Itching'),
                      value: _symptoms.contains('Itching'),
                      onChanged: (bool? selected) {
                        toggleSymptom('Itching', selected ?? false);
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Post Coital Bleeding'),
                      value: _symptoms.contains('Post Coital Bleeding'),
                      onChanged: (bool? selected) {
                        toggleSymptom(
                            'Post Coital Bleeding', selected ?? false);
                      },
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Others (Specify below)'),
                      value: _symptoms.contains('Others'),
                      onChanged: (bool? selected) {
                        toggleSymptom('Others', selected ?? false);
                      },
                    ),
                    if (_symptoms.contains('Others'))
                      TextField(
                        controller: othersforSymptoms,
                        decoration: const InputDecoration(
                          labelText: 'Specify Other Symptoms',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Age at Marriage:'),
                        ...['<20', '21-25', '26-30', '31-35', '36-40', '>40']
                            .map((age) {
                          return RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(age),
                            value: age,
                            groupValue: _ageAtMarriage,
                            onChanged: (value) {
                              setState(() {
                                _ageAtMarriage = value;
                                log(_ageAtMarriage.toString());
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: incomeControlller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Per Capita Income',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Literacy Rate:'),
                        ...[
                          'Illiterate',
                          'SSC',
                          'HSC',
                          'Graduate',
                          'Post Graduate',
                          'Professional'
                        ].map((level) {
                          return RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(level),
                            value: level,
                            groupValue: _literacyRate,
                            onChanged: (value) {
                              setState(() {
                                _literacyRate = value;
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Parity:'),
                        ...['1', '2', '3', '4', '5', '>5'].map((parity) {
                          return RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            title: Text(parity),
                            value: parity,
                            groupValue: _parity,
                            onChanged: (value) {
                              setState(() {
                                _parity = value;
                              });
                            },
                          );
                        }).toList(),
                        GestureDetector(
                          onTap: () => _selectLmpDate(context),
                          child: AbsorbPointer(
                            child: TextField(
                              controller: lmpController,
                              decoration: const InputDecoration(
                                labelText: 'Last Menstrual Period (LMP)',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Have Menopause? If yes, how many years?'),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Yes',
                              groupValue: _menopauseStatus,
                              onChanged: (value) {
                                setState(() {
                                  _menopauseStatus = value;
                                });
                              },
                            ),
                            const Text('Yes'),
                            Radio<String>(
                              value: 'No',
                              groupValue: _menopauseStatus,
                              onChanged: (value) {
                                setState(() {
                                  _menopauseStatus = value;
                                });
                              },
                            ),
                            const Text('No'),
                          ],
                        ),
                        if (_menopauseStatus == 'Yes')
                          TextField(
                            controller: menopauseYearsController,
                            decoration: const InputDecoration(
                              labelText: 'Years Since Menopause',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: ageFirstChildController,
                          decoration: const InputDecoration(
                            labelText: 'Age of First Child',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 20),

                        // Vaccination Status (Single Selection Radio Buttons)
                        const Text('Vaccination Status'),
                        Column(
                          children: ['Cervarix', 'Gardasil', 'None']
                              .map((vaccination) => RadioListTile<String>(
                                    title: Text(vaccination),
                                    value: vaccination,
                                    groupValue: _vaccinationStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _vaccinationStatus = value;
                                      });
                                    },
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (validateForm()) {
                      await saveFormData().then((val) {
                        // apiService.submitPatientDataNew().then((value) {
                        //   value.statusCode == 201
                        //       ?
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CaptureImageScreen(),
                          ),
                        );
                        //       : Container();
                        // });
                      });
                    }
                  },
                  child: const Text('PROCEED'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
