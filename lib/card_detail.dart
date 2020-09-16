import 'dart:ui';

import 'folder_detail.dart';
import 'styleguide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'API.dart';
import 'package:kollab_contacts/kollab_contacts.dart';
import 'model/AppState.dart';
import 'shared/section_title.dart' as MySectionTitle;
import 'globals.dart';
import 'shared/card_detail.dart';
import 'shared/checklist.dart';

class BZCardDetail extends StatelessWidget {
  final TimelineCard card;

  BZCardDetail(this.card);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    if (card.checklists.length > 0)
      widgets.add(Column(
        children: card.checklists.map((each) {
          return PersistedChecklistWidget(model: each);
        }).toList(),
      ));

    if (card.documents.length > 0)
      widgets.add(CardDetailDocuments(documents: card.documents));

    final model = CardModel(
        title: card.name,
        description: card.description,
        person: card.contact != null
            ? PersonModel(
                name: card.contact.name,
                image: Image.network(card.contact.imageURL).image)
            : null,
        date: card.date,
        background:
            card.image_url != null ? Image.network(card.image_url) : null);

    return CardDetailWidget(
        model: model,
        widgets: widgets,
        showAssignee: () => showContact(context, card.contact));
  }

  showContact(BuildContext context, Contact contact) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactDetail(
                  contact: contact,
                  theme: theme,
                )));
  }
}

class PersistedChecklistWidget extends StatefulWidget {
  final ChecklistModel model;

  ChecklistModel get mappedModel {
    return ChecklistModel(
        name: model.name,
        items: model.items
            .map((each) => ChecklistItemModel(
                name: each.name,
                id: each.id,
                is_checked: CachedChecklistState.shared.isToogled(each.id) ??
                    each.is_checked))
            .toList());
  }

  PersistedChecklistWidget({this.model});

  @override
  State<StatefulWidget> createState() {
    return _PersistedChecklistWidgetState();
  }
}

class _PersistedChecklistWidgetState extends State<PersistedChecklistWidget> {
  @override
  Widget build(BuildContext context) {
    return ChecklistWidget(
      model: widget.mappedModel,
      onToggle: (id, value) => toggleChecklistItem(context, id, value),
    );
  }

  toggleChecklistItem(BuildContext context, String id, bool value) {
    setState(() {
      CachedChecklistState.shared.toggle(id, value);
    });
  }
}

class CardDetailDocuments extends StatelessWidget {
  final List<Document> documents;

  CardDetailDocuments({this.documents});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: StyleGuide().defaultInsets,
          child: MySectionTitle.SectionTitle('Dokumente'),
        ),
        Container(height: StyleGuide().sectionTitleBottomSpacing),
        DocumentList(documents)
      ],
    );
  }
}
