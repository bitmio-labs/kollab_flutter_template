import '../shared/tab_header.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

import '../styleguide.dart';
import '../model/AppState.dart';
import '../folder_detail.dart';

class DocumentsListTab extends StatelessWidget {
  final String title;
  final Documents documents;

  DocumentsListTab({this.title, this.documents});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: StyleGuide().tabBackgroundColor,
        child: ListView(
          children: <Widget>[
            Row(children: [TabHeader('Alles an einem Ort.')]),
            Row(
              children: [
                Padding(
                  padding: StyleGuide().defaultInsets,
                  child: Text(title.toUpperCase(),
                      style: StyleGuide().sectionTitleStyle),
                ),
              ],
            ),
            SizedBox(height: StyleGuide().sectionTitleBottomSpacing),
            FolderList(documents)
          ],
        ));
  }
}

class FolderList extends StatelessWidget {
  final Documents documents;

  FolderList(this.documents);

  @override
  Widget build(BuildContext context) {
    if (documents == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Wrap(
        runSpacing: StyleGuide().cardListSpacing,
        children: documents.items.map((each) {
          return Material(
            type: MaterialType.card,
            child: InkWell(
              onTap: () {
                showFolder(context, each);
              },
              child: FolderListItem(each),
            ),
          );
        }).toList());
  }

  showFolder(BuildContext context, Folder folder) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => FolderDetailScene(folder)));
  }
}

class FolderListItem extends StatelessWidget {
  final Folder folder;

  FolderListItem(this.folder);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: StyleGuide().defaultCardInsets,
        child: Row(children: <Widget>[
          Icon(Icons.folder, size: 50, color: StyleGuide().cardIconColor),
          SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(folder.name, style: StyleGuide().cardTitleStyle),
                  Container(height: StyleGuide().cardTitlePropertySpacing),
                  Text(folder.date, style: StyleGuide().cardPropertyStyle)
                ]),
          )
        ]));
  }
}
