import 'package:kollab_contacts/kollab_contacts.dart';

import 'globals.dart';
import 'model/AppState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

import 'Activities.dart';
import 'FolderDetail.dart';
import 'HexColor.dart';
import 'StyleGuide.dart';
import 'Timeline.dart';

class DashboardTab extends StatelessWidget {
  final DashboardModel model;

  DashboardTab({this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: HexColor('F1F1F1')),
      child: Dashboard(model: model),
    );
  }
}

class Dashboard extends StatelessWidget {
  final DashboardModel model;

  Dashboard({this.model});

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: <Widget>[
        SizedBox(height: 20),
        Wrap(
          runSpacing: 30,
          children: <Widget>[
            DashboardSection(
                title: 'Projektfortschritt',
                icon: Icons.check_circle_outline,
                innerWidget: ProgressSection(model: model)),
            if (model.activities.length > 0)
              DashboardSection(
                  title: 'Aktivitäten',
                  icon: Icons.notifications_none,
                  innerWidget: ActivitiesSection(model.activities)),
            DashboardSection(
                title: 'Letzte Dokumente',
                icon: OMIcons.insertDriveFile,
                innerWidget: DocumentsSection(model)),
            DashboardSection(
                title: 'Letzte Kontakte',
                icon: Icons.person_outline,
                innerWidget: TeamSection(model)),
          ],
        ),
        SizedBox(height: 20)
      ],
    );
  }
}

class DashboardSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget innerWidget;

  DashboardSection({this.title, this.icon, this.innerWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Row(
              children: <Widget>[
                Icon(icon, color: HexColor('888888')),
                SizedBox(width: 7),
                Text(title.toUpperCase(), style: StyleGuide().sectionTitleStyle)
              ],
            ),
          ),
          SizedBox(height: StyleGuide().sectionTitleBottomSpacing),
          innerWidget
        ],
      ),
    );
  }
}

class ProgressSection extends StatelessWidget {
  final DashboardModel model;

  ProgressSection({this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Material(
          type: MaterialType.card,
          child: InkWell(
            onTap: () => showCards(context),
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(model.progress_message,
                        style: StyleGuide().propertyListLabelStyle),
                    SizedBox(height: 12),
                    ProgressChart(progress: model.progress),
                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 3),
        Container(
            decoration: BoxDecoration(color: HexColor('F1F1F1')),
            child: CardList(cards: model.cards))
      ],
    );
  }

  showCards(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/cards');
  }
}

class ActivitiesSection extends StatelessWidget {
  final List<ActivityModel> model;

  ActivitiesSection(this.model);

  @override
  Widget build(BuildContext context) {
    return ActivitiesList(model);
  }
}

class DocumentsSection extends StatelessWidget {
  final DashboardModel model;

  DocumentsSection(this.model);

  @override
  Widget build(BuildContext context) {
    return DocumentList(model.documents);
  }
}

class TeamSection extends StatelessWidget {
  final DashboardModel model;

  TeamSection(this.model);

  @override
  Widget build(BuildContext context) {
    return ContactsList(contacts: model.contacts, theme: theme);
  }
}

class ProgressChart extends StatelessWidget {
  final int progress;

  ProgressChart({this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('$progress%', style: StyleGuide().progressLabelStyle),
        Row(
          children: <Widget>[
            Expanded(
              flex: progress,
              child: Container(
                decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.all(Radius.circular(3))),
                height: 6,
              ),
            ),
            Expanded(
              flex: 100 - progress,
              child: Container(
                height: 4,
                color: grayColor,
              ),
            ),
            Expanded(
              flex: 20,
              child: Image.asset("images/key.png"),
            )
          ],
        ),
      ],
    );
  }
}
