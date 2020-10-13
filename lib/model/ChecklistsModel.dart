// ignore_for_file: non_constant_identifier_names

class ChecklistModel {
  final String name;
  final List<ChecklistItemModel> items;

  ChecklistModel({this.name, this.items});

  factory ChecklistModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> items = json['items'];

    return ChecklistModel(
        name: json['name'],
        items: List<ChecklistItemModel>.from(items.map((each) {
          return ChecklistItemModel.fromJson(each);
        })));
  }
}

class ChecklistItemModel {
  final String id;
  final String name;
  final bool is_checked;

  ChecklistItemModel({this.id, this.name, this.is_checked = false});

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      id: json['id'],
      name: json['name'] ?? '',
      is_checked: json['is_checked'] ?? false,
    );
  }
}
