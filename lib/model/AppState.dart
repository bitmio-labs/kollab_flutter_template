// ignore_for_file: non_constant_identifier_names

class AppState {
  final Map<String, dynamic> json;
  bool isLoggedIn = true;
  final AccountModel account;

  AppState({this.json, this.account, this.isLoggedIn});

  factory AppState.fromJson(Map<String, dynamic> json) {
    bool isLoggedIn = json['is_logged_in'];

    return AppState(
        json: json,
        isLoggedIn: isLoggedIn,
        account: AccountModel.fromJson(json['account']));
  }

  dynamic dataForKey(String name) {
    if (json == null) {
      return null;
    }

    return json[name];
  }
}

class EmbeddedContact {
  final String name;
  final String imageURL;

  EmbeddedContact({this.name, this.imageURL});

  factory EmbeddedContact.fromJson(Map<String, dynamic> json) {
    return EmbeddedContact(name: json['name'], imageURL: json['image_url']);
  }
}

class SignupResponse {
  final bool success;
  final String access_token;

  SignupResponse({this.success, this.access_token});

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
        success: json['success'], access_token: json['access_token']);
  }
}

class LoginResponse {
  final bool success;
  final String access_token;

  LoginResponse({this.success, this.access_token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        success: json['success'], access_token: json['access_token']);
  }
}

class CachedState {
  final List<CachedChecklistItemState> checklist_items;

  CachedState({this.checklist_items});

  Map<String, dynamic> toJson() => {
        'checklist_items':
            checklist_items.map((each) => each.toJson()).toList(),
      };

  factory CachedState.fromJson(Map<String, dynamic> json) {
    List<dynamic> checklist_items = json['checklist_items'];

    return CachedState(checklist_items:
        List<CachedChecklistItemState>.from(checklist_items.map((each) {
      return CachedChecklistItemState.fromJson(each);
    })));
  }
}

class CachedChecklistItemState {
  final String id;
  final bool value;

  CachedChecklistItemState({this.id, this.value});

  Map<String, dynamic> toJson() => {
        'id': id,
        'value': value,
      };

  factory CachedChecklistItemState.fromJson(Map<String, dynamic> json) {
    return CachedChecklistItemState(id: json['id'], value: json['value']);
  }
}

class AccountModel {
  final String email;
  final String change_password_url;

  AccountModel({
    this.email,
    this.change_password_url,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return AccountModel(
      email: json['email'],
      change_password_url: json['change_password_url'],
    );
  }
}
