// ignore_for_file: non_constant_identifier_names

import 'package:kollab_contacts/kollab_contacts.dart';

import 'ActivitiesModel.dart';
import 'CardsModel.dart';
import 'DocumentsModel.dart';

class AppState {
  Map<String, dynamic> json;
  bool isLoggedIn = true;
  AccountModel account;
  DocumentListModel documents;
  Contacts contacts;
  TimelinePhases phases;
  DashboardModel dashboard;
  SettingsModel settings;

  AppState(
      {this.json,
      this.account,
      this.isLoggedIn,
      this.documents,
      this.contacts,
      this.phases,
      this.dashboard,
      this.settings});

  factory AppState.fromJson(Map<String, dynamic> json) {
    bool isLoggedIn = json['is_logged_in'];

    return AppState(
        json: json,
        isLoggedIn: isLoggedIn,
        account: AccountModel.fromJson(json['account']),
        documents: DocumentListModel.fromJson(json['documents']),
        contacts: Contacts.fromJson(json['contacts']),
        phases: TimelinePhases.fromJson(json['phases']),
        dashboard: DashboardModel.fromJson(json['dashboard']),
        settings: SettingsModel.fromJson(json['settings']));
  }

  dynamic dataForKey(String name) {
    return json[name];
  }
}

class DashboardModel {
  final String progress_message;
  final int progress;
  final List<Document> documents;
  final List<Contact> contacts;
  final List<TimelineCard> cards;
  final List<ActivityModel> activities;

  DashboardModel(
      {this.progress_message,
      this.progress,
      this.documents,
      this.contacts,
      this.cards,
      this.activities});

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> documents = json['documents'];
    final List<dynamic> contacts = json['contacts'];
    final List<dynamic> cards = json['cards'];
    final List<dynamic> activities = json['activities'];

    return DashboardModel(
        progress_message: json['progress_message'],
        progress: json['progress'],
        documents: List<Document>.from(
            documents.map((each) => Document.fromJson(each))),
        contacts:
            List<Contact>.from(contacts.map((each) => Contact.fromJson(each))),
        cards: List<TimelineCard>.from(
            cards.map((each) => TimelineCard.fromJson(each))),
        activities: List<ActivityModel>.from(
            activities.map((each) => ActivityModel.fromJson(each))));
  }
}

class TimelinePhases {
  final List<TimelinePhase> items;

  TimelinePhases({this.items});

  factory TimelinePhases.fromJson(List<dynamic> json) {
    return TimelinePhases(items: List<TimelinePhase>.from(json.map((each) {
      return TimelinePhase.fromJson(each);
    })));
  }
}

class TimelinePhase {
  final String name;
  final List<TimelineCard> cards;

  TimelinePhase({this.name, this.cards});

  factory TimelinePhase.fromJson(Map<String, dynamic> json) {
    List<dynamic> cards = json['cards'];

    return TimelinePhase(
        name: json['name'],
        cards: List<TimelineCard>.from(cards.map((each) {
          return TimelineCard.fromJson(each);
        })));
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

class SettingsModel {
  final String facebook_url;
  final String instagram_url;
  final String privacy_url;
  final String legal_url;

  SettingsModel(
      {this.facebook_url,
      this.instagram_url,
      this.privacy_url,
      this.legal_url});

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
        facebook_url: json['facebook_url'],
        instagram_url: json['instagram_url'],
        privacy_url: json['privacy_url'],
        legal_url: json['legal_url']);
  }
}
