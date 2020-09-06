import 'dart:io';

import 'styleguide.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'model/AppState.dart';
import 'helpers/hexcolor.dart';

class FolderDetailScene extends StatelessWidget {
  final Folder folder;

  FolderDetailScene(this.folder);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(folder.name),
        ),
        body: Container(
          color: StyleGuide().tabBackgroundColor,
          child: ListView(children: [
            Container(height: 25),
            DocumentList(folder.documents),
            Container(height: 25),
          ]),
        ));
  }
}

class DocumentList extends StatelessWidget {
  final List<Document> documents;

  DocumentList(this.documents);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        runSpacing: StyleGuide().cardListSpacing,
        children: documents.map((each) {
          return Material(
            type: MaterialType.card,
            child: InkWell(
              onTap: () {
                showDocument(context, each);
              },
              child: DocumentListItem(each),
            ),
          );
        }).toList());
  }

  showDocument(BuildContext context, Document document) {
    if (Platform.isAndroid) {
      launch(document.url);
      return;
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DocumentDetailScene(document)));
  }
}

class DocumentListItem extends StatelessWidget {
  final Document document;

  DocumentListItem(this.document);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: StyleGuide().defaultCardInsets,
          child: Row(children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(vertical: 3),
                width: 50,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(width: 1, color: HexColor('F1F1F1')),
                  boxShadow: [
                    BoxShadow(
                        color: HexColor('F1F1F1'),
                        blurRadius: 6.0,
                        offset: new Offset(1.0, 1.0))
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:
                      Image.network(document.thumbnailURL, fit: BoxFit.cover),
                )),
            Container(width: StyleGuide().cardIconTitleSpacing),
            Expanded(
                child: Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                  Text(document.name, style: StyleGuide().cardTitleStyle),
                  SizedBox(height: 6),
                  Text(document.date, style: StyleGuide().cardPropertyStyle)
                ])))
          ])),
    );
  }
}

class DocumentDetailScene extends StatelessWidget {
  final Document document;

  DocumentDetailScene(this.document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(document.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: shareDocument,
            )
          ],
        ),
        body: Container(
            child: WebView(
          initialUrl: document.url,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        )));
  }

  shareDocument() {
    ShareExtend.share(document.url, 'file');
    //Share.share("Hey there")
  }
}
