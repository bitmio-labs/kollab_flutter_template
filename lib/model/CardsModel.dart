// ignore_for_file: non_constant_identifier_names

import 'package:kollab_contacts/model/contact_model.dart';

import '../API.dart';
import 'ChecklistsModel.dart';
import 'DocumentsModel.dart';

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

class TimelineCard {
  final String name;
  final String description;
  final String image_url;
  final String date;
  final Contact contact;
  final List<ChecklistModel> checklists;
  final List<Document> documents;
  final bool is_completed;

  bool isChecked(ChecklistItemModel model, CachedChecklistState state) {
    return state.isToogled(model.id) ?? model.is_checked;
  }

  int completedCount(CachedChecklistState state) {
    if (checklists == null) return 0;

    return checklists.fold(
        0,
        (value, list) =>
            value +
            list.items.fold(
                0, (value, item) => value + (isChecked(item, state) ? 1 : 0)));
  }

  int get totalCount {
    if (checklists == null) return 0;

    return checklists.fold(
        0,
        (value, list) =>
            value + list.items.fold(0, (value, item) => value + 1));
  }

  TimelineCard(
      {this.name,
      this.description,
      this.date,
      this.image_url,
      this.contact,
      this.checklists,
      this.documents,
      this.is_completed});

  factory TimelineCard.fromJson(Map<String, dynamic> json) {
    List<dynamic> documents = json['documents'];
    List<dynamic> checklists = json['checklists'];

    return TimelineCard(
        name: json['name'],
        description: json['description'],
        date: json['date'],
        image_url: json['image_url'],
        contact:
            json['contact'] == null ? null : Contact.fromJson(json['contact']),
        documents: List<Document>.from(
            documents.map((each) => Document.fromJson(each))),
        checklists: List<ChecklistModel>.from(
            checklists.map((each) => ChecklistModel.fromJson(each))),
        is_completed: json['is_completed']);
  }
}
