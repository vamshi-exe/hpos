class CasteList {
  final String id;
  final List<String> names;

  CasteList({required this.id, required this.names});

  factory CasteList.fromJson(Map<String, dynamic> json) {
    return CasteList(
      id: json['_id'],
      names: List<String>.from(json['names']),
    );
  }
}

class CasteListResponse {
  final bool status;
  final List<CasteList> casteList;

  CasteListResponse({required this.status, required this.casteList});

  factory CasteListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['casteList'] as List;
    List<CasteList> castes = list.map((i) => CasteList.fromJson(i)).toList();

    return CasteListResponse(
      status: json['status'],
      casteList: castes,
    );
  }
}
