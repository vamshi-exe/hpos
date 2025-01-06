class CategoryList {
  final String id;
  final List<String> names;

  CategoryList({required this.id, required this.names});

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      id: json['_id'],
      names: List<String>.from(json['names']),
    );
  }
}

class CategoryListResponse {
  final bool status;
  final List<CategoryList> categoryList;

  CategoryListResponse({required this.status, required this.categoryList});

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['categoryList'] as List;
    List<CategoryList> categories =
        list.map((i) => CategoryList.fromJson(i)).toList();

    return CategoryListResponse(
      status: json['status'],
      categoryList: categories,
    );
  }
}
