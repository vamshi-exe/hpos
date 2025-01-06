import 'dart:convert';

List<PatientDetail> patientDetailFromJson(String str) => List<PatientDetail>.from(json.decode(str).map((x) => PatientDetail.fromJson(x)));

String patientDetailToJson(List<PatientDetail> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PatientDetail {
  PatientDetail({
    required this.address,
    this.id,
    this.userImage,
    this.personalName,
    this.bloodStatus,
    this.resultStatus,
    this.hplc,
    this.cardStatus,
    this.aadhaarNumber,
    this.number,
    this.birthYear,
    this.age,
    this.gender,
    this.mobileNumber,
    this.fathersName,
    this.motherName,
    this.maritalStatus,
    this.category,
    this.caste,
    this.subCaste,
    this.centerName,
    this.isUnderMedication,
    this.isUnderBloodTransfusion,
    this.familyHistory,
    this.uid,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.centerCode,
  });

  final Address? address;
  final String? id;
  final String? userImage;
  final String? personalName;
  final String? bloodStatus;
  final String? resultStatus;
  final String? hplc;
  final String? cardStatus;
  final String? aadhaarNumber;
  final int? number;
  final String? birthYear;
  final String? age;
  final String? gender;
  final String? mobileNumber;
  final String? fathersName;
  final String? motherName;
  final String? maritalStatus;
  final String? category;
  final String? caste;
  final String? subCaste;
  final String? centerName;
  final bool? isUnderMedication;
  final bool? isUnderBloodTransfusion;
  final bool? familyHistory;
  final String? uid;
  final String? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? centerCode;

  factory PatientDetail.fromJson(Map<String, dynamic> json) => PatientDetail(
        address: json["address"] != null ? Address.fromJson(json["address"]) : null,
        id: json["_id"] as String?,
        userImage: json["userImage"] as String?,
        personalName: json["personalName"] as String?,
        bloodStatus: json["bloodStatus"] as String?,
        resultStatus: json["resultStatus"] as String?,
        hplc: json["HPLC"] as String?,
        cardStatus: json["cardStatus"] as String?,
        aadhaarNumber: json["aadhaarNumber"] as String?,
        number: json["number"] as int?,
        birthYear: json["birthYear"] as String?,
        age: json["age"] as String?,
        gender: json["gender"] as String?,
        mobileNumber: json["mobileNumber"] as String?,
        fathersName: json["fathersName"] as String?,
        motherName: json["motherName"] as String?,
        maritalStatus: json["maritalStatus"] as String?,
        category: json["category"] as String?,
        caste: json["caste"] as String?,
        subCaste: json["subCaste"] as String?,
        centerName: json["centerName"] as String?,
        isUnderMedication: json["isUnderMedication"] as bool?,
        isUnderBloodTransfusion: json["isUnderBloodTransfusion"] as bool?,
        familyHistory: json["familyHistory"] as bool?,
        uid: json["UID"] as String?,
        isDeleted: json["isDeleted"] as String?,
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
        v: json["__v"] as int?,
        centerCode: json["centerCode"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "address": address?.toJson(),
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "centerCode": centerCode,
      };
}

class Address {
  Address({
    this.house,
    this.city,
    this.district,
    this.state,
    this.pincode,
  });

  final String? house;
  final String? city;
  final String? district;
  final String? state;
  final String? pincode;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        house: json["house"] as String?,
        city: json["city"] as String?,
        district: json["district"] as String?,
        state: json["state"] as String?,
        pincode: json["pincode"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "house": house,
        "city": city,
        "district": district,
        "state": state,
        "pincode": pincode,
      };
}
