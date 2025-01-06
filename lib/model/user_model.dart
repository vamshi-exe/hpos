import 'dart:convert';

UserModel userModelFromMap(String str) => UserModel.fromJson(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toMap());

class UserModel {
    final String message;
    final String token;
    final UserDetails userDetails;

    UserModel({
        required this.message,
        required this.token,
        required this.userDetails,
    });

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        message: json["message"],
        token: json["token"],
        userDetails: UserDetails.fromMap(json["userDetails"]),
    );

    Map<String, dynamic> toMap() => {
        "message": message,
        "token": token,
        "userDetails": userDetails.toMap(),
    };
}

class UserDetails {
    final String userid;
    final String centerName;
    // final String disease;

    UserDetails({
        required this.userid,
        required this.centerName,
        // required this.disease,
    });

    factory UserDetails.fromMap(Map<String, dynamic> json) => UserDetails(
        userid: json["userid"],
        centerName: json["centerName"],
        // disease: json["disease"],
    );

    Map<String, dynamic> toMap() => {
        "userid": userid,
        "centerName": centerName,
        // "disease": disease,
    };
}