import 'package:kollab_contacts/model/contact_model.dart';

import 'CardsModel.dart';

class ActivityListModel {
  final List<ActivityModel> items;

  ActivityListModel({this.items});

  factory ActivityListModel.fromJson(List<dynamic> json) {
    return ActivityListModel(items: List<ActivityModel>.from(json.map((each) {
      return ActivityModel.fromJson(each);
    })));
  }
}

class ActivityModel {
  final Contact contact;
  final String message;
  final String date;
  final TimelineCard card;

  ActivityModel({this.contact, this.message, this.date, this.card});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      message: json['message'],
      date: json['date'],
      contact:
          json['contact'] == null ? null : Contact.fromJson(json['contact']),
      card: json['card'] == null ? null : TimelineCard.fromJson(json['card']),
    );
  }
}
