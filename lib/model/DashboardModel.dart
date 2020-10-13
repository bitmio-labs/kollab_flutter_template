// ignore_for_file: non_constant_identifier_names

import 'package:kollab_contacts/model/contact_model.dart';

import 'ActivitiesModel.dart';
import 'CardsModel.dart';
import 'DocumentsModel.dart';

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
