import 'package:kollab_template/API.dart';
import 'package:kollab_template/kollab_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../card_detail.dart';
import '../shared/section_title.dart';
import '../styleguide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/tab_header.dart';
import '../model/CardsModel.dart';

class CardListTab extends StatelessWidget {
  final String subtitle;
  final TimelinePhases phases;
  final KollabBloc bloc;

  CardListTab({this.subtitle, this.phases, @required this.bloc});

  Widget build(BuildContext context) {
    return Container(
      color: StyleGuide().tabBackgroundColor,
      child: Timeline(title: subtitle, phases: phases, bloc: bloc),
    );
  }
}

class Timeline extends StatelessWidget {
  final String title;
  final TimelinePhases phases;
  final KollabBloc bloc;

  Timeline({this.title, this.phases, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    if (phases == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: [
        Row(children: [TabHeader(title)]),
        PhasesList(phases: phases, bloc: bloc),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class PhasesList extends StatelessWidget {
  final TimelinePhases phases;
  final KollabBloc bloc;

  PhasesList({@required this.phases, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 40,
      children: phases.items.map((each) {
        return PhaseListItem(
          phase: each,
          bloc: bloc,
        );
      }).toList(),
    );
  }
}

class PhaseListItem extends StatelessWidget {
  final TimelinePhase phase;
  final KollabBloc bloc;

  PhaseListItem({@required this.phase, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: StyleGuide().defaultInsets,
          child: SectionTitle(phase.name),
        ),
        Container(height: StyleGuide().sectionTitleBottomSpacing),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: CardList(cards: phase.cards, bloc: bloc))
      ],
    );
  }
}

class CardList extends StatelessWidget {
  final List<TimelineCard> cards;
  final KollabBloc bloc;

  CardList({@required this.cards, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 3,
      children: cards.map((each) {
        return Material(
          type: MaterialType.card,
          child: InkWell(
            onTap: () => openCard(context, each),
            child: CardListItem(card: each, bloc: bloc),
          ),
        );
      }).toList(),
    );
  }

  openCard(BuildContext context, TimelineCard card) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BZCardDetail(card: card, bloc: bloc)));
  }
}

class CardListItem extends StatelessWidget {
  final TimelineCard card;
  final KollabBloc bloc;
  CachedChecklistState get state {
    return bloc.model.api.state;
  }

  int get completedCount {
    return card.completedCount(state);
  }

  CardListItem({@required this.card, @required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
        color:
            card.is_completed ? StyleGuide().cardCheckedBackgroundColor : null,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(card.name, style: StyleGuide().cardTitleStyle),
                    SizedBox(height: 10),
                    Wrap(spacing: 10, children: <Widget>[
                      if (card.description.length > 0)
                        Icon(MdiIcons.text,
                            color: StyleGuide().cardPropertyIconColor),
                      if (card.date != null) DateInfo(card.date),
                      if (card.checklists.length > 0)
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 3,
                          children: <Widget>[
                            Icon(MdiIcons.checkboxMarkedOutline,
                                color: StyleGuide().cardPropertyIconColor),
                            Text(
                              '${this.completedCount}/${card.totalCount}',
                              style: StyleGuide().cardPropertyStyle,
                            )
                          ],
                        ),
                      if (card.documents.length > 0)
                        Icon(MdiIcons.paperclip,
                            color: StyleGuide().cardPropertyIconColor),
                    ])
                  ]),
            ),
            card.is_completed
                ? Icon(Icons.check_circle,
                    size: 40, color: StyleGuide().cardCheckedColor)
                : (card.contact == null
                    ? SizedBox(width: 40, height: 40)
                    : Container(
                        width: 40,
                        height: 40,
                        child: AspectRatio(
                          child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(card.contact.imageURL)),
                          aspectRatio: 1,
                        )))
          ],
        ));
  }
}

class DateInfo extends StatelessWidget {
  final String date;

  DateInfo(this.date);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Icon(Icons.calendar_today, color: StyleGuide().cardPropertyIconColor),
        Text(date, style: StyleGuide().cardPropertyStyle)
      ],
    );
  }
}
