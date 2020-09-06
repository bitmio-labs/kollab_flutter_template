import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../card_detail.dart';
import '../shared/section_title.dart';
import '../styleguide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared/tab_header.dart';
import '../model/AppState.dart';

class CardListTab extends StatelessWidget {
  final TimelinePhases phases;

  CardListTab({this.phases});

  Widget build(BuildContext context) {
    return Container(
      color: StyleGuide().tabBackgroundColor,
      child: Timeline(phases: phases),
    );
  }
}

class Timeline extends StatelessWidget {
  final TimelinePhases phases;

  Timeline({this.phases});

  @override
  Widget build(BuildContext context) {
    if (phases == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: [
        Row(children: [TabHeader('Immer bestens vorbereitet.')]),
        PhasesList(phases: phases),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}

class PhasesList extends StatelessWidget {
  final TimelinePhases phases;

  PhasesList({this.phases});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 40,
      children: phases.items.map((each) {
        return PhaseListItem(phase: each);
      }).toList(),
    );
  }
}

class PhaseListItem extends StatelessWidget {
  final TimelinePhase phase;

  PhaseListItem({this.phase});

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
            child: CardList(cards: phase.cards))
      ],
    );
  }
}

class CardList extends StatelessWidget {
  final List<TimelineCard> cards;

  CardList({this.cards});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 3,
      children: cards.map((each) {
        return Material(
          type: MaterialType.card,
          child: InkWell(
            onTap: () => openCard(context, each),
            child: CardListItem(card: each),
          ),
        );
      }).toList(),
    );
  }

  openCard(BuildContext context, TimelineCard card) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BZCardDetail(card)));
  }
}

class CardListItem extends StatelessWidget {
  final TimelineCard card;

  CardListItem({this.card});

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
                      if (card.date != null) DateInfo(card.date),
                      if (card.checklists.length > 0)
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 3,
                          children: <Widget>[
                            Icon(MdiIcons.checkboxMarkedOutline,
                                color: StyleGuide().cardPropertyIconColor),
                            Text(
                              '${card.completedCount}/${card.totalCount}',
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
