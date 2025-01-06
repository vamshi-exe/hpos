import 'package:employee_app/model/patient_detail.dart';
import 'package:employee_app/provider/selected_disease.dart';
import 'package:employee_app/screens/home/form.dart';
import 'package:employee_app/services/api_service.dart';
import 'package:employee_app/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<UserDetail> userDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientDetails();
  }

  // Function to load patient details from the API using the selected center name from the provider
  Future<void> _loadPatientDetails() async {
    final centerProvider = Provider.of<CenterProvider>(context, listen: false);
    final selectedCenterName =
        centerProvider.selectedCenter; // Get selected center name from provider

    if (selectedCenterName == null || selectedCenterName.isEmpty) {
      // Handle case where there is no selected center
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a center before proceeding.')),
      );
      return;
    }

    try {
      final apiService = ApiService();
      List<PatientDetail> patients = await apiService.fetchPatientsByCenter(
          selectedCenterName); // Fetch patients for selected center
      setState(() {
        userDetails = patients
            .map((patient) => UserDetail(
                  personName: patient.personalName ?? '',
                  userId: patient.aadhaarNumber ?? '',
                  imageUrl: patient.userImage ?? '',
                ))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error loading patient details: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(), // Custom AppBar
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: userDetails.length,
                itemBuilder: (context, index) {
                  final userDetail = userDetails[index];
                  return _buildUserCard(userDetail);
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new page with the form when FAB is pressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormScreen(), // Navigate to FormScreen
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Widget to build the user detail card
  Widget _buildUserCard(UserDetail userDetail) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Display the user's image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                userDetail.imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.person, size: 80, color: Colors.grey);
                },
              ),
            ),
            SizedBox(width: 16),
            // Display the user's name and user ID
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDetail.personName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  userDetail.userId,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Class to store user details
class UserDetail {
  final String personName;
  final String userId;
  final String imageUrl;

  UserDetail({
    required this.personName,
    required this.userId,
    required this.imageUrl,
  });
}
