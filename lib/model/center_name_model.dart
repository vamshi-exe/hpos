class CenterName {
  final String centerName;

  CenterName({required this.centerName});

  factory CenterName.fromJson(Map<String, dynamic> json) {
    return CenterName(
      centerName:
          json['centerName'] ?? '', // Handle empty or missing center name
    );
  }
}

class CenterNameListResponse {
  final bool status;
  final List<CenterName> centerNameList;

  CenterNameListResponse({required this.status, required this.centerNameList});

  factory CenterNameListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['centerNameList'] as List;
    List<CenterName> centerList =
        list.map((i) => CenterName.fromJson(i)).toList();

    return CenterNameListResponse(
      status: json['status'],
      centerNameList: centerList,
    );
  }
}
