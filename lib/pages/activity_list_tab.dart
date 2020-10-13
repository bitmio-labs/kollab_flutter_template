import 'package:kollab_template/kollab_bloc.dart';

import '../card_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../styleguide.dart';
import '../model/ActivitiesModel.dart';
import '../model/CardsModel.dart';

import '../shared/section_title.dart';
import '../shared/tab_header.dart';

class ActivitiesTab extends StatelessWidget {
  final ActivityListModel activities;
  final KollabBloc bloc;

  ActivitiesTab({@required this.activities, @required this.bloc});

  Widget build(BuildContext context) {
    return Container(
        color: StyleGuide().tabBackgroundColor,
        child: ListView(
          children: [
            Row(children: [TabHeader('Immer informiert.')]),
            Row(children: [
              Padding(
                padding: StyleGuide().defaultInsets,
                child: SectionTitle('Aktivitäten'),
              )
            ]),
            Container(height: StyleGuide().sectionTitleBottomSpacing),
            ActivitiesList(activities: activities.items, bloc: bloc),
            Container(height: 20)
          ],
        ));
  }
}

class ActivitiesList extends StatelessWidget {
  final List<ActivityModel> activities;
  final KollabBloc bloc;

  ActivitiesList({@required this.activities, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    if (activities == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Wrap(
        runSpacing: StyleGuide().cardListSpacing,
        children: activities.map((each) {
          return Material(
              type: MaterialType.card,
              child: InkWell(
                onTap: () {
                  if (each.card != null) showCard(context, each.card);
                },
                child: ActivityListItem(each),
              ));
        }).toList());
  }

  showCard(BuildContext context, TimelineCard card) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BZCardDetail(card: card, bloc: bloc)));
  }
}

class ActivityListItem extends StatelessWidget {
  final ActivityModel model;

  ActivityListItem(this.model);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: StyleGuide().defaultCardInsets,
        child: Row(children: <Widget>[
          Container(
              width: 51,
              //margin: EdgeInsets.only(right: 25),
              child: AspectRatio(
                child: CircleAvatar(
                    backgroundImage: NetworkImage(model.contact.imageURL)),
                aspectRatio: 1,
              )),
          Container(width: StyleGuide().cardIconTitleSpacing),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text(
                  model.message,
                  style: StyleGuide().cardMessageStyle,
                ),
                Container(height: StyleGuide().cardTitlePropertySpacing),
                Text(model.date, style: StyleGuide().cardPropertyStyle)
              ]))
        ]));
  }
}
