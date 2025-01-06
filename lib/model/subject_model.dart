import 'dart:convert';

List<SubjectDetail> subjectDetailFromMap(String str) =>
    List<SubjectDetail>.from(json.decode(str).map((x) => SubjectDetail.fromMap(x)));

String subjectDetailToMap(List<SubjectDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class SubjectDetail {
  final Address address;
  final String id;
  final String userImage;
  final String personalName;
  final String bloodStatus;
  final String resultStatus;
  final String hplc;
  final String cardStatus;
  final String aadhaarNumber;
  final int number;
  final String birthYear;
  final String age;
  final String gender;
  final String mobileNumber;
  final String fathersName;
  final String motherName;
  final String maritalStatus;
  final String category;
  final String caste;
  final String subCaste;
  final String centerName;
  final bool isUnderMedication;
  final bool isUnderBloodTransfusion;
  final bool familyHistory;
  final String uid;
  final String isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String centerCode;

  SubjectDetail({
    required this.address,
    required this.id,
    required this.userImage,
    required this.personalName,
    required this.bloodStatus,
    required this.resultStatus,
    required this.hplc,
    required this.cardStatus,
    required this.aadhaarNumber,
    required this.number,
    required this.birthYear,
    required this.age,
    required this.gender,
    required this.mobileNumber,
    required this.fathersName,
    required this.motherName,
    required this.maritalStatus,
    required this.category,
    required this.caste,
    required this.subCaste,
    required this.centerName,
    required this.isUnderMedication,
    required this.isUnderBloodTransfusion,
    required this.familyHistory,
    required this.uid,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.centerCode,
  });

  factory SubjectDetail.fromMap(Map<String, dynamic> json) => SubjectDetail(
        address: Address.fromMap(json["address"]),
        id: json["_id"],
        userImage: json["userImage"],
        personalName: json["personalName"],
        bloodStatus: json["bloodStatus"],
        resultStatus: json["resultStatus"],
        hplc: json["HPLC"],
        cardStatus: json["cardStatus"],
        aadhaarNumber: json["aadhaarNumber"],
        number: json["number"],
        birthYear: json["birthYear"],
        age: json["age"],
        gender: json["gender"],
        mobileNumber: json["mobileNumber"],
        fathersName: json["fathersName"],
        motherName: json["motherName"],
        maritalStatus: json["maritalStatus"],
        category: json["category"],
        caste: json["caste"],
        subCaste: json["subCaste"],
        centerName: json["centerName"],
        isUnderMedication: json["isUnderMedication"],
        isUnderBloodTransfusion: json["isUnderBloodTransfusion"],
        familyHistory: json["familyHistory"],
        uid: json["UID"],
        isDeleted: json["isDeleted"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        centerCode: json["centerCode"],
      );

  Map<String, dynamic> toMap() => {
        "address": address.toMap(),
        "_id": id,
        "userImage": userImage,
        "personalName": personalName,
        "bloodStatus": bloodStatus,
        "resultStatus": resultStatus,
        "HPLC": hplc,
        "cardStatus": cardStatus,
        "aadhaarNumber": aadhaarNumber,
        "number": number,
        "birthYear": birthYear,
        "age": age,
        "gender": gender,
        "mobileNumber": mobileNumber,
        "fathersName": fathersName,
        "motherName": motherName,
        "maritalStatus": maritalStatus,
        "category": category,
        "caste": caste,
        "subCaste": subCaste,
        "centerName": centerName,
        "isUnderMedication": isUnderMedication,
        "isUnderBloodTransfusion": isUnderBloodTransfusion,
        "familyHistory": familyHistory,
        "UID": uid,
        "isDeleted": isDeleted,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "centerCode": centerCode,
      };
}

class Address {
  final String house;
  final String city;
  final String district;
  final String state;
  final String pincode;

  Address({
    required this.house,
    required this.city,
    required this.district,
    required this.state,
    required this.pincode,
  });

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        house: json["house"],
        city: json["city"],
        district: json["district"],
        state: json["state"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toMap() => {
        "house": house,
        "city": city,
        "district": district,
        "state": state,
        "pincode": pincode,
      };
}
